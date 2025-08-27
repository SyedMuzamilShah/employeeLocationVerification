// 3. Edit Profile Screen
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_desktop_app/features/dashboard/presentation/providers/user_profile_provider.dart';
class EditProfileView extends ConsumerStatefulWidget {
  final UserEntities userProfile;

  const EditProfileView({super.key, required this.userProfile});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  // late final TextEditingController _bioController;
  File? _profileImage;
  late UserEntities user;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      user = await ref.read(userDataProvider.future);
    });
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(text: widget.userProfile.phoneNumber);
    // _bioController = TextEditingController(text: widget.userProfile.);
    // _profileImage = user;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() => _profileImage = File(pickedFile.path));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.save),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/avatar.jpg')
                        as ImageProvider,
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue,
                    child:
                        Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileFormField(
              label: 'Full Name',
              icon: Icons.person,
              controller: _nameController,
            ),
            _buildProfileFormField(
              label: 'Email',
              icon: Icons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              readOnly: true
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}