import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:dio/dio.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              colorScheme.surface,
              colorScheme.tertiaryContainer.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildChangePasswordForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.go('/home'),
              icon: Icon(Icons.arrow_back, color: colorScheme.primary),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.lock_reset,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'Change Password',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Enter your current password and choose a secure new one.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Message Display
          if (_message != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: _isSuccess
                    ? colorScheme.tertiaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isSuccess
                      ? colorScheme.tertiary.withOpacity(0.5)
                      : colorScheme.error.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isSuccess
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: _isSuccess
                        ? colorScheme.onTertiaryContainer
                        : colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _isSuccess
                            ? colorScheme.onTertiaryContainer
                            : colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Old Password Field
          TextFormField(
            controller: _oldPasswordController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Current Password',
              hintText: 'Enter your current password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() {
                    _obscureOldPassword = !_obscureOldPassword;
                  });
                },
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
            obscureText: _obscureOldPassword,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Current password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // New Password Field
          TextFormField(
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter your new password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              prefixIcon: Icon(Icons.vpn_key, color: colorScheme.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              filled: true,
              fillColor: colorScheme.surface,
              helperText: 'Min 8 chars with uppercase, lowercase & number',
              helperMaxLines: 2,
            ),
            obscureText: _obscureNewPassword,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'New password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                return 'Password must contain at least one lowercase letter';
              }
              if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                return 'Password must contain at least one uppercase letter';
              }
              if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                return 'Password must contain at least one number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm New Password Field
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              hintText: 'Re-enter your new password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              prefixIcon: Icon(
                Icons.check_circle_outline,
                color: colorScheme.primary,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _onChangePassword(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your new password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Change Password Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: colorScheme.primary.withOpacity(0.4),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.security),
                        SizedBox(width: 8),
                        Text(
                          'Update Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 32),

          // Security Tips Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, color: colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Password Security Tips',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSecurityTip(
                  icon: Icons.check_circle_outline,
                  text: 'Use a mix of letters, numbers, and symbols',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _buildSecurityTip(
                  icon: Icons.check_circle_outline,
                  text: 'Make it at least 8 characters long',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _buildSecurityTip(
                  icon: Icons.check_circle_outline,
                  text: 'Avoid using common words or personal information',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _buildSecurityTip(
                  icon: Icons.check_circle_outline,
                  text: 'Don\'t reuse passwords from other accounts',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
      _isSuccess = false;
    });

    try {
      // Create a custom Dio instance with longer timeouts for password change
      final baseUrl = ref.read(openApiProvider).dio.options.baseUrl;
      final customDio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(
            seconds: 30,
          ), // Increased from 5 to 30 seconds
          receiveTimeout:
              Duration.zero, // No receive timeout - let our wrapper handle it
        ),
      );

      // Manually add authorization header instead of copying all interceptors
      final accessToken = ref.read(accessTokenProvider);
      if (accessToken != null) {
        customDio.options.headers['Authorization'] = 'Bearer $accessToken';
      }

      final requestBody = {
        'token': _oldPasswordController.text, // Old password as token
        'password': _newPasswordController.text, // New password
      };

      print("About to send change password request...");
      print(
        "Request body: token=${_oldPasswordController.text.isNotEmpty ? '[HIDDEN]' : 'empty'}, password=${_newPasswordController.text.isNotEmpty ? '[HIDDEN]' : 'empty'}",
      );

      // Add timeout wrapper to force failure if hanging
      final response = await customDio
          .post('/auth/reset-password', data: requestBody)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              print("Request timed out after 30 seconds");
              throw DioException(
                requestOptions: RequestOptions(path: '/auth/reset-password'),
                type: DioExceptionType.receiveTimeout,
                message: 'Request timed out after 30 seconds',
              );
            },
          );

      print(
        "Change password response received: status=${response.statusCode}, data=${response.data}",
      );

      // Check both status code and data
      if (response.statusCode == 201 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        setState(() {
          _message = responseData['message'] ?? 'Password changed successfully';
          _isSuccess = true;
        });

        // Clear form on success
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // Show success message and navigate back after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go('/home');
          }
        });
      } else {
        // Handle non-201 status codes or null data
        print(
          "Change password failed with status: ${response.statusCode}, data: ${response.data}",
        );
        final responseData = response.data as Map<String, dynamic>?;
        setState(() {
          _message =
              responseData?['message'] ??
              'Failed to change password. Please try again.';
          _isSuccess = false;
        });
      }
    } catch (error) {
      print("Change password error caught: ${error.toString()}");
      print("Error type: ${error.runtimeType}");

      String errorMessage =
          'An error occurred. Please check your current password and try again.';

      // Handle different types of Dio exceptions
      if (error is DioException) {
        print("DioException type: ${error.type}");
        print("DioException response: ${error.response}");
        print("DioException status code: ${error.response?.statusCode}");

        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            print("Connection timeout occurred");
            errorMessage =
                'Connection timed out. Please try again in a moment.';
            break;
          case DioExceptionType.receiveTimeout:
            print("Receive timeout occurred");
            errorMessage = 'Request timed out. Please try again in a moment.';
            break;
          case DioExceptionType.connectionError:
            print("Connection error occurred");
            errorMessage =
                'Network error. Please check your internet connection and try again.';
            break;
          case DioExceptionType.badResponse:
            print("Bad response received");
            // Handle HTTP error responses (4xx, 5xx)
            if (error.response?.statusCode == 400) {
              print("400 Bad Request");
              errorMessage =
                  'Invalid current password. Please check and try again.';
            } else if (error.response?.statusCode == 401) {
              print("401 Unauthorized");
              errorMessage = 'Wrong password.';
            } else if (error.response?.statusCode == 500) {
              print("500 Internal Server Error");
              errorMessage = 'Server error. Please try again later.';
            } else {
              print("Other error status: ${error.response?.statusCode}");
              errorMessage =
                  error.response?.data?['message'] ??
                  'An error occurred. Please try again.';
            }
            break;
          default:
            print("Other DioException type: ${error.type}");
            errorMessage = 'An unexpected error occurred. Please try again.';
        }
      } else {
        print("Non-Dio error: ${error.runtimeType}");
      }

      setState(() {
        _message = errorMessage;
        _isSuccess = false;
        _isLoading = false; // Ensure loading is reset on error
      });
    } finally {
      // This will only run if no exception was thrown
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSecurityTip({
    required IconData icon,
    required String text,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
