import 'package:flutter/material.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        // color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Our Commitment to Your Privacy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'We value your privacy and are committed to protecting your personal information. '
                    'This policy explains how data is collected, used, and safeguarded within our application.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              _buildPolicySection(
                title: "1. Data Collection",
                content: [
                  "We collect employee location data when verification is requested.",
                  "We may collect employee images for facial recognition.",
                  "Basic user account details (name, email, role) are stored for system use."
                ],
              ),
              _buildPolicySection(
                title: "2. Data Usage",
                content: [
                  "Location data is used only for verifying presence at a work site.",
                  "Facial recognition images are used exclusively for identity verification.",
                  "Data is never sold or shared with third parties."
                ],
              ),
              _buildPolicySection(
                title: "3. Data Protection",
                content: [
                  "All data is transmitted using secure encryption.",
                  "Images and location data are stored securely.",
                  "Only authorized personnel have access to sensitive data."
                ],
              ),
              _buildPolicySection(
                title: "4. Data Retention",
                content: [
                  "Data is retained only as long as required for verification.",
                  "After retention, it is permanently deleted from the system."
                ],
              ),
              _buildPolicySection(
                title: "5. User Rights",
                content: [
                  "Employees can request access to their stored data.",
                  "Employees may request correction or deletion of their information."
                ],
              ),
              _buildPolicySection(
                title: "6. Contact",
                content: [
                  "For concerns or queries, please contact the system administrator."
                ],
              ),

              const SizedBox(height: 16),
              Center(
                child: MyCustomButton(btnText: 'Back', onClick: ()=> Navigator.pop(context), )
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required List<String> content,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...content.map(
              (point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
