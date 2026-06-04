import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isCurrentVisible = false;
  bool isNewVisible = false;
  bool isConfirmVisible = false;
  bool isLoading = false;

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No logged in user found."),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPasswordController.text.trim());

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully!"),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      String message = "Password could not be updated.";

      if (e.code == "wrong-password") {
        message = "Current password is incorrect.";
      } else if (e.code == "weak-password") {
        message = "New password is too weak.";
      } else if (e.code == "requires-recent-login") {
        message = "Please login again and try changing your password.";
      } else if (e.code == "network-request-failed") {
        message = "Network error. Please check your internet connection.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      size: 48,
                      color: accentColor,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Update Your Password",
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Enter your current password and choose a new secure password.",
                  style: TextStyle(
                    fontSize: 15,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      buildPasswordField(
                        controller: currentPasswordController,
                        label: "Current Password",
                        isVisible: isCurrentVisible,
                        onVisibilityChanged: () {
                          setState(() {
                            isCurrentVisible = !isCurrentVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your current password";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      buildPasswordField(
                        controller: newPasswordController,
                        label: "New Password",
                        isVisible: isNewVisible,
                        onVisibilityChanged: () {
                          setState(() {
                            isNewVisible = !isNewVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a new password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          if (value == currentPasswordController.text) {
                            return "New password must be different";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      buildPasswordField(
                        controller: confirmPasswordController,
                        label: "Confirm New Password",
                        isVisible: isConfirmVisible,
                        onVisibilityChanged: () {
                          setState(() {
                            isConfirmVisible = !isConfirmVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your new password";
                          }
                          if (value != newPasswordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            "Update Password",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "For security reasons, you need to enter your current password before changing it.",
                          style: TextStyle(
                            color: subtitleColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: accentColor,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: subtitleColor,
          ),
          onPressed: onVisibilityChanged,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: subtitleColor),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}