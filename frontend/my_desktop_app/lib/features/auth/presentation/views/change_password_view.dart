// 4. Change Password Screen
import 'package:flutter/material.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Implement password change logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
      key: _formKey,
      child: Column(
        children: [
          _buildPasswordField(
            controller: _currentPasswordController,
            label: 'Current Password',
            obscureText: _obscureCurrentPassword,
            onToggleVisibility: () => setState(
                () => _obscureCurrentPassword = !_obscureCurrentPassword),
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _newPasswordController,
            label: 'New Password',
            obscureText: _obscureNewPassword,
            onToggleVisibility: () =>
                setState(() => _obscureNewPassword = !_obscureNewPassword),
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm New Password',
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
            validator: (value) {
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Change Password'),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.save),),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator ??
          (value) => value?.isEmpty ?? true ? 'This field is required' : null,
    );
  }
}
