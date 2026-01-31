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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildForgetPasswordForm(),
      ),
    );
  }

  Widget _buildForgetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESET PASSWORD',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your email address and we\'ll send you a new password.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),

          // Message Display
          if (_message != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _isSuccess ? Colors.green.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isSuccess
                      ? Colors.green.shade200
                      : Colors.blue.shade200,
                ),
              ),
              child: Text(
                _message!,
                style: TextStyle(
                  color: _isSuccess
                      ? Colors.green.shade800
                      : Colors.blue.shade800,
                ),
              ),
            ),

          // Email Field
          TextFormField(
            controller: _emailController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _message == null ? 'Sending...' : 'Processing...',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  : const Text('Send New Password'),
            ),
          ),

          const SizedBox(height: 16),

          // Back to Login
          Center(
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Back to Login'),
            ),
          ),

          const SizedBox(height: 32),

          // Info Text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What happens next?',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '• We\'ll generate a new secure password for your account\n'
                  '• You\'ll receive an email with your new password\n'
                  '• Use the new password to log in\n'
                  '• Change your password immediately after logging in for security',
                  style: Theme.of(context).textTheme.bodySmall,
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
