import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/drinkProvider.dart';

import '../services/notificationService.dart';

class DrinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drinkProvider = Provider.of<DrinkProvider>(context);
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final dateFormatter = DateFormat('HH:mm'); // Define date format
    List<Map<String, dynamic>> addButtons = [
      {"label": "+100ml", "amount": 100},
      {"label": "+150ml", "amount": 150},
      {"label": "+250ml", "amount": 250},
      {"label": "+300ml", "amount": 300},
      {"label": "+400ml", "amount": 400},
      {"label": "+500ml", "amount": 500},
    ];
    return Scaffold(
      appBar: AppBar(title: Text("Drink")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Today:  ", style: TextStyle(fontSize: 14)),
                    TextSpan(
                      text: drinkProvider.drink.today.toString() + "ml / ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: drinkProvider.drink.goal.toString() + "ml",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.5),
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 50,
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: Transform.rotate(
                              angle: pi + pi / 4,
                              child: CircularProgressIndicator(
                                value: drinkProvider.drinkRatio * 0.75,
                                strokeWidth: 30,
                                color: Colors.cyanAccent,
                                backgroundColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: Transform.rotate(
                              angle: pi - pi / 4,
                              child: CircularProgressIndicator(
                                value: 0.25,
                                strokeWidth: 35,
                                color: backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(alignment: Alignment.bottomLeft, child: Text("0l")),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text("${drinkProvider.drink.goal / 2000}l"),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text("${drinkProvider.drink.goal / 1000}l "),
                    ),
                    Align(
                      alignment: Alignment(0, 0.35),
                      child: IconButton(
                        onPressed: () {
                          NotificationService().ShowNotification(
                            title: "funguje too",
                            body: "supertext",
                          );
                          TextEditingController inputController =
                              TextEditingController();

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Amount"),
                                content: TextField(
                                  autofocus: true,
                                  controller: inputController,
                                  decoration: InputDecoration(
                                    hintText: "Milliliters",
                                  ),
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
                                      drinkProvider.AddDrink(
                                        int.parse(inputController.text),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Confirm"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.add),
                        iconSize: 64,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 260,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                padding: EdgeInsets.all(16),
                children: [
                  ...addButtons.map((button) {
                    return ElevatedButton(
                      onPressed: () {
                        drinkProvider.AddDrink(button['amount']);
                      },
                      child: Text(button['label']),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...drinkProvider.drink.activity.entries.toList().reversed.map((
              entry,
            ) {
              final date = entry.key; // The date (e.g., "17/03/2025")
              final data = entry.value; // The data for that date

              // Validate the history field
              final history = (data['history'] as Map<dynamic, dynamic>).map(
                (key, value) => MapEntry(key as String, value as int),
              );

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Total: ${data['today']}ml",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    children:
                        history.entries.toList().reversed.map((historyEntry) {
                          final time = DateTime.parse(historyEntry.key);
                          final formattedTime = dateFormatter.format(time);
                          final amount = historyEntry.value;

                          return ListTile(
                            leading: Icon(
                              Icons.local_drink,
                              color: Colors.blue,
                            ),
                            title: Text(
                              "+${amount}ml",
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
