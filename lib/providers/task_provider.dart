import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:propaper/models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  Timer? _timer;

  TaskProvider() {
    _loadTasks();
    _startAutoUpdateTimer();
  }

  List<Task> get tasks => _tasks;

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks');
    
    if (tasksJson != null) {
      _tasks = tasksJson.map((taskJson) => Task.fromJson(json.decode(taskJson))).toList();
    } else {
      // Default tasks if none exist
      _tasks = [
        Task(
          id: '1',
          title: 'Team meeting',
          time: '10:00 AM',
          priority: Priority.high,
          category: Category.work,
          completed: false,
        ),
        Task(
          id: '2',
          title: 'Grocery shopping',
          time: '4:30 PM',
          priority: Priority.medium,
          category: Category.personal,
          completed: false,
        ),
        Task(
          id: '3',
          title: 'Finish project proposal',
          time: '6:00 PM',
          priority: Priority.high,
          category: Category.work,
          completed: false,
        ),
        Task(
          id: '4',
          title: 'Call mom',
          time: '7:30 PM',
          priority: Priority.low,
          category: Category.personal,
          completed: false,
        ),
      ];
      await _saveTasks();
    }
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _startAutoUpdateTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTasksBasedOnTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTasksBasedOnTime() {
    final now = DateTime.now();
    bool updated = false;

    for (int i = 0; i < _tasks.length; i++) {
      final task = _tasks[i];
      if (task.completed) continue;

      final taskTime = _parseTime(task.time);
      if (taskTime != null && _isTimePassed(now, taskTime)) {
        _tasks[i] = task.copyWith(completed: true);
        updated = true;
      }
    }

    if (updated) {
      _saveTasks();
      notifyListeners();
    }
  }

  DateTime? _parseTime(String timeStr) {
    try {
      final now = DateTime.now();
      final isPM = timeStr.toLowerCase().contains('pm');
      final timeComponents = timeStr.replaceAll(RegExp(r'[APMapm]'), '').trim().split(':');
      
      if (timeComponents.length != 2) return null;
      
      var hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);
      
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;
      
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  bool _isTimePassed(DateTime now, DateTime taskTime) {
    return now.isAfter(taskTime);
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(completed: !_tasks[index].completed);
      await _saveTasks();
      notifyListeners();
    }
  }

  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case 'all':
        return _tasks;
      case 'today':
        final now = DateTime.now();
        return _tasks.where((task) {
          final taskTime = _parseTime(task.time);
          if (taskTime == null) return false;
          return taskTime.day == now.day && 
                 taskTime.month == now.month && 
                 taskTime.year == now.year;
        }).toList();
      case 'priority':
        return _tasks.where((task) => 
          task.priority == Priority.high && !task.completed
        ).toList();
      default:
        return _tasks;
    }
  }
}
