import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DeviceUtils {
  static late double screenWidth;
  static late double screenHeight;
  static late double pixelRatio;
  static late TextScaler textScaler;

  static double scaleFactor = 1.0; // Optional override by user

  static void init(BuildContext context) {
    final mq = MediaQuery.of(context);
    screenWidth = mq.size.width;
    screenHeight = mq.size.height;
    pixelRatio = mq.devicePixelRatio;
    textScaler = mq.textScaler;

    // Scale relative to base design width (width of iPhone 11) and multiply by the user override
    // This will default any font scaling for devices relative to the size of the iphone 11, if the device is bigger than the iPhone 11 
    // then the font will scale larger. If the device is smaller than the iPhone 11 then the font will scale smaller
    scaleFactor = (screenWidth / 375.0) * _userFontPreferenceScaleFactor;
  }

  // changing this value will change the scaleFactor for all the fonts and icons in the app. Change it here to test out what is best for a default value
  static double _userFontPreferenceScaleFactor = 0.8;

  // let the user choose their font scale like this for example:
  // "Small" → setUserFontScale(0.85)
  // "Default" → setUserFontScale(1.0)
  // "Large" → setUserFontScale(1.15)
  // or make even more font scale increments to choose from. Save the value in the user's firestore document
  static void setUserFontScale(double scale) {
    _userFontPreferenceScaleFactor = scale;
    scaleFactor = (screenWidth / 375.0) * _userFontPreferenceScaleFactor;
  }

  // This method can safely be called even before the init function is called because this
  // method doesn't require any build context to execute. This is why it can be used in main
  // before calling runApp()
  static String getDeviceType() {
    if (kIsWeb) return 'Web';

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      default:
        return 'Unknown';
    }
  }
}
