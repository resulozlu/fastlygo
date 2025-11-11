import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../home/main_home_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Select Language')),
      body: ListView(
        children: languageProvider.supportedLanguages.map((lang) {
          return ListTile(
            leading: Text(lang['flag']!, style: const TextStyle(fontSize: 32)),
            title: Text(lang['name']!),
            trailing: languageProvider.languageCode == lang['code'] ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () async {
              await languageProvider.setLanguage(lang['code']!);
              if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainHomeScreen()));
            },
          );
        }).toList(),
      ),
    );
  }
}
