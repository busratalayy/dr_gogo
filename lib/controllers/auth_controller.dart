import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<String?> registerOwner({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (fullName.trim().isEmpty) {
      return "Full name cannot be empty.";
    }

    if (email.trim().isEmpty) {
      return "Email cannot be empty.";
    }

    if (!email.contains("@")) {
      return "Please enter a valid email address.";
    }

    if (password.length < 6) {
      return "Password must be at least 6 characters.";
    }

    if (password != confirmPassword) {
      return "Passwords do not match.";
    }

    try {
      await _authService.registerOwner(
        fullName: fullName,
        email: email,
        password: password,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginOwner({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      return "Email cannot be empty.";
    }

    if (password.trim().isEmpty) {
      return "Password cannot be empty.";
    }

    try {
      await _authService.loginOwner(
        email: email,
        password: password,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logoutOwner() async {
    await _authService.logoutOwner();
  }
}