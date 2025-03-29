import 'package:Cicado/providers/taskProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(bool) ToggleTheme;

  const HomeScreen({
    Key? key,
    required this.themeMode,
    required this.ToggleTheme,
  }) : super(key: key);

  Future<String?> ShowAddDialog(BuildContext context, String title) async {
    TextEditingController taskController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: "Enter name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(taskController.text);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      drawer: Drawer(
        child: Scaffold(
          appBar: AppBar(title: Text("Boards")),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String? boardName = await ShowAddDialog(context, "Add new board");
              if (boardName != null && boardName.isNotEmpty) {
                taskProvider.CreateBoard(boardName);
              }
            },
            child: Icon(Icons.add),
          ),
          body: ReorderableListView(
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) {
              taskProvider.ReorderBoard(oldIndex, newIndex);
            },
            children:
                taskProvider.boards.map((entry) {
                  int index = taskProvider.boards.indexOf(entry);
                  return ListTile(
                    key: ValueKey(entry.id),
                    title:
                        entry.isEditing
                            ? TextField(
                              autofocus: true,
                              controller: TextEditingController(
                                text: entry.name,
                              ),
                              onSubmitted: (name) {
                                if (name.isNotEmpty) {
                                  entry.name = name;
                                }
                                taskProvider.ToggleEditing(entry, false);
                              },
                            )
                            : Text(entry.name),
                    trailing: Row(
                      mainAxisSize:
                          MainAxisSize
                              .min, // Ensures the row takes up minimal space
                      children: [
                        IconButton(
                          onPressed: () {
                            taskProvider.RemoveBoard(index);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        ReorderableDragStartListener(
                          index: index, // Pass the index of the item
                          child: Icon(Icons.drag_handle), // Drag handle icon
                        ),
                      ],
                    ),
                    onTap: () {
                      taskProvider.SetCurrentBoard(index);
                      Navigator.of(context).pop();
                    },
                    onLongPress: () {
                      taskProvider.ToggleEditing(entry, true);
                    },
                  );
                }).toList(),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(taskProvider.currentBoard.name),
        actions: [
          Row(
            children: [
              Icon(
                themeMode == ThemeMode.dark
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
              ),
              Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: ToggleTheme,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? taskName = await ShowAddDialog(context, "Add new task");
          if (taskName != null && taskName.isNotEmpty) {
            taskProvider.AddTask(taskName);
          }
        },
        tooltip: "add new task",
        child: Icon(Icons.add),
      ),
      body: ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          taskProvider.ReorderTask(oldIndex, newIndex);
        },
        children:
            taskProvider.currentBoard.tasks.map((item) {
              int index = taskProvider.currentBoard.tasks.indexOf(item);
              return ListTile(
                key: ValueKey(item.id),
                title:
                    item.isEditing
                        ? TextField(
                          autofocus: true,
                          controller: TextEditingController(text: item.name),
                          onSubmitted: (newName) {
                            if (newName.isNotEmpty) {
                              item.name = newName;
                              taskProvider.ToggleEditing(item, false);
                            }
                          },
                        )
                        : Text(
                          item.name,
                          style: TextStyle(
                            decoration:
                                item.isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                leading: Checkbox(
                  value: item.isChecked,

                  onChanged: (value) {
                    taskProvider.ToggleTask(item);
                  },
                ),
                trailing: Row(
                  mainAxisSize:
                      MainAxisSize
                          .min, // Ensures the row takes up minimal space
                  children: [
                    IconButton(
                      onPressed: () {
                        taskProvider.RemoveTask(index);
                      },
                      icon: Icon(Icons.delete),
                    ),
                    ReorderableDragStartListener(
                      index: index, // Pass the index of the item
                      child: Icon(Icons.drag_handle), // Drag handle icon
                    ),
                  ],
                ),
                onTap: () {
                  taskProvider.ToggleTask(item);
                },
                onLongPress: () {
                  taskProvider.ToggleEditing(item, true);
                },
              );
            }).toList(),
      ),
    );
  }
}
