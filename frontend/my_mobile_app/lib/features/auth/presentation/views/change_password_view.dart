import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/features/auth/data/models/request/change_password_params.dart';
import 'package:my_mobile_app/features/auth/presentation/providers/change_password_provider.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final params = ChangePasswordParams(
        oldPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      final asyncValue = await ref.read(changePasswordProvider(params).future);

      asyncValue.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Theme.of(context).cardColor,
                content: Center(
                    child: Text(
                  'Failed: ${failure.message}',
                  style: TextStyle(color: Colors.red),
                ))),
          );
        },
        (success) {
                  _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Theme.of(context).cardColor,
                content: Center(
                    child: Text(
                  success,
                  style: TextStyle(color: Colors.green),
                ))),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change password'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                MyCustomButton(
                  btnText: 'Change password',
                  onClick: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
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
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator ??
          (value) => value?.isEmpty ?? true ? 'This field is required' : null,
    );
  }
}
