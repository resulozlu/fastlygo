import 'api_service.dart';
import '../models/order_model.dart';

class OrderService {
  final ApiService _apiService;
  
  OrderService(this._apiService);
  
  // Create new order
  Future<OrderModel> createOrder({
    required String pickupAddress,
    required String deliveryAddress,
    required String packageSize,
    required bool isFragile,
    String? notes,
  }) async {
    final response = await _apiService.post('/orders', {
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'packageSize': packageSize,
      'isFragile': isFragile,
      'notes': notes,
    });
    
    return OrderModel.fromJson(response);
  }
  
  // Get order by ID
  Future<OrderModel> getOrder(String orderId) async {
    final response = await _apiService.get('/orders/$orderId');
    return OrderModel.fromJson(response);
  }
  
  // Get user's orders
  Future<List<OrderModel>> getMyOrders() async {
    final response = await _apiService.get('/orders/my-orders');
    final List<dynamic> orders = response['orders'] as List<dynamic>;
    return orders.map((json) => OrderModel.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  // Get available orders for courier
  Future<List<OrderModel>> getAvailableOrders() async {
    final response = await _apiService.get('/orders/available');
    final List<dynamic> orders = response['orders'] as List<dynamic>;
    return orders.map((json) => OrderModel.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  // Accept order (courier)
  Future<OrderModel> acceptOrder(String orderId) async {
    final response = await _apiService.post('/orders/$orderId/accept', {});
    return OrderModel.fromJson(response);
  }
  
  // Complete order (courier)
  Future<OrderModel> completeOrder(String orderId) async {
    final response = await _apiService.post('/orders/$orderId/complete', {});
    return OrderModel.fromJson(response);
  }
  
  // Cancel order
  Future<OrderModel> cancelOrder(String orderId, String reason) async {
    final response = await _apiService.post('/orders/$orderId/cancel', {
      'reason': reason,
    });
    return OrderModel.fromJson(response);
  }
  
  // Update courier location
  Future<void> updateCourierLocation(String orderId, double latitude, double longitude) async {
    await _apiService.post('/orders/$orderId/location', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}
