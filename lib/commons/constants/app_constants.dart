import 'package:flutter/material.dart';

class AppConstants {

  static final String appName = "AirBnb Clone";
  static final String userAvatar = "user_avatar";
  static final String postingImage = "posting_image";
  
  // Navigation Icon Colors
  static final Color selectedIcon = Colors.white;
  static final Color nonselectedIcon = Colors.white70;

  // URL
  static final String geoAPIfyDomain = "api.geoapify.com";
  static final String geoAPIfyPath = '/v1/geocode/autocomplete';

  // Credential Keys (env variable names for dotenv)
  static final String stripePublicKey = "STRIPE_PUBLIC_KEY";
  static final String stripeSecretKey = "STRIPE_SECRET_KEY";
  static final String cloudinaryAppName = "CLOUDINARY_APP_NAME";
  static final String geoAPIfyApiKey = "GEOAPIFY_API_KEY";

  // Cloudinary upload preset (value in code)
  static final String cloudinaryUploadPreset = "air_bnb_clone";
}