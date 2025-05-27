// 7. Privacy Policy Screen
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          'Privacy Policy Content\n\n'
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
          'Nullam auctor, nisl eget ultricies tincidunt, nisl nisl aliquam nisl, '
          'eget ultricies nisl nisl eget nisl. Nullam auctor, nisl eget ultricies '
          'tincidunt, nisl nisl aliquam nisl, eget ultricies nisl nisl eget nisl.\n\n'
          '1. Data Collection\nWe collect data to provide better service...\n\n'
          '2. Data Usage\nYour data is used to improve our services...\n\n'
          '3. Data Protection\nWe implement security measures to protect your data...',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
