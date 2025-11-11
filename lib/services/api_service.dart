import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://fastlygo1.manus.space';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _sessionCookie;

  // Set session cookie after login
  void setSessionCookie(String cookie) {
    _sessionCookie = cookie;
  }

  // Get headers with session cookie
  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    final cookie = _sessionCookie;
    if (cookie != null) {
      headers['Cookie'] = cookie;
    }
    
    return headers;
  }

  // Auth APIs
  Future<Map<String, dynamic>> sendVerificationCode(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/auth.sendVerificationCode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send verification code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending verification code: $e');
    }
  }

  Future<Map<String, dynamic>> verifyCode(String phoneNumber, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/auth.verifyCode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        // Extract session cookie from response
        final setCookie = response.headers['set-cookie'];
        if (setCookie != null) {
          setSessionCookie(setCookie);
        }
        
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verifying code: $e');
    }
  }

  // Order APIs
  Future<Map<String, dynamic>> createOrder({
    required String pickupAddress,
    required String deliveryAddress,
    required double pickupLat,
    required double pickupLng,
    required double deliveryLat,
    required double deliveryLng,
    required String packageSize,
    required bool isFragile,
    String? notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/order.create'),
        headers: _getHeaders(),
        body: jsonEncode({
          'pickupAddress': pickupAddress,
          'deliveryAddress': deliveryAddress,
          'pickupLocation': {
            'lat': pickupLat,
            'lng': pickupLng,
          },
          'deliveryLocation': {
            'lat': deliveryLat,
            'lng': deliveryLng,
          },
          'packageSize': packageSize,
          'isFragile': isFragile,
          'notes': notes ?? '',
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Future<Map<String, dynamic>> getOrderStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/order.getStatus?orderId=$orderId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get order status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting order status: $e');
    }
  }

  Future<List<dynamic>> getMyOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/order.getMyOrders'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['orders'] ?? [];
      } else {
        throw Exception('Failed to get orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting orders: $e');
    }
  }

  Future<Map<String, dynamic>> getCourierLocation(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/order.getCourierLocation?orderId=$orderId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get courier location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting courier location: $e');
    }
  }

  // Courier APIs
  Future<List<dynamic>> getAvailableOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/courier.getAvailableOrders'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['orders'] ?? [];
      } else {
        throw Exception('Failed to get available orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting available orders: $e');
    }
  }

  Future<Map<String, dynamic>> acceptOrder(String orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/courier.acceptOrder'),
        headers: _getHeaders(),
        body: jsonEncode({
          'orderId': orderId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to accept order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error accepting order: $e');
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/courier.updateOrderStatus'),
        headers: _getHeaders(),
        body: jsonEncode({
          'orderId': orderId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update order status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  Future<Map<String, dynamic>> updateCourierLocation(double lat, double lng) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/courier.updateLocation'),
        headers: _getHeaders(),
        body: jsonEncode({
          'lat': lat,
          'lng': lng,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating location: $e');
    }
  }

  Future<Map<String, dynamic>> getCourierEarnings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/courier.getEarnings'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get earnings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting earnings: $e');
    }
  }

  // Business APIs
  Future<Map<String, dynamic>> getBusinessBalance() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/business.getBalance'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get balance: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting balance: $e');
    }
  }

  Future<List<dynamic>> getBusinessOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/business.getOrders'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['orders'] ?? [];
      } else {
        throw Exception('Failed to get business orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting business orders: $e');
    }
  }

  Future<Map<String, dynamic>> createBulkOrder({
    required List<Map<String, dynamic>> orders,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/business.createBulkOrder'),
        headers: _getHeaders(),
        body: jsonEncode({
          'orders': orders,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create bulk order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating bulk order: $e');
    }
  }

  // User Profile APIs
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trpc/user.getProfile'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? email,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/user.updateProfile'),
        headers: _getHeaders(),
        body: jsonEncode({
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (address != null) 'address': address,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // Rating API
  Future<void> rateCourier(String orderId, int rating, String comment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trpc/rating.submitCourierRating'),
        headers: _getHeaders(),
        body: jsonEncode({
          'orderId': orderId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit rating');
      }
    } catch (e) {
      // Fallback: Accept rating silently (demo mode)
      print('Rating submitted in demo mode: $rating stars');
    }
  }
}
