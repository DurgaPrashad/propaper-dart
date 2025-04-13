import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:propaper/providers/auth_provider.dart';
import 'package:propaper/providers/task_provider.dart';
import 'package:propaper/providers/wallpaper_provider.dart';
import 'package:propaper/screens/login_screen.dart';
import 'package:propaper/widgets/task_list.dart';
import 'package:propaper/widgets/task_edit_form.dart';
import 'package:propaper/widgets/wallpaper_settings.dart';
import 'package:propaper/widgets/wallpaper_preview.dart';
import 'package:propaper/models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Task? _editingTask;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _editingTask = null;
      });
    }
  }

  void _handleEditTask(Task task) {
    setState(() {
      _editingTask = task;
      _tabController.animateTo(1);
    });
  }

  void _handleAddTask() {
    setState(() {
      _editingTask = null;
      _tabController.animateTo(1);
    });
  }

  void _handleSaveTask(Task task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    if (_editingTask != null) {
      taskProvider.updateTask(task);
    } else {
      taskProvider.addTask(task);
    }
    
    _tabController.animateTo(0);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingTask != null ? 'Task updated' : 'Task added'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _handleUpgradeToPremium() {
    final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
    wallpaperProvider.upgradeToPremium();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Premium features unlocked!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final wallpaperProvider = Provider.of<WallpaperProvider>(context);
    final isPremium = wallpaperProvider.settings.isPremium;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProPaper'),
        actions: [
          if (!isPremium)
            TextButton(
              onPressed: _handleUpgradeToPremium,
              child: const Text('Upgrade'),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Premium badge if user is premium
            if (isPremium)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            // Tab bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Edit Task'),
                Tab(text: 'Wallpaper'),
              ],
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard tab
                  TaskList(
                    onEditTask: _handleEditTask,
                    onAddTask: _handleAddTask,
                  ),
                  
                  // Edit task tab
                  TaskEditForm(
                    task: _editingTask,
                    onSave: _handleSaveTask,
                    onCancel: () => _tabController.animateTo(0),
                  ),
                  
                  // Wallpaper tab
                  isSmallScreen
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              WallpaperSettings(
                                onSetWallpaper: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Wallpaper applied successfully!'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              const WallpaperPreview(),
                            ],
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: WallpaperSettings(
                                onSetWallpaper: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Wallpaper applied successfully!'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 24),
                            const Expanded(
                              flex: 2,
                              child: WallpaperPreview(),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
