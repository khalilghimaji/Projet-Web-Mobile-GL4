import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:openapi/openapi.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isLoading = false;
  bool _showOtpStep = false;
  bool _rememberMe = false;
  String? _errorMessage;
  String? _mfaToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _showOtpStep ? _buildOtpForm() : _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOGIN',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Good to see you again!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),

          // Error Message
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),

          // Email Field
          TextFormField(
            controller: _emailController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _onLogin(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Remember Me
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) =>
                    setState(() => _rememberMe = value ?? false),
              ),
              const Text('Remember Me'),
            ],
          ),
          const SizedBox(height: 24),

          // Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ),

          const SizedBox(height: 24),

          // Social Login
          const Text(
            'Login with Others',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Google Login
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _loginWithGoogle,
              icon: const Icon(
                Icons.g_mobiledata,
              ), // Placeholder for Google icon
              label: const Text('Sign In with Google'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // GitHub Login
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loginWithGithub,
              icon: const Icon(Icons.code), // Placeholder for GitHub icon
              label: const Text('Sign In with GitHub'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Forgot Password
          Center(
            child: TextButton(
              onPressed: () => context.go('/forget-password'),
              child: const Text('Forgot Password?'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter OTP',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Check your authenticator app for the 6-digit code',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),

        // Error Message
        if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),

        // OTP Field
        TextFormField(
          controller: _otpController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'OTP code',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.vpn_key),
          ),
          keyboardType: TextInputType.number,
          maxLength: 8,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _onVerifyOtp(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'OTP code is required';
            }
            if (value.length < 6) {
              return 'OTP code must be at least 6 characters';
            }
            if (!RegExp(r'^[0-9A-Za-z]*$').hasMatch(value)) {
              return 'OTP code contains invalid characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Verify Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onVerifyOtp,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Verify OTP'),
          ),
        ),

        const SizedBox(height: 16),

        // Back to Login
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _backToLogin,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Back to Login'),
          ),
        ),

        const SizedBox(height: 24),

        // Help Text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: const Text(
            'Enter the 6-digit code from your authenticator app like Google Authenticator or Authy',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authApi = ref.read(authenticationApiProvider);
      final dto = LoginDto(
        (b) => b
          ..email = _emailController.text
          ..password = _passwordController.text
          ..rememberMe = _rememberMe,
      );

      final response = await authApi.authControllerLogin(loginDto: dto);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('isMfaRequired: ${response.data?.isMfaRequired}');
      print('accessToken: ${response.data?.accessToken}');
      // Check if login was successful with access token (MFA disabled or not required)
      if (response.statusCode == 200 && response.data != null && response.data!.isMfaRequired != true) {
        // Ensure access token exists
        if (response.data!.accessToken != null) {
          // Store tokens and user data using auth actions
          await ref
              .read(authActionsProvider)
              .loginWithTokens(
                response.data!.accessToken!,
                response.data!.refreshToken,
                response.data!.user,
              );

          if (mounted) context.go('/home');
        } else if (response.data!.user != null) {
          // Set user data only, assuming authentication via cookies or session
          await ref.read(userDataProvider.notifier).setUser(response.data!.user!);

          if (mounted) context.go('/home');
        } else {
          setState(() {
            _errorMessage = 'Login failed. No access token or user data provided.';
          });
        }
        return;
      }

      // Check if MFA is required using the new isMfaRequired field
      if (response.statusCode == 200 && response.data?.isMfaRequired == true) {
        // Store MFA token for verification
        if (response.data?.mfaToken != null) {
          setState(() {
            _mfaToken = response.data!.mfaToken!;
          });
        }
        // MFA is required, show OTP step
        setState(() {
          _showOtpStep = true;
          _errorMessage =
              response.data?.message ??
              'MFA verification required. Please enter your OTP code.';
        });
        return;
      }

      // Check if there's a message indicating MFA requirement (fallback)
      if (response.statusCode == 200 && response.data?.message != null) {
        setState(() {
          _errorMessage = response.data!.message!;
          if (response.data!.message!.contains('MFA') ||
              response.data!.message!.contains('verification')) {
            _showOtpStep = true;
          }
        });
        return;
      }

      // If we get here, something unexpected happened
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
      });
    } catch (error) {
      print(error);
      // Handle network errors or API errors
      String errorMessage = 'Login failed. Please try again.';

      if (error is DioException) {
        if (error.response?.statusCode == 401) {
          errorMessage = 'Invalid email or password.';
        } else if (error.response?.statusCode == 403) {
          // Sometimes 403 might indicate MFA required
          setState(() {
            _showOtpStep = true;
          });
          return;
        } else if (error.response?.statusCode == 429) {
          errorMessage = 'Too many login attempts. Please try again later.';
        } else if (error.type == DioExceptionType.connectionTimeout) {
          errorMessage =
              'Connection timeout. Please check your internet connection.';
        } else if (error.type == DioExceptionType.connectionError) {
          errorMessage =
              'Connection error. Please check your internet connection.';
        }
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onVerifyOtp() async {
    if (_otpController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authApi = ref.read(authenticationApiProvider);
      final dto = MfaVerifyDto(
        (b) => b
          ..code = _otpController.text
          ..rememberMe = _rememberMe,
      );

      final response = await authApi.authControllerVerifyMfaToken(
        mfaVerifyDto: dto,
        headers: _mfaToken != null
            ? {'Authorization': 'Bearer $_mfaToken'}
            : null,
      );

      // Check if MFA verification was successful
      if (response.statusCode == 200 && response.data?.accessToken != null) {
        // Store tokens and user data using auth actions
        await ref
            .read(authActionsProvider)
            .loginWithTokens(
              response.data!.accessToken!,
              response.data!.refreshToken,
              response.data!.user,
            );

        if (mounted) context.go('/home');
      } else {
        setState(() {
          _errorMessage =
              'OTP verification failed. Please check your code and try again.';
        });
      }
    } catch (error) {
      String errorMessage = 'OTP verification failed. Please try again.';

      if (error is DioException) {
        if (error.response?.statusCode == 401) {
          errorMessage = 'Invalid OTP code.';
        } else if (error.response?.statusCode == 403) {
          errorMessage = 'OTP verification expired. Please login again.';
        } else if (error.response?.statusCode == 429) {
          errorMessage = 'Too many attempts. Please try again later.';
        }
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _backToLogin() {
    setState(() {
      _showOtpStep = false;
      _otpController.clear();
      _errorMessage = null;
      _isLoading = false;
    });
  }

  Future<void> _loginWithGoogle() async {
    // TODO: Implement Google OAuth
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login not implemented yet')),
    );
  }

  Future<void> _loginWithGithub() async {
    // TODO: Implement GitHub OAuth
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('GitHub login not implemented yet')),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
