import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/board.dart';
import '../models/cat.dart';
import '../models/drink.dart';

class LocalStorage {
  static const String boardKey = "board_data";
  static const String catKey = "cat_data";
  static const String drinkKey = "drink_data";

  Future<List<Board>> LoadBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(boardKey);
    print("Loaded JSON: $jsonString");

    if (jsonString == null) {
      print("BOARDS EMPTY");
      return []; // Return an empty list if no data is found
    }

    try {
      final List<dynamic> jsonList = json.decode(
        jsonString,
      ); // Decode as a list
      return jsonList.map((boardJson) => Board.FromJson(boardJson)).toList();
    } catch (e) {
      print("Error loading boards: $e");
      return []; // Return an empty list on error
    }
  }

  Future<void> SaveBoards(List<Board> boards) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = boards.map((board) => board.ToJson()).toList();

    final jsonString = json.encode(jsonList);
    await prefs.setString(boardKey, jsonString);
  }

  Future<Cat> LoadCat() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(catKey);
    print("Loaded  CAT JSON: $jsonString");

    if (jsonString == null) {
      print("CAT JSON EMPY");
      return Cat(
        name: "Macka Hnacka",
      ); // Return an empty list if no data is found
    }

    try {
      final Map<String, dynamic> catJson = json.decode(
        jsonString,
      ); // Decode as a list
      return Cat.FromJson(catJson);
    } catch (e) {
      print("Error loading cat: $e");
      return Cat(name: "Error"); // Return an empty list on error
    }
  }

  Future<void> SaveCat(Cat cat) async {
    final prefs = await SharedPreferences.getInstance();

    final catJson = cat.ToJson();

    final jsonString = json.encode(catJson);
    await prefs.setString(catKey, jsonString);
  }

  Future<Drink> LoadDrink() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(drinkKey);

    print("Loaded DRINK JSON: $jsonString");

    if (jsonString == null) {
      print("DRINK JSON EMPTYU");
      // If no data is found, return a default Drink instance
      return Drink();
    }

    try {
      // Decode the JSON string
      final Map<String, dynamic> drinkJson =
          json.decode(jsonString) as Map<String, dynamic>;
      return Drink.FromJson(drinkJson);
    } catch (e) {
      // Handle any errors during decoding
      print("Error loading drink: $e");
      return Drink(); // Return a default Drink instance on error
    }
  }

  Future<void> SaveDrink(Drink drink) async {
    final prefs = await SharedPreferences.getInstance();

    final drinkJson = drink.ToJson();

    final jsonString = json.encode(drinkJson);
    await prefs.setString(drinkKey, jsonString);
  }
}
