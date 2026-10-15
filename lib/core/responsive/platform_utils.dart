import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Utility class for platform detection.
class PlatformUtils {
  PlatformUtils._();

  /// Returns true if running on Windows, macOS, or Linux desktop.
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Returns true if running on Android or iOS mobile.
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Returns true if running on Windows specifically.
  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }
}
