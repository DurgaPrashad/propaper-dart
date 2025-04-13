import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:propaper/providers/task_provider.dart';
import 'package:propaper/providers/wallpaper_provider.dart';
import 'package:propaper/models/task.dart';

class WallpaperPreview extends StatelessWidget {
  const WallpaperPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskProvider, WallpaperProvider>(
      builder: (context, taskProvider, wallpaperProvider, child) {
        final settings = wallpaperProvider.settings;
        final filteredTasks = taskProvider.getFilteredTasks(settings.showType);
        final activeTasks = filteredTasks.where((task) => !task.completed).toList();
        
        return Column(
          children: [
            const Text(
              'Wallpaper Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 225,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: wallpaperProvider.getBackgroundGradient(),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Text(
                    "TODAY'S TASKS",
                    style: TextStyle(
                      color: wallpaperProvider.getTextColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 2,
                    color: wallpaperProvider.getTextColor().withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tasks
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: activeTasks.isEmpty
                          ? Center(
                              child: Text(
                                'No tasks to display',
                                style: TextStyle(
                                  color: wallpaperProvider.getTextColor().withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: activeTasks.length,
                              itemBuilder: (context, index) {
                                final task = activeTasks[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: wallpaperProvider.getCardBackground(),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: task.getPriorityColor().withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: wallpaperProvider.getTextStyle().copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: wallpaperProvider.getTextColor().withOpacity(0.7),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            task.time,
                                            style: wallpaperProvider.getTextStyle().copyWith(
                                              fontSize: 12,
                                              color: wallpaperProvider.getTextColor().withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  
                  // Premium indicator for gradient backgrounds
                  if (settings.isPremium && settings.background.startsWith('gradient'))
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.palette,
                          size: 16,
                          color: wallpaperProvider.getTextColor().withOpacity(0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
