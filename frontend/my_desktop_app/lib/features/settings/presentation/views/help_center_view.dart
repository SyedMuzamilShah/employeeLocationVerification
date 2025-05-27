// 8. Help Center Screen
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpItem(
            icon: Icons.help_outline,
            title: 'FAQs',
            onTap: () => _showHelpContent(
                context, 'FAQs', 'Frequently Asked Questions content...'),
          ),
          _buildHelpItem(
            icon: Icons.email,
            title: 'Contact Us',
            onTap: () => _showHelpContent(context, 'Contact Us',
                'Email: support@example.com\nPhone: +1 234 567 890'),
          ),
          _buildHelpItem(
            icon: Icons.bug_report,
            title: 'Report a Bug',
            onTap: () => _showBugReportDialog(context),
          ),
          _buildHelpItem(
            icon: Icons.feedback,
            title: 'Send Feedback',
            onTap: () => _showFeedbackDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showHelpContent(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    final _bugController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: TextField(
          controller: _bugController,
          decoration: const InputDecoration(
            hintText: 'Describe the bug you encountered...',
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement bug report submission
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Bug report submitted. Thank you!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final _feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: TextField(
          controller: _feedbackController,
          decoration: const InputDecoration(
            hintText: 'Share your feedback with us...',
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement feedback submission
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
