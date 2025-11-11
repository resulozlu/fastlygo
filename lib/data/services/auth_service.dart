import 'api_service.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiService _apiService;
  
  AuthService(this._apiService);
  
  // Send SMS code to phone number
  Future<Map<String, dynamic>> sendSmsCode(String phoneNumber) async {
    return await _apiService.post('/auth/send-code', {
      'phoneNumber': phoneNumber,
    });
  }
  
  // Verify SMS code and login
  Future<UserModel> verifySmsCode(String phoneNumber, String code) async {
    final response = await _apiService.post('/auth/verify-code', {
      'phoneNumber': phoneNumber,
      'code': code,
    });
    
    // Save auth token
    if (response['token'] != null) {
      await _apiService.setAuthToken(response['token']);
    }
    
    return UserModel.fromJson(response['user']);
  }
  
  // Get current user
  Future<UserModel> getCurrentUser() async {
    final response = await _apiService.get('/auth/me');
    return UserModel.fromJson(response);
  }
  
  // Logout
  Future<void> logout() async {
    await _apiService.clearAuthToken();
  }
  
  // Check if user is authenticated
  bool isAuthenticated() {
    // Check if session cookie exists
    return true; // Simplified for now
  }
}
