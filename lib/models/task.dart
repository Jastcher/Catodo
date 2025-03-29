import 'dart:math';

class Task {
  final int id;
  String name;
  bool isChecked;
  bool isEditing = false;

  Task({required this.name, this.isChecked = false})
    : id = Random().nextInt(100000000);

  Map<String, dynamic> ToJson() => {'name': name, 'isChecked': isChecked};

  factory Task.FromJson(Map<String, dynamic> json) {
    return Task(name: json['name'], isChecked: json['isChecked']);
  }
}
