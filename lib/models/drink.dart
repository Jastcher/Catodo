import 'package:intl/intl.dart';

class Drink {
  int goal; //ml

  Map<String, Map<String, dynamic>> activity =
      {}; // {date : {today: 0, history: {time: amount}}}

  Drink({this.goal = 1500});

  int get today =>
      activity[DateFormat('dd/MM/yyyy').format(DateTime.now())]?['today'] ?? 0;

  void AddDrink(int amount) {
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (!activity.containsKey(today)) {
      activity[today] = {'today': 0, 'history': {}};
    }

    activity[today]?['today'] += amount;

    activity[today]?['history'][DateTime.now().toIso8601String()] = amount;
  }

  factory Drink.FromJson(Map<String, dynamic> json) {
    Drink drink = Drink(goal: json['goal']);

    // Deserialize the activity map
    drink.activity = (json['activity'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, {
        'today': value['today'] as int,
        'history': (value['history'] as Map<dynamic, dynamic>).map(
          (historyKey, historyValue) =>
              MapEntry(historyKey as String, historyValue as int),
        ),
      }),
    );

    return drink;
  }

  Map<String, dynamic> ToJson() {
    return {'goal': goal, 'activity': activity};
  }
}
