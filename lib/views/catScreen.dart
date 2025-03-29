import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/catProvider.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  CatScreenState createState() => CatScreenState();
}

class CatScreenState extends State<CatScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catProvider = Provider.of<CatProvider>(context, listen: false);
      catProvider.PreloadImages(context);
    });
  }

  DateTime? lastPetTime;
  Widget build(BuildContext context) {
    final catProvider = Provider.of<CatProvider>(context);
    final List<Map<String, dynamic>> progressBars = [
      //{
      //  "label": "Health",
      //  "value": catProvider.cat.health / 100,
      //  "color": Colors.green,
      //},
      {
        "label": "Happiness",
        "value": catProvider.cat.happiness / 100,
        "color": Colors.purple,
      },
      {
        "label": "Thirst",
        "value": catProvider.cat.thirst / 100,
        "color": Colors.cyanAccent,
      },
      //{
      //  "label": "Hunger",
      //  "value": catProvider.cat.hunger / 100,
      //  "color": Colors.brown,
      //},
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(catProvider.cat.name),
        actions: [
          IconButton(
            onPressed: () {
              TextEditingController inputController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Rename Cat"),
                    content: TextField(
                      autofocus: true,
                      controller: inputController,
                      decoration: InputDecoration(hintText: "New name"),
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
                          catProvider.SetName(inputController.text);
                          Navigator.of(context).pop();
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.drive_file_rename_outline),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (lastPetTime == null ||
                    DateTime.now().difference(lastPetTime!) >
                        const Duration(milliseconds: 100)) {
                  int speed = min((details.delta.distance.ceil()).toInt(), 2);
                  print(speed);
                  lastPetTime = DateTime.now();
                  catProvider.UpdateStat("happiness", speed);
                }
              },
              child: Image.asset(catProvider.cat.currentImage),
            ),
          ),
          const SizedBox(height: 16),
          if (catProvider.cat.dead) Text("${catProvider.cat.name} is dead"),
          Text("age: ${catProvider.cat.aliveFor.toStringAsFixed(2)} days"),
          ...progressBars.map((bar) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 48),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 100, child: Text(bar['label'])),
                  Expanded(
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      value: bar['value'],
                      minHeight: 16,
                      color: bar['color'],
                    ),
                  ),
                  if (false)
                    IconButton(
                      onPressed: () {
                        catProvider.UpdateStat(bar['label'].toLowerCase(), 10);
                      },
                      icon: Icon(Icons.arrow_upward),
                    ),
                  if (false)
                    IconButton(
                      onPressed: () {
                        catProvider.UpdateStat(bar['label'].toLowerCase(), -10);
                      },
                      icon: Icon(Icons.arrow_downward),
                    ),
                ],
              ),
            );
          }),
          if (catProvider.cat.dead)
            ElevatedButton(
              onPressed: () {
                catProvider.NewCat();
              },
              child: Text("New cat"),
            ),
        ],
      ),
    );
  }
}
