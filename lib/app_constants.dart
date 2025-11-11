class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://fastlygox.manus.space/api/trpc';
  static const String wsBaseUrl = 'wss://fastlygox.manus.space/api/ws';
  
  // App Information
  static const String appName = 'FastlyGo';
  static const String appVersion = '12.0.0';
  static const int appBuildNumber = 1;
  
  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserType = 'user_type';
  static const String keyLanguage = 'language';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keySessionCookie = 'session_cookie';
  
  // User Types
  static const String userTypeCustomer = 'customer';
  static const String userTypeCourier = 'courier';
  static const String userTypeBusiness = 'business';
  
  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusSearchingCourier = 'searching_courier';
  static const String orderStatusCourierAccepted = 'courier_accepted';
  static const String orderStatusPickedUp = 'picked_up';
  static const String orderStatusOnTheWay = 'on_the_way';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';
  
  // Courier Status
  static const String courierStatusActive = 'active';
  static const String courierStatusInactive = 'inactive';
  static const String courierStatusAvailable = 'available';
  static const String courierStatusBusy = 'busy';
  static const String courierStatusOffline = 'offline';
  
  // Payment Methods
  static const String paymentMethodCreditCard = 'credit_card';
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodWallet = 'wallet';
  
  // Package Sizes
  static const String packageSizeSmall = 'small';
  static const String packageSizeMedium = 'medium';
  static const String packageSizeLarge = 'large';
  
  // Notification Types
  static const String notificationTypeOrderCreated = 'order_created';
  static const String notificationTypeCourierAssigned = 'courier_assigned';
  static const String notificationTypeCourierOnTheWay = 'courier_on_the_way';
  static const String notificationTypeCourierArrived = 'courier_arrived';
  static const String notificationTypeOrderDelivered = 'order_delivered';
  static const String notificationTypeNewOrderRequest = 'new_order_request';
  static const String notificationTypePaymentReceived = 'payment_received';
  static const String notificationTypePromotion = 'promotion';
  
  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double trackingMapZoom = 16.0;
  static const int locationUpdateInterval = 5000; // milliseconds
  static const int locationUpdateFastestInterval = 3000; // milliseconds
  
  // Timeouts
  static const int apiTimeout = 30; // seconds
  static const int orderAcceptTimeout = 30; // seconds for courier to accept
  static const int searchCourierTimeout = 300; // seconds (5 minutes)
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int ordersPageSize = 15;
  static const int notificationsPageSize = 25;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  
  // Currency Symbols (based on language)
  static const Map<String, String> currencySymbols = {
    'en': '\$',
    'tr': '₺',
    'mk': 'ден',
  };
  
  // Currency Codes
  static const Map<String, String> currencyCodes = {
    'en': 'USD',
    'tr': 'TRY',
    'mk': 'MKD',
  };
  
  // Tip Amounts (default suggestions)
  static const List<double> defaultTipAmounts = [5.0, 10.0, 20.0, 50.0];
  
  // Rating
  static const int maxRating = 5;
  static const int minRating = 1;
  
  // Image Upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  
  // OAuth Providers
  static const String oauthGoogle = 'google';
  static const String oauthApple = 'apple';
  static const String oauthMicrosoft = 'microsoft';
  
  // Business Categories
  static const String businessCategoryRestaurant = 'restaurant';
  static const String businessCategoryMarket = 'market';
  static const String businessCategoryPharmacy = 'pharmacy';
  static const String businessCategoryRetail = 'retail';
  
  // Error Messages
  static const String errorNetwork = 'network_error';
  static const String errorUnauthorized = 'unauthorized';
  static const String errorNotFound = 'not_found';
  static const String errorServerError = 'server_error';
  static const String errorUnknown = 'unknown_error';
  
  // Animation Durations
  static const int splashDuration = 2000; // milliseconds
  static const int onboardingAnimationDuration = 300; // milliseconds
  static const int pageTransitionDuration = 250; // milliseconds
  
  // Contact Information
  static const String supportEmail = 'info@fastlygo.com';
  static const String supportPhone = '+389 XX XXX XXX';
  static const String companyAddress = 'Skopje, North Macedonia';
  
  // Social Media (if needed)
  static const String facebookUrl = 'https://facebook.com/fastlygo';
  static const String twitterUrl = 'https://twitter.com/fastlygo';
  static const String instagramUrl = 'https://instagram.com/fastlygo';
  
  // Deep Links
  static const String deepLinkScheme = 'fastlygo';
  static const String deepLinkHost = 'app';
  
  // Firebase (will be configured later)
  static const String fcmSenderId = 'YOUR_SENDER_ID';
  static const String fcmServerKey = 'YOUR_SERVER_KEY';
}
