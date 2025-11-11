import 'package:flutter/material.dart';
import '../auth/language_selection_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 100, color: Color(0xFFFF6B35)),
            SizedBox(height: 20),
            Text('Welcome to FastlyGo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LanguageSelectionScreen())),
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
