import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'order_tracking_screen.dart';
import 'order_tracking_map_screen.dart';
import '../../../services/api_service.dart';

class CourierSearchingScreen extends StatefulWidget {
  final String pickupAddress;
  final String deliveryAddress;
  final String packageSize;
  final bool isFragile;
  final String notes;

  const CourierSearchingScreen({
    super.key,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.packageSize,
    required this.isFragile,
    required this.notes,
  });

  @override
  State<CourierSearchingScreen> createState() => _CourierSearchingScreenState();
}

class _CourierSearchingScreenState extends State<CourierSearchingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _searchTimer;
  int _dotsCount = 0;
  final ApiService _apiService = ApiService();
  String? _orderId;
  LatLng? _pickupLocation;
  LatLng? _deliveryLocation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Animate dots
    _searchTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotsCount = (_dotsCount + 1) % 4;
      });
    });

    // Create order via API
    _createOrder();
  }

  Future<void> _createOrder() async {
    try {
      // For demo: use default Istanbul coordinates
      // In production, these should come from address selection
      _pickupLocation = const LatLng(41.0082, 28.9784);
      _deliveryLocation = const LatLng(41.0182, 28.9884);

      final result = await _apiService.createOrder(
        pickupAddress: widget.pickupAddress,
        deliveryAddress: widget.deliveryAddress,
        pickupLat: _pickupLocation!.latitude,
        pickupLng: _pickupLocation!.longitude,
        deliveryLat: _deliveryLocation!.latitude,
        deliveryLng: _deliveryLocation!.longitude,
        packageSize: widget.packageSize,
        isFragile: widget.isFragile,
        notes: widget.notes,
      );

      setState(() {
        _orderId = result['orderId'] ?? 'ORD${DateTime.now().millisecondsSinceEpoch}';
      });

      // Simulate courier search delay
      await Future.delayed(const Duration(seconds: 5));

      if (mounted) {
        _showCourierFound();
      }
    } catch (e) {
      // Fallback to demo mode if API fails
      setState(() {
        _orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
        _pickupLocation = const LatLng(41.0082, 28.9784);
        _deliveryLocation = const LatLng(41.0182, 28.9884);
      });

      await Future.delayed(const Duration(seconds: 5));

      if (mounted) {
        _showCourierFound();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _showCourierFound() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF00B336).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 50,
                color: Color(0xFF00B336),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Courier Found!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your courier is on the way to pickup location',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close searching screen
                // Navigate to tracking screen with map
                if (_pickupLocation != null && _deliveryLocation != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingMapScreen(
                        orderId: _orderId ?? 'ORD${DateTime.now().millisecondsSinceEpoch}',
                        pickupAddress: widget.pickupAddress,
                        deliveryAddress: widget.deliveryAddress,
                        pickupLocation: _pickupLocation!,
                        deliveryLocation: _deliveryLocation!,
                      ),
                    ),
                  );
                } else {
                  // Fallback to simple tracking screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(
                        orderId: _orderId ?? 'ORD${DateTime.now().millisecondsSinceEpoch}',
                        pickupAddress: widget.pickupAddress,
                        deliveryAddress: widget.deliveryAddress,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Track Order'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon
              RotationTransition(
                turns: _animationController,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 60,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title with animated dots
              Text(
                'Searching for courier${'.' * _dotsCount}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Please wait while we find the best courier for your delivery',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Order Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      icon: Icons.location_on,
                      iconColor: const Color(0xFF0081F2),
                      label: 'Pickup',
                      value: widget.pickupAddress,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      icon: Icons.flag,
                      iconColor: const Color(0xFF00B336),
                      label: 'Delivery',
                      value: widget.deliveryAddress,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      icon: Icons.inventory_2,
                      iconColor: const Color(0xFFFF6B35),
                      label: 'Package',
                      value: '${widget.packageSize.toUpperCase()}${widget.isFragile ? ' • Fragile' : ''}',
                    ),
                    if (widget.notes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SummaryRow(
                        icon: Icons.note,
                        iconColor: Colors.grey,
                        label: 'Notes',
                        value: widget.notes,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel Order',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
