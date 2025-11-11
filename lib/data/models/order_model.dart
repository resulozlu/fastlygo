class OrderModel {
  final String id;
  final String customerId;
  final String? courierId;
  final String pickupAddress;
  final String deliveryAddress;
  final String packageSize;
  final bool isFragile;
  final String? notes;
  final OrderStatus status;
  final double? courierLatitude;
  final double? courierLongitude;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  
  OrderModel({
    required this.id,
    required this.customerId,
    this.courierId,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.packageSize,
    required this.isFragile,
    this.notes,
    required this.status,
    this.courierLatitude,
    this.courierLongitude,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      courierId: json['courierId'] as String?,
      pickupAddress: json['pickupAddress'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      packageSize: json['packageSize'] as String,
      isFragile: json['isFragile'] as bool? ?? false,
      notes: json['notes'] as String?,
      status: OrderStatus.fromString(json['status'] as String? ?? 'pending'),
      courierLatitude: json['courierLatitude'] as double?,
      courierLongitude: json['courierLongitude'] as double?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'courierId': courierId,
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'packageSize': packageSize,
      'isFragile': isFragile,
      'notes': notes,
      'status': status.toString(),
      'courierLatitude': courierLatitude,
      'courierLongitude': courierLongitude,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

enum OrderStatus {
  pending,      // Waiting for courier
  accepted,     // Courier accepted
  pickedUp,     // Courier picked up package
  inTransit,    // On the way to delivery
  delivered,    // Delivered
  cancelled;    // Cancelled
  
  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'pickedup':
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'intransit':
      case 'in_transit':
        return OrderStatus.inTransit;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
  
  @override
  String toString() {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.accepted:
        return 'accepted';
      case OrderStatus.pickedUp:
        return 'picked_up';
      case OrderStatus.inTransit:
        return 'in_transit';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}
