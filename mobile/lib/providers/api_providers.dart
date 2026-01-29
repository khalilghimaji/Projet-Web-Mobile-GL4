import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'dart:convert';
import 'package:openapi/openapi.dart';

// Storage providers
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

// Cookie jar provider for managing HTTP cookies
final cookieJarProvider = Provider<CookieJar>((ref) {
  return CookieJar();
});

// Auth token providers
final accessTokenProvider = StateNotifierProvider<AuthTokenNotifier, String?>((
  ref,
) {
  return AuthTokenNotifier(ref.watch(secureStorageProvider));
});

final refreshTokenProvider =
    StateNotifierProvider<RefreshTokenNotifier, String?>((ref) {
      return RefreshTokenNotifier(ref.watch(secureStorageProvider));
    });

// User data provider
final userDataProvider = StateNotifierProvider<UserDataNotifier, UserDto?>((
  ref,
) {
  return UserDataNotifier(ref);
});

// Authentication state provider
final authStateProvider = Provider<AuthState>((ref) {
  final accessToken = ref.watch(accessTokenProvider);
  final user = ref.watch(userDataProvider);
  return AuthState(
    isAuthenticated: accessToken != null || user != null,
    accessToken: accessToken,
    user: user,
  );
});

// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) {
  // Determine the correct base URL based on platform
  String baseUrl;
  if (kIsWeb) {
    baseUrl = 'http://localhost:3003'; // Web browser
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    baseUrl = 'http://10.0.2.2:3003'; // Android emulator
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    baseUrl =
        'http://localhost:3003'; // iOS simulator (or use your computer's IP)
  } else {
    baseUrl = 'http://localhost:3003'; // Desktop or other platforms
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Add cookie manager for automatic cookie handling
  final cookieJar = ref.read(cookieJarProvider);
  dio.interceptors.add(CookieManager(cookieJar));

  // Add interceptors
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add Authorization header if access token is available
        final accessToken = ref.read(accessTokenProvider);
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        // Cookies are automatically managed by CookieManager for other purposes
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token refresh on 401 errors
        if (error.response?.statusCode == 401) {
          try {
            // Get the refresh token
            final refreshToken = ref.read(refreshTokenProvider);
            if (refreshToken != null) {
              // Attempt to refresh the token
              final refreshResponse = await dio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
              );

              if (refreshResponse.statusCode == 200) {
                // Get new tokens from response
                final newAccessToken = refreshResponse.data['accessToken'];
                final newRefreshToken = refreshResponse.data['refreshToken'];

                if (newAccessToken != null) {
                  await ref
                      .read(accessTokenProvider.notifier)
                      .setToken(newAccessToken);
                }
                if (newRefreshToken != null) {
                  await ref
                      .read(refreshTokenProvider.notifier)
                      .setToken(newRefreshToken);
                }

                // Retry the original request
                final retryResponse = await dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              }
            }
          } catch (refreshError) {
            // Refresh failed, logout
            print('Token refresh failed: $refreshError');
            ref.read(accessTokenProvider.notifier).clearToken();
            ref.read(refreshTokenProvider.notifier).clearToken();
            ref.read(userDataProvider.notifier).clearUser();
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});

// Provider for OpenAPI client
final openApiProvider = Provider<Openapi>((ref) {
  final dio = ref.watch(dioProvider);
  return Openapi(dio: dio);
});

// Specific API providers
final authenticationApiProvider = Provider<AuthenticationApi>((ref) {
  return ref.watch(openApiProvider).getAuthenticationApi();
});

final userApiProvider = Provider<UserApi>((ref) {
  return ref.watch(openApiProvider).getUserApi();
});

final matchesApiProvider = Provider<MatchesApi>((ref) {
  return ref.watch(openApiProvider).getMatchesApi();
});

final notificationsApiProvider = Provider<NotificationsApi>((ref) {
  return ref.watch(openApiProvider).getNotificationsApi();
});

final appApiProvider = Provider<AppApi>((ref) {
  return ref.watch(openApiProvider).getAppApi();
});

