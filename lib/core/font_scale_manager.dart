import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_firebase_template/core/utils/device_utils.dart';

enum FontScale {
  small,
  normal,
  large,
}

class FontScaleManager extends ChangeNotifier {
  static const String _fontScaleKey = 'font_scale';
  
  FontScale _fontScale = FontScale.normal;
  FontScale get fontScale => _fontScale;

  FontScaleManager() {
    _loadFontScale();
  }

  Future<void> _loadFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    final fontScaleIndex = prefs.getInt(_fontScaleKey) ?? FontScale.normal.index;
    _fontScale = FontScale.values[fontScaleIndex];
    _applyFontScale();
    notifyListeners();
  }

  Future<void> setFontScale(FontScale scale) async {
    _fontScale = scale;
    _applyFontScale();
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontScaleKey, scale.index);
  }

  void _applyFontScale() {
    double scaleFactor;
    switch (_fontScale) {
      case FontScale.small:
        scaleFactor = 0.75;
        break;
      case FontScale.normal:
        scaleFactor = 0.85;
        break;
      case FontScale.large:
        scaleFactor = 0.95;
        break;
    }
    DeviceUtils.setUserFontScale(scaleFactor);
    // Force a rebuild of the app to apply the new font scale
    notifyListeners();
  }

  String getFontScaleDisplayName() {
    switch (_fontScale) {
      case FontScale.small:
        return 'Small';
      case FontScale.normal:
        return 'Normal';
      case FontScale.large:
        return 'Large';
    }
  }

  String getFontScaleDescription() {
    switch (_fontScale) {
      case FontScale.small:
        return 'Smaller text for more content';
      case FontScale.normal:
        return 'Default text size';
      case FontScale.large:
        return 'Larger text for better readability';
    }
  }
}
