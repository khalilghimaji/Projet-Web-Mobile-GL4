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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildChangePasswordForm(),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHANGE PASSWORD',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your current password and choose a new one.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),

          // Message Display
          if (_message != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isSuccess
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Text(
                _message!,
                style: TextStyle(
                  color: _isSuccess
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ),

          // Old Password Field
          TextFormField(
            controller: _oldPasswordController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Current Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureOldPassword = !_obscureOldPassword;
                  });
                },
              ),
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
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
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
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_reset),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Change Password'),
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

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
