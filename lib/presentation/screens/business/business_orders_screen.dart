import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BusinessOrdersScreen extends StatelessWidget {
  const BusinessOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Orders Screen - Coming Soon'),
      ),
    );
  }
}
