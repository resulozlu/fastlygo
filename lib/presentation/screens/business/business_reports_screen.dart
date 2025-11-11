import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BusinessReportsScreen extends StatelessWidget {
  const BusinessReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Reports Screen - Coming Soon'),
      ),
    );
  }
}
