import 'package:flutter/material.dart';
import 'dart:math';
import 'task.dart';

class Board {
  final int id;

  String name;
  bool isEditing = false;
  List<Task> tasks = [];

  Board({required this.name, required this.tasks})
    : id = Random().nextInt(100000000);

  void AddTask(Task task) {
    tasks.add(task);
  }

  void RemoveTask(int index) {
    tasks.removeAt(index);
  }

  void ReorderTask(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
  }

  factory Board.FromJson(Map<String, dynamic> json) {
    return Board(
      name: json['name'],
      tasks:
          (json['tasks'] as List)
              .map((taskJson) => Task.FromJson(taskJson))
              .toList(),
    );
  }

  Map<String, dynamic> ToJson() {
    return {'name': name, 'tasks': tasks.map((task) => task.ToJson()).toList()};
  }
}
