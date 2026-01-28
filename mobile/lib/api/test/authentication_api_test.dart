import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AuthenticationApi
void main() {
  final instance = Openapi().getAuthenticationApi();

  group(AuthenticationApi, () {
    // Disable MFA for user account
    //
    //Future<MfaDisableResponseDto> authControllerDisableMfa(DisableMfaDto disableMfaDto) async
    test('test authControllerDisableMfa', () async {
      // TODO
    });

    // Enable MFA for user account
    //
    //Future<MfaEnableResponseDto> authControllerEnableMfa(MfaEnableDto mfaEnableDto) async
    test('test authControllerEnableMfa', () async {
      // TODO
    });

    // Request password reset email
    //
    //Future<ForgotPasswordResponseDto> authControllerForgotPassword(ForgotPasswordDto forgotPasswordDto) async
    test('test authControllerForgotPassword', () async {
      // TODO
    });

    // Generate MFA secret and QR code
    //
    //Future<MfaGenerateResponseDto> authControllerGenerateMfaSecret() async
    test('test authControllerGenerateMfaSecret', () async {
      // TODO
    });

    // Get authenticated user profile
    //
    //Future<UserDto> authControllerGetProfile() async
    test('test authControllerGetProfile', () async {
      // TODO
    });

    // Initiate GitHub OAuth login flow
    //
    //Future authControllerGithubAuth() async
    test('test authControllerGithubAuth', () async {
      // TODO
    });

    // Handle GitHub OAuth callback
    //
    //Future<OAuthResponseDto> authControllerGithubAuthCallback() async
    test('test authControllerGithubAuthCallback', () async {
      // TODO
    });

    // Initiate Google OAuth login flow
    //
    //Future authControllerGoogleAuth() async
    test('test authControllerGoogleAuth', () async {
      // TODO
    });

    // Handle Google OAuth callback
    //
    //Future<OAuthResponseDto> authControllerGoogleAuthCallback() async
    test('test authControllerGoogleAuthCallback', () async {
      // TODO
    });

    // User login
    //
    //Future<LoginResponseDto> authControllerLogin(LoginDto loginDto) async
    test('test authControllerLogin', () async {
      // TODO
    });

    // User logout
    //
    //Future<LogoutResponseDto> authControllerLogout() async
    test('test authControllerLogout', () async {
      // TODO
    });

    // Refresh access token
    //
    //Future<RefresResponse> authControllerRefreshToken() async
    test('test authControllerRefreshToken', () async {
      // TODO
    });

    // Reset password with token
    //
    //Future<ResetPasswordResponseDto> authControllerResetPassword(ResetPasswordDto resetPasswordDto) async
    test('test authControllerResetPassword', () async {
      // TODO
    });

    // Register a new user
    //
    //Future<SignUpResponseDto> authControllerSignUp(String firstName, String lastName, String email, String password, { MultipartFile imageUrl }) async
    test('test authControllerSignUp', () async {
      // TODO
    });

    // Verify user email address
    //
    //Future<VerifyEmailResponseDto> authControllerVerifyEmail(VerifyEmailDto verifyEmailDto) async
    test('test authControllerVerifyEmail', () async {
      // TODO
    });

    // Verify MFA code during login
    //
    //Future<MfaVerifyResponseDto> authControllerVerifyMfaToken(MfaVerifyDto mfaVerifyDto) async
    test('test authControllerVerifyMfaToken', () async {
      // TODO
    });

  });
}
