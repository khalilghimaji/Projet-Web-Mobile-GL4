import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

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
              colorScheme.secondaryContainer.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildForgetPasswordForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForgetPasswordForm() {
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
              onPressed: () => context.go('/login'),
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
            'Forgot Password?',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'No worries! Enter your email and we\'ll send you a new password.',
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
                    : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isSuccess
                      ? colorScheme.tertiary.withOpacity(0.5)
                      : colorScheme.primary.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isSuccess
                        ? Icons.check_circle_outline
                        : Icons.info_outline,
                    color: _isSuccess
                        ? colorScheme.onTertiaryContainer
                        : colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _isSuccess
                            ? colorScheme.onTertiaryContainer
                            : colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Email Field
          TextFormField(
            controller: _emailController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
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
                Icons.email_outlined,
                color: colorScheme.primary,
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _onResetPassword(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Reset Password Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onResetPassword,
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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _message == null ? 'Sending...' : 'Processing...',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send),
                        SizedBox(width: 8),
                        Text(
                          'Send New Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // Back to Login
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Remember your password?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Info Card
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
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'What happens next?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  icon: Icons.check_circle_outline,
                  text: 'We\'ll generate a new secure password',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.email_outlined,
                  text: 'You\'ll receive an email with your new password',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.login,
                  text: 'Use the new password to log in',
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.security,
                  text: 'Change your password after logging in for security',
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

  Future<void> _onResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
      _isSuccess = false;
    });

    try {
      // Create a custom Dio instance with longer timeouts for password reset
      final baseUrl = ref.read(openApiProvider).dio.options.baseUrl;
      final customDio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(
            seconds: 30,
          ), // Increased from 5 to 30 seconds
          receiveTimeout: const Duration(
            seconds: 60,
          ), // Increased from 10 to 60 seconds
        ),
      );

      // Copy interceptors from the main Dio instance
      final mainDio = ref.read(openApiProvider).dio;
      for (final interceptor in mainDio.interceptors) {
        customDio.interceptors.add(interceptor);
      }

      // Create authentication API with custom Dio instance
      final authApi = AuthenticationApi(
        customDio,
        ref.read(openApiProvider).serializers,
      );

      final forgotPasswordDto = ForgotPasswordDto(
        (b) => b..email = _emailController.text,
      );

      final response = await authApi.authControllerForgotPassword(
        forgotPasswordDto: forgotPasswordDto,
      );
      print("Forgot password response: ${response.toString()}");
      // Check both status code and data
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _message = response.data!.message;
          _isSuccess = true;
        });
      } else {
        // Handle non-200 status codes or null data
        setState(() {
          _message =
              response.data?.message ??
              'Failed to send password reset email. Please try again.';
          _isSuccess = false;
        });
      }
    } catch (error) {
      print("Forgot password error: ${error.toString()}");

      String errorMessage =
          'An error occurred. Please check your internet connection and try again.';

      // Handle different types of Dio exceptions
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
            errorMessage =
                'Request timed out. The server might be busy processing your request. Please try again in a moment.';
            break;
          case DioExceptionType.connectionError:
            errorMessage =
                'Network error. Please check your internet connection and try again.';
            break;
          case DioExceptionType.badResponse:
            // Handle HTTP error responses (4xx, 5xx)
            if (error.response?.statusCode == 400) {
              errorMessage =
                  'Invalid email address. Please check and try again.';
            } else if (error.response?.statusCode == 429) {
              errorMessage =
                  'Too many requests. Please wait a moment before trying again.';
            } else if (error.response?.statusCode == 500) {
              errorMessage = 'Server error. Please try again later.';
            } else {
              errorMessage =
                  error.response?.data?['message'] ??
                  'An error occurred. Please try again.';
            }
            break;
          default:
            errorMessage = 'An unexpected error occurred. Please try again.';
        }
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

  Widget _buildInfoItem({
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
    _emailController.dispose();
    super.dispose();
  }
}
