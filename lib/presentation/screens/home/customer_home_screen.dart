import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FastlyGo'), backgroundColor: Color(0xFFFF6B35)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 100, color: Color(0xFFFF6B35)),
            SizedBox(height: 20),
            Text('FastlyGo Customer', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('v12.0.0', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 40),
            Text('🇬🇧 English | 🇹🇷 Türkçe | 🇲🇰 Македонски', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
