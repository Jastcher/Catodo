import 'package:Cicado/services/localStorage.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/board.dart';
import 'package:flutter/cupertino.dart';

class TaskProvider extends ChangeNotifier {
  final LocalStorage localStorage = LocalStorage();
  List<Board> boards = [Board(name: "Default", tasks: [])];
  Board currentBoard = Board(name: "Default", tasks: []);

  TaskProvider() {
    InitializeTasks();
  }

  void InitializeTasks() async {
    boards = await localStorage.LoadBoards();

    if (boards.isEmpty) {
      CreateBoard("Default");
    }

    currentBoard = boards[0];
    notifyListeners();
  }

  void ToggleEditing(dynamic taskOrBoard, bool isEditing) {
    taskOrBoard.isEditing = isEditing;
    notifyListeners();
  }

  void ReorderBoard(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final board = boards.removeAt(oldIndex);
    boards.insert(newIndex, board);
    localStorage.SaveBoards(boards);
    notifyListeners();
  }

  void ReorderTask(int oldIndex, int newIndex) {
    currentBoard.ReorderTask(oldIndex, newIndex);
    localStorage.SaveBoards(boards);
    notifyListeners();
  }

  void SetCurrentBoard(int index) {
    currentBoard = boards[index];
    notifyListeners();
  }

  void CreateBoard(String name) {
    boards.add(Board(name: name, tasks: []));
    currentBoard = boards[boards.length - 1];
    localStorage.SaveBoards(boards);
    notifyListeners();
  }

  void RemoveBoard(int index) {
    boards.removeAt(index);
    if (boards.isEmpty) {
      CreateBoard("Default");
    }
    currentBoard = boards[0];
    localStorage.SaveBoards(boards);
    notifyListeners();
  }

  void AddTask(String name) {
    currentBoard.AddTask(Task(name: name));
    localStorage.SaveBoards(boards);
    notifyListeners();
  }

  void RemoveTask(int index) {
    currentBoard.RemoveTask(index);
    localStorage.SaveBoards(boards);
    notifyListeners();
  }

  void ToggleTask(Task task) {
    task.isChecked = !task.isChecked;
    localStorage.SaveBoards(boards);
    notifyListeners();
  }
}
