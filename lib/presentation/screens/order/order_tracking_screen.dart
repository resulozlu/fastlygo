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
    this.courierName = 'Ahmet Yılmaz',
    this.courierPhone = '+90 555 123 4567',
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Timer? _statusTimer;
  
  String _orderStatus = 'Accepted';
  int _statusIndex = 0;
  final List<Map<String, dynamic>> _statusList = [
    {'title': 'Accepted', 'icon': Icons.check_circle, 'color': Color(0xFF00B336)},
    {'title': 'Picked Up', 'icon': Icons.inventory_2, 'color': Color(0xFF0081F2)},
    {'title': 'In Transit', 'icon': Icons.local_shipping, 'color': Color(0xFFFF6B35)},
    {'title': 'Delivered', 'icon': Icons.done_all, 'color': Color(0xFF00B336)},
  ];

  @override
  void initState() {
    super.initState();
    _startStatusUpdates();
  }

  void _startStatusUpdates() {
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_statusIndex < _statusList.length - 1) {
        setState(() {
          _statusIndex++;
          _orderStatus = _statusList[_statusIndex]['title'];
        });
      } else {
        timer.cancel();
        // Show delivery completed dialog
        _showDeliveryCompleted();
      }
    });
  }

  void _showDeliveryCompleted() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
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
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B336).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Color(0xFF00B336),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Delivery Completed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your package has been successfully delivered',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order ID:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.orderId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Courier:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.courierName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to home
                    // TODO: Navigate to rating screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rating feature coming soon!'),
                        backgroundColor: Color(0xFF0081F2),
                      ),
                    );
                  },
                  child: const Text(
                    'Rate Courier',
                    style: TextStyle(
                      color: Color(0xFF0081F2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_statusIndex < 2) // Can only cancel before "In Transit"
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _showCancelOrderDialog,
              tooltip: 'İptal Et',
            ),
        ],
      ),
      body: Column(
        children: [
          // Map Placeholder
          Container(
            height: 300,
            color: Colors.grey[200],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Map View',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Order Details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Courier Info Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFFF6B35),
                            child: Icon(Icons.person, size: 30, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.courierName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Row(
                                  children: [
                                    Icon(Icons.star, size: 16, color: Colors.amber),
                                    SizedBox(width: 4),
                                    Text('4.8', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Calling ${widget.courierPhone}...'),
                                  backgroundColor: const Color(0xFF00B336),
                                ),
                              );
                            },
                            icon: const Icon(Icons.phone, color: Color(0xFF00B336)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Order Status Timeline
                  const Text(
                    'Order Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  ..._statusList.asMap().entries.map((entry) {
                    int index = entry.key;
                    var status = entry.value;
                    bool isActive = index <= _statusIndex;
                    bool isCurrent = index == _statusIndex;

                    return Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive ? status['color'] : Colors.grey[300],
                                border: Border.all(
                                  color: isCurrent ? const Color(0xFFFF6B35) : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: Icon(status['icon'], color: Colors.white, size: 20),
                            ),
                            if (index < _statusList.length - 1)
                              Container(
                                width: 2,
                                height: 40,
                                color: index < _statusIndex ? const Color(0xFF00B336) : Colors.grey[300],
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            status['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),

                  // Delivery Details
                  const Text(
                    'Delivery Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(Icons.location_on, 'Pickup', widget.pickupAddress, const Color(0xFF0081F2)),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.flag, 'Delivery', widget.deliveryAddress, const Color(0xFF00B336)),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.confirmation_number, 'Order ID', widget.orderId, const Color(0xFFFF6B35)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog() {
    final List<String> cancelReasons = [
      'Sipariş yanlışlıkla verildi',
      'Teslimat adresi yanlış',
      'Teslimat çok uzun sürüyor',
      'Fikrim değişti',
      'Diğer',
    ];
    String? selectedReason;
    final TextEditingController otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Siparişi İptal Et'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'İptal nedeninizi seçin:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  ...cancelReasons.map((reason) {
                    return RadioListTile<String>(
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      activeColor: const Color(0xFFFF6B35),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setDialogState(() {
                          selectedReason = value;
                        });
                      },
                    );
                  }),
                  if (selectedReason == 'Diğer') ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: otherReasonController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'İptal nedeninizi yazın...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Vazgeç'),
                ),
                ElevatedButton(
                  onPressed: selectedReason == null
                      ? null
                      : () {
                          _cancelOrder(
                            selectedReason!,
                            selectedReason == 'Diğer'
                                ? otherReasonController.text
                                : null,
                          );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('İptal Et'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _cancelOrder(String reason, String? otherReason) {
    // Stop status updates
    _statusTimer?.cancel();

    // Show cancellation confirmation
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cancel,
                size: 60,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sipariş İptal Edildi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Neden: $reason',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            if (otherReason != null && otherReason.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                otherReason,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Tamam'),
            ),
          ],
        ),
      ),
    );

    // TODO: Send cancellation to API
    print('Order cancelled: ${widget.orderId}, Reason: $reason');
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
