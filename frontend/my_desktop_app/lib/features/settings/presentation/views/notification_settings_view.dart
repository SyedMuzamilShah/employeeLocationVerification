
// 5. Notification Settings Screen
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onSettingsChanged;

  const NotificationSettingsScreen({
    super.key,
    required this.notificationsEnabled,
    required this.onSettingsChanged,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.onSettingsChanged(_notificationsEnabled);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationSwitch(),
            const SizedBox(height: 16),
            if (_notificationsEnabled) ...[
              _buildNotificationType('Email Notifications', _emailNotifications,
                  (value) => setState(() => _emailNotifications = value)),
              _buildNotificationType('Push Notifications', _pushNotifications,
                  (value) => setState(() => _pushNotifications = value)),
              const Divider(),
              _buildNotificationPreference('Enable Sound', _soundEnabled,
                  (value) => setState(() => _soundEnabled = value)),
              _buildNotificationPreference(
                  'Enable Vibration',
                  _vibrationEnabled,
                  (value) => setState(() => _vibrationEnabled = value)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Enable Notifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Switch(
          value: _notificationsEnabled,
          onChanged: (value) => setState(() => _notificationsEnabled = value),
        ),
      ],
    );
  }

  Widget _buildNotificationType(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildNotificationPreference(
      String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
    );
  }
}
