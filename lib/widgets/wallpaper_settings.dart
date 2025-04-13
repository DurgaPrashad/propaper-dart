import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:propaper/providers/wallpaper_provider.dart';
import 'package:propaper/services/wallpaper_service.dart';

class WallpaperSettings extends StatelessWidget {
  final VoidCallback onSetWallpaper;

  const WallpaperSettings({
    Key? key,
    required this.onSetWallpaper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WallpaperProvider>(
      builder: (context, wallpaperProvider, child) {
        final settings = wallpaperProvider.settings;
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallpaper Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Background selection
                const Text(
                  'Background',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: settings.background,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.wallpaper),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'black_white',
                      child: Text('Black & White'),
                    ),
                    const DropdownMenuItem(
                      value: 'solid_black',
                      child: Text('Solid Black'),
                    ),
                    const DropdownMenuItem(
                      value: 'solid_white',
                      child: Text('Solid White'),
                    ),
                    if (settings.isPremium) ...[
                      const DropdownMenuItem(
                        value: 'gradient_purple',
                        child: Text('Gradient Purple'),
                      ),
                      const DropdownMenuItem(
                        value: 'gradient_blue',
                        child: Text('Gradient Blue'),
                      ),
                      const DropdownMenuItem(
                        value: 'gradient_green',
                        child: Text('Gradient Green'),
                      ),
                    ] else
                      const DropdownMenuItem(
                        value: 'premium',
                        child: Text('Premium Gradients (Upgrade)'),
                        enabled: false,
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null && value != 'premium') {
                      wallpaperProvider.updateSettings(background: value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Contrast slider (only for black & white)
                if (settings.background == 'black_white') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Contrast',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${settings.contrast}%'),
                    ],
                  ),
                  Slider(
                    value: settings.contrast.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${settings.contrast}%',
                    onChanged: (value) {
                      wallpaperProvider.updateSettings(
                        contrast: value.round(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Font selection
                const Text(
                  'Font',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: settings.font,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.font_download),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'Inter',
                      child: Text('Inter'),
                    ),
                    const DropdownMenuItem(
                      value: 'Roboto',
                      child: Text('Roboto'),
                    ),
                    const DropdownMenuItem(
                      value: 'Poppins',
                      child: Text('Poppins'),
                    ),
                    if (settings.isPremium)
                      const DropdownMenuItem(
                        value: 'Montserrat',
                        child: Text('Montserrat'),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      wallpaperProvider.updateSettings(font: value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Font size selection
                const Text(
                  'Font Size',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: settings.fontSize,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.format_size),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'small',
                      child: Text('Small'),
                    ),
                    DropdownMenuItem(
                      value: 'medium',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'large',
                      child: Text('Large'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      wallpaperProvider.updateSettings(fontSize: value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Show tasks selection
                const Text(
                  'Show Tasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: settings.showType,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.visibility),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All Tasks'),
                    ),
                    DropdownMenuItem(
                      value: 'today',
                      child: Text('Today Only'),
                    ),
                    DropdownMenuItem(
                      value: 'priority',
                      child: Text('High Priority Only'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      wallpaperProvider.updateSettings(showType: value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Auto-update toggle
                Row(
                  children: [
                    Switch(
                      value: settings.autoUpdate,
                      onChanged: (value) {
                        wallpaperProvider.updateSettings(autoUpdate: value);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Auto-update based on time'),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Premium features banner
                if (!settings.isPremium)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        style: BorderStyle.dotted,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Premium features'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            wallpaperProvider.upgradeToPremium();
                          },
                          child: const Text('Unlock'),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                
                // Set as wallpaper button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.wallpaper),
                    label: const Text('Set as Wallpaper'),
                    onPressed: () {
                      WallpaperService.setWallpaper(context);
                      onSetWallpaper();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
