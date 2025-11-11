import 'package:flutter/material.dart';
import 'dart:async';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final String pickupAddress;
  final String deliveryAddress;
  final String courierName;
  final String courierPhone;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.pickupAddress,
    required this.deliveryAddress,
    this.courierName = 'John Doe',
    this.courierPhone = '+90 555 123 4567',
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  String _currentStatus = 'accepted';
  Timer? _statusTimer;
  int _statusIndex = 0;
  
  final List<Map<String, dynamic>> _statuses = [
    {
      'key': 'accepted',
      'title': 'Courier Accepted',
      'subtitle': 'Your courier is on the way to pickup',
      'icon': Icons.check_circle,
      'color': Color(0xFF00B336),
    },
    {
      'key': 'picked_up',
      'title': 'Package Picked Up',
      'subtitle': 'Courier has picked up your package',
      'icon': Icons.inventory_2,
      'color': Color(0xFF0081F2),
    },
    {
      'key': 'in_transit',
      'title': 'In Transit',
      'subtitle': 'Package is on the way to delivery',
      'icon': Icons.local_shipping,
      'color': Color(0xFFFF6B35),
    },
    {
      'key': 'delivered',
      'title': 'Delivered',
      'subtitle': 'Package has been delivered',
      'icon': Icons.done_all,
      'color': Color(0xFF00B336),
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Simulate status updates every 10 seconds
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_statusIndex < _statuses.length - 1) {
        setState(() {
          _statusIndex++;
          _currentStatus = _statuses[_statusIndex]['key'];
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStatusData = _statuses[_statusIndex];
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        title: const Text('Track Order'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map Placeholder
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Stack(
                children: [
                  // Map placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Live Map View',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Google Maps integration coming soon',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Courier marker (simulated)
                  Positioned(
                    top: 120,
                    left: MediaQuery.of(context).size.width / 2 - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.two_wheeler,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Status Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: currentStatusData['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentStatusData['color'],
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: currentStatusData['color'],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              currentStatusData['icon'],
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentStatusData['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentStatusData['subtitle'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Courier Info
                    const Text(
                      'Courier Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFFF6B35),
                            child: Text(
                              widget.courierName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.courierName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.courierPhone,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Call courier
                            },
                            icon: const Icon(
                              Icons.phone,
                              color: Color(0xFF00B336),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Delivery Details
                    const Text(
                      'Delivery Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DeliveryDetailRow(
                      icon: Icons.location_on,
                      iconColor: const Color(0xFF0081F2),
                      label: 'Pickup',
                      value: widget.pickupAddress,
                    ),
                    const SizedBox(height: 12),
                    _DeliveryDetailRow(
                      icon: Icons.flag,
                      iconColor: const Color(0xFF00B336),
                      label: 'Delivery',
                      value: widget.deliveryAddress,
                    ),
                    const SizedBox(height: 12),
                    _DeliveryDetailRow(
                      icon: Icons.confirmation_number,
                      iconColor: const Color(0xFFFF6B35),
                      label: 'Order ID',
                      value: widget.orderId,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Status Timeline
                    const Text(
                      'Order Timeline',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._statuses.asMap().entries.map((entry) {
                      final index = entry.key;
                      final status = entry.value;
                      final isCompleted = index <= _statusIndex;
                      final isCurrent = index == _statusIndex;
                      
                      return _TimelineItem(
                        icon: status['icon'],
                        title: status['title'],
                        subtitle: status['subtitle'],
                        color: status['color'],
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                        isLast: index == _statuses.length - 1,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryDetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DeliveryDetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
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
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? color : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? color : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCompleted ? Colors.black : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
