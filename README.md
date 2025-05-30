# ProPaper

![ProPaper App](https://github.com/user-attachments/assets/8f5cf364-ff94-47b4-811b-3b16b7d62391)

A powerful Flutter application that transforms your device's wallpaper into a dynamic task manager.

## Overview

ProPaper seamlessly integrates your tasks into your device's home screen wallpaper, providing at-a-glance access to your to-do list without opening an app. Manage tasks efficiently and customize how they appear on your wallpaper with various styling options.

![Task Management Interface](https://github.com/user-attachments/assets/4699a0be-4563-4a44-a612-ad7f285715d6)

## Key Features

- **Comprehensive Task Management**
  - Create, edit, and delete tasks
  - Organize with priorities and categories
  - Real-time updates based on current time

- **Extensive Wallpaper Customization**
  - Multiple background styles including adjustable B&W contrast
  - Premium gradient backgrounds (Purple, Blue, Green)
  - Font customization options
  - Flexible display settings

- **Cross-Platform Support**
  - Android: Full functionality with direct wallpaper setting
  - iOS: Task management and wallpaper preview
  - Web: Task management and wallpaper preview
  - Desktop: Task management and wallpaper preview

![Customization Options](https://github.com/user-attachments/assets/b2a3247a-107f-4ae2-94ee-9cf263ae705c)

## Technical Implementation

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5         # State management
  shared_preferences: ^2.2.0  # Local storage
  uuid: ^3.0.7             # Unique ID generation
  google_fonts: ^5.1.0     # Typography options
  font_awesome_flutter: ^10.5.0  # Icon library
  path_provider: ^2.1.0    # File system access
  flutter_wallpaper_manager: ^0.0.4  # Wallpaper setting (Android)
  intl: ^0.18.1           # Date/time formatting
```

### Architecture

- **State Management**: Provider pattern with three main providers:
  - `AuthProvider`: User authentication state
  - `TaskProvider`: Task CRUD operations and state
  - `WallpaperProvider`: Wallpaper appearance settings

- **Data Persistence**: SharedPreferences for local storage of user preferences and tasks

- **Responsive Design**:
  - Adaptive layouts for different screen sizes
  - Optimized UI for mobile and desktop experiences

- **Platform-Specific Implementations**:
  - Android: Direct wallpaper setting via flutter_wallpaper_manager
  - iOS: Manual wallpaper setting instructions (due to platform restrictions)

## Premium Features

- Gradient background themes
- Expanded font library
- Custom image backgrounds (coming soon)
- Priority-based visual indicators

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/DurgaPrashad/propaper.git
   ```

2. Navigate to project directory:
   ```bash
   cd propaper
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Development Roadmap

- Custom image background support
- Cloud synchronization
- Widget companion for home screen
- Advanced task categorization
- Theme customization

## License

This project is licensed under the MIT License - see the LICENSE file for details.
