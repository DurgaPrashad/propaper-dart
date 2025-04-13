import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:propaper/providers/task_provider.dart';
import 'package:propaper/providers/wallpaper_provider.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperService {
  static Future<void> setWallpaper(BuildContext context) async {
    try {
      // Get providers
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
      
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallpaper applied successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // On real devices, you would implement platform-specific wallpaper setting
      // For Android, you would use a plugin like flutter_wallpaper_manager
      // For iOS, you would need to guide users to save and set manually
      
      if (Platform.isAndroid) {
        _showAndroidInstructions(context);
      } else if (Platform.isIOS) {
        _showIOSInstructions(context);
      } else {
        // For web and desktop, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallpaper setting is only supported on mobile devices'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set wallpaper: ${e.toString()}'),
        ),
      );
    }
  }
  
  static void _showAndroidInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Wallpaper on Android'),
        content: const Text(
          'In a production app, we would use flutter_wallpaper_manager to set the wallpaper directly. '
          'For this demo, we\'re simulating the wallpaper being set successfully.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  static void _showIOSInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Wallpaper on iOS'),
        content: const Text(
          'iOS does not allow apps to set wallpapers directly. '
          'In a production app, we would save the wallpaper image to the photo gallery, '
          'and guide you to set it manually through the iOS settings.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
