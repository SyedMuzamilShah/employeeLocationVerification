import 'package:flutter/material.dart';
import 'package:my_desktop_app/core/constants/app_constants.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "General Support",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildHelpItem(
            icon: Icons.help_outline,
            title: 'FAQs',
            color: Colors.blue,
            onTap: () => _showHelpContent(
              context,
              'FAQs',
              'Frequently Asked Questions content will be added here.',
            ),
          ),
          _buildHelpItem(
            icon: Icons.email,
            title: 'Contact Us',
            color: Colors.green,
            onTap: () => _showHelpContent(
              context,
              'Contact Us',
              'Email: techIbac@gmail.com\nPhone: +92 313 0183976',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Feedback & Issues",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildHelpItem(
            icon: Icons.bug_report,
            title: 'Report a Bug',
            color: Colors.red,
            onTap: () => _showBugReportDialog(context),
          ),
          _buildHelpItem(
            icon: Icons.feedback,
            title: 'Send Feedback',
            color: Colors.orange,
            onTap: () => _showFeedbackDialog(context),
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Center(
            child: Text(AppConstants.copyright,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showHelpContent(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Report a Bug'),
        content: const SizedBox(
          height: 150,
          child: Center(
            child: Text(
              "This feature will be added soon.",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Send Feedback'),
        content: const SizedBox(
          height: 150,
          child: Center(
            child: Text(
              "This feature will be added soon.",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
