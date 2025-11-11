import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF6B35); // Orange
  static const Color primaryDark = Color(0xFFE55A2B);
  static const Color primaryLight = Color(0xFFFF8C61);
  
  // Secondary Colors (from website)
  static const Color secondary = Color(0xFF00B336); // Green
  static const Color secondaryDark = Color(0xFF009428);
  static const Color secondaryLight = Color(0xFF00D644);
  
  // Accent Colors (from website)
  static const Color accent = Color(0xFF0081F2); // Blue
  static const Color accentDark = Color(0xFF0066C2);
  static const Color accentLight = Color(0xFF00CBFF);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textDisabled = Color(0xFFBDC3C7);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);
  
  // Order Status Colors
  static const Color orderPending = Color(0xFFF39C12); // Yellow
  static const Color orderSearching = Color(0xFF3498DB); // Blue
  static const Color orderAccepted = Color(0xFF27AE60); // Green
  static const Color orderOnTheWay = Color(0xFF9B59B6); // Purple
  static const Color orderDelivered = Color(0xFF27AE60); // Green
  static const Color orderCancelled = Color(0xFFE74C3C); // Red
  
  // Courier Status Colors
  static const Color courierActive = Color(0xFF27AE60);
  static const Color courierInactive = Color(0xFF95A5A6);
  static const Color courierAvailable = Color(0xFF3498DB);
  static const Color courierBusy = Color(0xFFF39C12);
  static const Color courierOffline = Color(0xFF7F8C8D);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  
  // Divider Colors
  static const Color divider = Color(0xFFECF0F1);
  static const Color dividerDark = Color(0xFF2C2C2C);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // Map Colors
  static const Color mapMarkerPickup = Color(0xFF3498DB);
  static const Color mapMarkerDelivery = Color(0xFF27AE60);
  static const Color mapMarkerCourier = Color(0xFFFF6B35);
  static const Color mapRoute = Color(0xFF3498DB);
  
  // Rating Colors
  static const Color ratingStar = Color(0xFFF39C12);
  static const Color ratingStarEmpty = Color(0xFFE0E0E0);
  
  // Payment Method Colors
  static const Color paymentCreditCard = Color(0xFF3498DB);
  static const Color paymentCash = Color(0xFF27AE60);
  static const Color paymentWallet = Color(0xFF9B59B6);
  
  // Package Size Colors
  static const Color packageSmall = Color(0xFF3498DB);
  static const Color packageMedium = Color(0xFFF39C12);
  static const Color packageLarge = Color(0xFFE74C3C);
  
  // Social Media Colors
  static const Color google = Color(0xFFDB4437);
  static const Color apple = Color(0xFF000000);
  static const Color microsoft = Color(0xFF00A4EF);
  static const Color facebook = Color(0xFF1877F2);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);
  
  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  
  // Transparent
  static const Color transparent = Colors.transparent;
}
