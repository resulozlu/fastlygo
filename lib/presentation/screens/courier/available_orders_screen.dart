import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AvailableOrdersScreen extends StatelessWidget {
  const AvailableOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Available Orders'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OrderCard(
              orderId: '#ORD-12${34 + index}',
              pickup: _pickupLocations[index % _pickupLocations.length],
              delivery: _deliveryLocations[index % _deliveryLocations.length],
              distance: '${(index + 1) * 1.5} km',
              payment: '₺${(40 + index * 5).toStringAsFixed(2)}',
              time: '${10 + index} min',
            ),
          );
        },
      ),
    );
  }

  static const List<String> _pickupLocations = [
    'Starbucks, Bağdat Caddesi',
    'McDonald\'s, Kadıköy',
    'Burger King, Ataşehir',
    'KFC, Ümraniye',
  ];

  static const List<String> _deliveryLocations = [
    'Ev, Acıbadem',
    'Ofis, Kozyatağı',
    'Apartman, Göztepe',
    'İş Merkezi, Bostancı',
  ];
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String pickup;
  final String delivery;
  final String distance;
  final String payment;
  final String time;

  const _OrderCard({
    required this.orderId,
    required this.pickup,
    required this.delivery,
    required this.distance,
    required this.payment,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildLocationRow(Icons.location_on, pickup, AppColors.accent),
            const SizedBox(height: 8),
            _buildLocationRow(Icons.flag, delivery, AppColors.success),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.route, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      distance,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    payment,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order $orderId accepted!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Accept Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
