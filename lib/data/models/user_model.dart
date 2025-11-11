class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final UserRole role;
  final DateTime createdAt;
  
  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.role,
    required this.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: UserRole.fromString(json['role'] as String? ?? 'customer'),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'role': role.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum UserRole {
  customer,
  courier,
  business,
  admin;
  
  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'customer':
        return UserRole.customer;
      case 'courier':
        return UserRole.courier;
      case 'business':
        return UserRole.business;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
  
  @override
  String toString() {
    switch (this) {
      case UserRole.customer:
        return 'customer';
      case UserRole.courier:
        return 'courier';
      case UserRole.business:
        return 'business';
      case UserRole.admin:
        return 'admin';
    }
  }
}
