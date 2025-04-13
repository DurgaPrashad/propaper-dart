import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum Priority { low, medium, high }
enum Category { work, personal, health, education }

class Task {
  final String id;
  final String title;
  final String time;
  final Priority priority;
  final Category category;
  final bool completed;

  Task({
    String? id,
    required this.title,
    required this.time,
    required this.priority,
    required this.category,
    this.completed = false,
  }) : id = id ?? const Uuid().v4();

  Task copyWith({
    String? title,
    String? time,
    Priority? priority,
    Category? category,
    bool? completed,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'priority': priority.index,
      'category': category.index,
      'completed': completed,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      priority: Priority.values[json['priority']],
      category: Category.values[json['category']],
      completed: json['completed'],
    );
  }

  Color getPriorityColor() {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String getCategoryName() {
    switch (category) {
      case Category.work:
        return 'Work';
      case Category.personal:
        return 'Personal';
      case Category.health:
        return 'Health';
      case Category.education:
        return 'Education';
    }
  }

  IconData getCategoryIcon() {
    switch (category) {
      case Category.work:
        return Icons.work;
      case Category.personal:
        return Icons.person;
      case Category.health:
        return Icons.favorite;
      case Category.education:
        return Icons.school;
    }
  }
}
