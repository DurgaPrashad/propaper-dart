import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WallpaperSettings {
  final String background;
  final String font;
  final String fontSize;
  final String showType;
  final int contrast;
  final int brightness;
  final bool autoUpdate;
  final bool isPremium;

  WallpaperSettings({
    this.background = 'black_white',
    this.font = 'Inter',
    this.fontSize = 'medium',
    this.showType = 'all',
    this.contrast = 50,
    this.brightness = 50,
    this.autoUpdate = true,
    this.isPremium = false,
  });

  WallpaperSettings copyWith({
    String? background,
    String? font,
    String? fontSize,
    String? showType,
    int? contrast,
    int? brightness,
    bool? autoUpdate,
    bool? isPremium,
  }) {
    return WallpaperSettings(
      background: background ?? this.background,
      font: font ?? this.font,
      fontSize: fontSize ?? this.fontSize,
      showType: showType ?? this.showType,
      contrast: contrast ?? this.contrast,
      brightness: brightness ?? this.brightness,
      autoUpdate: autoUpdate ?? this.autoUpdate,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'background': background,
      'font': font,
      'fontSize': fontSize,
      'showType': showType,
      'contrast': contrast,
      'brightness': brightness,
      'autoUpdate': autoUpdate,
      'isPremium': isPremium,
    };
  }

  factory WallpaperSettings.fromJson(Map<String, dynamic> json) {
    return WallpaperSettings(
      background: json['background'] ?? 'black_white',
      font: json['font'] ?? 'Inter',
      fontSize: json['fontSize'] ?? 'medium',
      showType: json['showType'] ?? 'all',
      contrast: json['contrast'] ?? 50,
      brightness: json['brightness'] ?? 50,
      autoUpdate: json['autoUpdate'] ?? true,
      isPremium: json['isPremium'] ?? false,
    );
  }
}

class WallpaperProvider extends ChangeNotifier {
  WallpaperSettings _settings = WallpaperSettings();

  WallpaperProvider() {
    _loadSettings();
  }

  WallpaperSettings get settings => _settings;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('wallpaperSettings');
    
    if (settingsJson != null) {
      _settings = WallpaperSettings.fromJson(json.decode(settingsJson));
    }
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wallpaperSettings', json.encode(_settings.toJson()));
  }

  Future<void> updateSettings({
    String? background,
    String? font,
    String? fontSize,
    String? showType,
    int? contrast,
    int? brightness,
    bool? autoUpdate,
  }) async {
    _settings = _settings.copyWith(
      background: background,
      font: font,
      fontSize: fontSize,
      showType: showType,
      contrast: contrast,
      brightness: brightness,
      autoUpdate: autoUpdate,
    );
    await _saveSettings();
    notifyListeners();
  }

  Future<void> upgradeToPremium() async {
    _settings = _settings.copyWith(isPremium: true);
    await _saveSettings();
    notifyListeners();
  }

  LinearGradient getBackgroundGradient() {
    switch (_settings.background) {
      case 'black_white':
        final contrastValue = _settings.contrast / 100;
        final startColor = Colors.black;
        final endColor = Color.lerp(Colors.black, Colors.white, contrastValue);
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [startColor, endColor ?? Colors.grey],
        );
      case 'solid_black':
        return const LinearGradient(
          colors: [Colors.black, Colors.black],
        );
      case 'solid_white':
        return const LinearGradient(
          colors: [Colors.white, Colors.white],
        );
      case 'gradient_purple':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.pink],
        );
      case 'gradient_blue':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.indigo],
        );
      case 'gradient_green':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green, Colors.teal],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.grey],
        );
    }
  }

  Color getTextColor() {
    if (_settings.background == 'solid_white') {
      return Colors.black;
    }
    return Colors.white;
  }

  TextStyle getTextStyle() {
    double fontSize;
    switch (_settings.fontSize) {
      case 'small':
        fontSize = 12.0;
        break;
      case 'medium':
        fontSize = 14.0;
        break;
      case 'large':
        fontSize = 16.0;
        break;
      default:
        fontSize = 14.0;
    }

    return TextStyle(
      fontFamily: _settings.font,
      fontSize: fontSize,
      color: getTextColor(),
    );
  }

  Color getCardBackground() {
    if (_settings.background == 'solid_white') {
      return Colors.black.withOpacity(0.1);
    }
    return Colors.white.withOpacity(0.1);
  }
}
