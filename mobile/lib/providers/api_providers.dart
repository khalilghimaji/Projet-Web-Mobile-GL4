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
import 'dart:async';
import 'package:mobile/providers/notifications_provider.dart';
import 'package:mobile/providers/rankings_provider.dart';

// Token validation interceptor
class TokenValidationInterceptor extends Interceptor {
  final Dio _dio;
  final Ref _ref;
  bool _isRefreshing = false;
  final _refreshTokenSubject = StreamController<bool>.broadcast();

  TokenValidationInterceptor(this._dio, this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip token validation for auth endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(err.requestOptions.path)) {
      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          // Attempt to refresh the token
          final success = await _refreshToken();

          if (success) {
            // Retry the original request with new token
            final newOptions = err.requestOptions;
            final response = await _dio.fetch(newOptions);
            _isRefreshing = false;
            _refreshTokenSubject.add(true);
            return handler.resolve(response);
          } else {
            // Refresh failed, logout
            await _logoutUser();
            _isRefreshing = false;
            return handler.next(err);
          }
        } catch (refreshError) {
          // Refresh failed, logout
          await _logoutUser();
          _isRefreshing = false;
          return handler.next(err);
        }
      } else {
        // Wait for token refresh to complete
        await _refreshTokenSubject.stream.first;
        // Retry the original request
        try {
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (retryError) {
          // Retry failed, logout
          await _logoutUser();
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    // Skip token validation for login, signup and refresh endpoints
    const skipPaths = [
      '/auth/login',
      '/auth/signup',
      '/auth/refresh',
      '/auth/verify-email',
      '/auth/profile',
    ];

    return skipPaths.any((endpoint) => path.contains(endpoint));
  }

  Future<bool> _refreshToken() async {
    try {
      print('[TOKEN] Attempting to refresh token...');

      final refreshToken = _ref.read(refreshTokenProvider);
      if (refreshToken == null) {
        print('[TOKEN] No refresh token available');
        return false;
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null) {
          // Update stored tokens
          await _ref
              .read(accessTokenProvider.notifier)
              .setToken(newAccessToken);
          if (newRefreshToken != null) {
            await _ref
                .read(refreshTokenProvider.notifier)
                .setToken(newRefreshToken);
          }

          print('[TOKEN] Token refreshed successfully');
          return true;
        }
      }

      print('[TOKEN] Token refresh failed - invalid response');
      return false;
    } catch (e) {
      print('[TOKEN] Token refresh error: $e');
      return false;
    }
  }

  Future<void> _logoutUser() async {
    try {
      print('[TOKEN] Logging out user due to token refresh failure');

      // Clear stored tokens and user data
      await _ref.read(accessTokenProvider.notifier).clearToken();
      await _ref.read(refreshTokenProvider.notifier).clearToken();
      await _ref.read(userDataProvider.notifier).clearUser();

      print('[TOKEN] User logged out successfully');
    } catch (e) {
      print('[TOKEN] Logout failed: $e');
    }
  }

  void dispose() {
    _refreshTokenSubject.close();
  }
}

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

// Gained diamonds provider
final gainedDiamondsProvider =
    StateNotifierProvider<GainedDiamondsNotifier, int>((ref) {
      return GainedDiamondsNotifier(ref);
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

  // Add token validation interceptor
  final tokenInterceptor = TokenValidationInterceptor(dio, ref);
  dio.interceptors.add(tokenInterceptor);

  // Add auth interceptor for adding tokens to requests
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add Authorization header if access token is available
        final accessToken = ref.read(accessTokenProvider);
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
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

  UserDataNotifier(this._ref) : super(null) {
    _loadUser();
  }

  static const String _userKey = 'user_data';

  Future<void> _loadUser() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    final userJson = prefs.getString(_userKey);

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

  Future<void> clearUser() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_userKey);
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
    await _ref.read(gainedDiamondsProvider.notifier).clearGainedDiamonds();

    // Clear user-specific data
    _ref.read(notificationsProvider.notifier).clearAllNotifications();
    _ref.read(rankingsProvider.notifier).clearAllRankings();
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

// Gained diamonds notifier
class GainedDiamondsNotifier extends StateNotifier<int> {
  final Ref _ref;

  GainedDiamondsNotifier(this._ref) : super(0) {
    _loadGainedDiamonds();
  }

  static const String _gainedDiamondsKey = 'gained_diamonds';

  Future<void> _loadGainedDiamonds() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    final gainedDiamondsStr = prefs.getString(_gainedDiamondsKey);
    if (gainedDiamondsStr != null) {
      state = int.tryParse(gainedDiamondsStr) ?? 0;
    }
  }

  void updateGainedDiamonds(int gain) {
    state = gain;
    // Persist asynchronously without blocking UI update
    _persistGainedDiamonds(gain);
  }

  Future<void> setGainedDiamonds(int gain) async {
    state = gain;
    await _persistGainedDiamonds(gain);
  }

  Future<void> _persistGainedDiamonds(int gain) async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_gainedDiamondsKey, gain.toString());
  }

  Future<void> clearGainedDiamonds() async {
    state = 0;
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_gainedDiamondsKey);
  }
}
