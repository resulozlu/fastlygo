import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class OrderTrackingMapScreen extends StatefulWidget {
  final String orderId;
  final String pickupAddress;
  final String deliveryAddress;
  final String courierName;
  final String courierPhone;
  final LatLng pickupLocation;
  final LatLng deliveryLocation;

  const OrderTrackingMapScreen({
    super.key,
    required this.orderId,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupLocation,
    required this.deliveryLocation,
    this.courierName = 'Ahmet Yılmaz',
    this.courierPhone = '+90 555 123 4567',
  });

  @override
  State<OrderTrackingMapScreen> createState() => _OrderTrackingMapScreenState();
}

class _OrderTrackingMapScreenState extends State<OrderTrackingMapScreen> {
  GoogleMapController? _mapController;
  Timer? _statusTimer;
  Timer? _locationTimer;
  
  String _orderStatus = 'Accepted';
  int _statusIndex = 0;
  LatLng? _courierLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  final List<Map<String, dynamic>> _statusList = [
    {'title': 'Accepted', 'icon': Icons.check_circle, 'color': Color(0xFF00B336)},
    {'title': 'Picked Up', 'icon': Icons.inventory_2, 'color': Color(0xFF0081F2)},
    {'title': 'In Transit', 'icon': Icons.local_shipping, 'color': Color(0xFFFF6B35)},
    {'title': 'Delivered', 'icon': Icons.done_all, 'color': Color(0xFF00B336)},
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _startStatusUpdates();
    _startLocationUpdates();
  }

  void _initializeMap() {
    // Initial courier location (near pickup)
    _courierLocation = LatLng(
      widget.pickupLocation.latitude + 0.001,
      widget.pickupLocation.longitude + 0.001,
    );
    _updateMarkers();
    _drawRoute();
  }

  void _updateMarkers() {
    setState(() {
      _markers = {
        // Pickup marker
        Marker(
          markerId: const MarkerId('pickup'),
          position: widget.pickupLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: widget.pickupAddress,
          ),
        ),
        // Delivery marker
        Marker(
          markerId: const MarkerId('delivery'),
          position: widget.deliveryLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: 'Delivery',
            snippet: widget.deliveryAddress,
          ),
        ),
        // Courier marker
        if (_courierLocation != null)
          Marker(
            markerId: const MarkerId('courier'),
            position: _courierLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
              title: 'Courier',
              snippet: widget.courierName,
            ),
          ),
      };
    });
  }

  Future<void> _drawRoute() async {
    if (_courierLocation == null) return;

    LatLng destination = _statusIndex < 1 ? widget.pickupLocation : widget.deliveryLocation;

    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCkPbiBZyWwAoTm_q33mi9oZshjcg9CmcQ',
        PointLatLng(_courierLocation!.latitude, _courierLocation!.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.driving,
      );

      List<LatLng> polylineCoordinates = [];
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        // Fallback: draw straight line
        polylineCoordinates = [_courierLocation!, destination];
      }

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: const Color(0xFFFF6B35),
            width: 5,
          ),
        };
      });
    } catch (e) {
      // Fallback: draw straight line
      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: [_courierLocation!, destination],
            color: const Color(0xFFFF6B35),
            width: 5,
          ),
        };
      });
    }
  }

  void _startStatusUpdates() {
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_statusIndex < _statusList.length - 1) {
        setState(() {
          _statusIndex++;
          _orderStatus = _statusList[_statusIndex]['title'];
        });
        _drawRoute(); // Redraw route when status changes
      } else {
        timer.cancel();
        _showDeliveryCompleted();
      }
    });
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_courierLocation != null && _statusIndex < _statusList.length - 1) {
        // Simulate courier movement
        LatLng target = _statusIndex < 1 ? widget.pickupLocation : widget.deliveryLocation;
        
        double latDiff = (target.latitude - _courierLocation!.latitude) * 0.1;
        double lngDiff = (target.longitude - _courierLocation!.longitude) * 0.1;
        
        setState(() {
          _courierLocation = LatLng(
            _courierLocation!.latitude + latDiff,
            _courierLocation!.longitude + lngDiff,
          );
        });
        
        _updateMarkers();
        _drawRoute();
        
        // Animate camera to follow courier
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_courierLocation!),
        );
      } else {
        timer.cancel();
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.pickupLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              // Fit bounds to show all markers
              _fitMapBounds();
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Top Info Card
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFFFF6B35),
                      child: Icon(Icons.person, size: 25, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.courierName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                _statusList[_statusIndex]['icon'],
                                size: 14,
                                color: _statusList[_statusIndex]['color'],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _orderStatus,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _statusList[_statusIndex]['color'],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
          ),

          // Bottom Details Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.location_on,
                    color: const Color(0xFF0081F2),
                    label: 'Pickup',
                    value: widget.pickupAddress,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.flag,
                    color: const Color(0xFF00B336),
                    label: 'Delivery',
                    value: widget.deliveryAddress,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.confirmation_number,
                    color: const Color(0xFFFF6B35),
                    label: 'Order ID',
                    value: widget.orderId,
                  ),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _fitMapBounds() {
    if (_mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        [widget.pickupLocation.latitude, widget.deliveryLocation.latitude, _courierLocation?.latitude ?? 0].reduce((a, b) => a < b ? a : b),
        [widget.pickupLocation.longitude, widget.deliveryLocation.longitude, _courierLocation?.longitude ?? 0].reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        [widget.pickupLocation.latitude, widget.deliveryLocation.latitude, _courierLocation?.latitude ?? 0].reduce((a, b) => a > b ? a : b),
        [widget.pickupLocation.longitude, widget.deliveryLocation.longitude, _courierLocation?.longitude ?? 0].reduce((a, b) => a > b ? a : b),
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
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
