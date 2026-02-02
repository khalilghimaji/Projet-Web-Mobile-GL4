import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Utility class for handling URL transformations based on platform
class UrlUtils {
  /// Transforms a URL to use the correct base URL for the current platform
  /// This is mainly needed for images and other assets that come from the backend
  static String transformUrl(String url) {
    // If it's already a full URL, transform the host part
    if (url.startsWith('http://localhost:3003')) {
      if (kIsWeb) {
        return url; // Web can use localhost
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return url.replaceFirst(
          'http://localhost:3003',
          'http://10.0.2.2:3003',
        );
      } else {
        return url; // iOS simulator and others can use localhost
      }
    }

    // If it's a relative URL, prepend the correct base URL
    if (!url.startsWith('http')) {
      if (kIsWeb) {
        return 'http://localhost:3003$url';
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return 'http://10.0.2.2:3003$url';
      } else {
        return 'http://localhost:3003$url';
      }
    }

    // Return as-is if it's already a full URL with a different host
    return url;
  }
}
