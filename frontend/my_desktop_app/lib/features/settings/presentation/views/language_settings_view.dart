// 6. Language Settings Screen
import 'package:flutter/material.dart';

class LanguageSettingsScreen extends StatefulWidget {
  final String currentLanguage;

  const LanguageSettingsScreen({super.key, required this.currentLanguage});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedLanguage),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildLanguageOption('English', 'English'),
          _buildLanguageOption('Spanish', 'Español'),
          _buildLanguageOption('French', 'Français'),
          _buildLanguageOption('German', 'Deutsch'),
          _buildLanguageOption('Japanese', '日本語'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String languageCode, String languageName) {
    return RadioListTile(
      title: Text(languageName),
      value: languageCode,
      groupValue: _selectedLanguage,
      onChanged: (value) =>
          setState(() => _selectedLanguage = value.toString()),
    );
  }
}
