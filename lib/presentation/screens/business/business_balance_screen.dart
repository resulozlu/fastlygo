import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BusinessBalanceScreen extends StatelessWidget {
  const BusinessBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Balance Screen - Coming Soon'),
      ),
    );
  }
}