// Auth state class
class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final UserDto? user;

  const AuthState({required this.isAuthenticated, this.accessToken, this.user});
}

// Token notifiers
class AuthTokenNotifier extends StateNotifier<String?> {
  final FlutterSecureStorage _storage;

  AuthTokenNotifier(this._storage) : super(null) {
    _loadToken();
  }

  static const String _tokenKey = 'access_token';

  Future<void> _loadToken() async {
    final token = await _storage.read(key: _tokenKey);
    state = token;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    state = token;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    state = null;
  }
}

class RefreshTokenNotifier extends StateNotifier<String?> {
  final FlutterSecureStorage _storage;

  RefreshTokenNotifier(this._storage) : super(null) {
    _loadToken();
  }

  static const String _tokenKey = 'refresh_token';

  Future<void> _loadToken() async {
    final token = await _storage.read(key: _tokenKey);
    state = token;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    state = token;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    state = null;
  }
}

// User data notifier
class UserDataNotifier extends StateNotifier<UserDto?> {
  final Ref _ref;
  int _gainedDiamonds = 0;

  UserDataNotifier(this._ref) : super(null) {
    _loadUser();
  }

  static const String _userKey = 'user_data';
  static const String _gainedDiamondsKey = 'gained_diamonds';

  int get gainedDiamonds => _gainedDiamonds;

  Future<void> _loadUser() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    final userJson = prefs.getString(_userKey);
    final gainedDiamondsStr = prefs.getString(_gainedDiamondsKey);

    if (gainedDiamondsStr != null) {
      _gainedDiamonds = int.tryParse(gainedDiamondsStr) ?? 0;
    }

    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user =
            standardSerializers.deserializeWith(UserDto.serializer, userMap)
                as UserDto;
        state = user;
      } catch (e) {
        // If deserialization fails, clear the stored data
        await prefs.remove(_userKey);
      }
    }
  }

  Future<void> setUser(UserDto user) async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    final userJson = jsonEncode(
      standardSerializers.serializeWith(UserDto.serializer, user),
    );
    await prefs.setString(_userKey, userJson);
    state = user;
  }

  Future<void> updateDiamonds(int newDiamonds) async {
    if (state != null) {
      final updatedUser = state!.rebuild((b) => b.diamonds = newDiamonds);
      await setUser(updatedUser);
    }
  }

  Future<void> updateGainedDiamonds(int gain) async {
    _gainedDiamonds = gain;
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_gainedDiamondsKey, gain.toString());
  }

  Future<void> clearUser() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_userKey);
    await prefs.remove(_gainedDiamondsKey);
    _gainedDiamonds = 0;
    state = null;
  }
}

// Authentication actions provider
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref);
});

class AuthActions {
  final Ref _ref;

  AuthActions(this._ref);

  Future<void> logout() async {
    try {
      // Call the logout API endpoint to clear server-side cookies
      final authApi = _ref.read(authenticationApiProvider);
      await authApi.authControllerLogout();
    } catch (error) {
      // Even if the API call fails, we should still clear local data
      print('Logout API call failed: $error');
    }

    // Clear local cookie storage
    final cookieJar = _ref.read(cookieJarProvider);
    await cookieJar.deleteAll();

    // Clear all stored authentication data
    await _ref.read(accessTokenProvider.notifier).clearToken();
    await _ref.read(refreshTokenProvider.notifier).clearToken();
    await _ref.read(userDataProvider.notifier).clearUser();
  }

  Future<void> loginWithTokens(
    String? accessToken,
    String? refreshToken,
    UserDto? user,
  ) async {
    if (accessToken != null) {
      await _ref.read(accessTokenProvider.notifier).setToken(accessToken);
    }
    if (refreshToken != null) {
      await _ref.read(refreshTokenProvider.notifier).setToken(refreshToken);
    }
    if (user != null) {
      await _ref.read(userDataProvider.notifier).setUser(user);
    }
  }
}
