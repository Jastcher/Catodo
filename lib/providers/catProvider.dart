import 'package:flutter/material.dart';
import '../services/localStorage.dart';
import '../models/cat.dart';
import '../models/drink.dart';

class CatProvider extends ChangeNotifier {
  final LocalStorage localStorage = LocalStorage();

  late Cat cat = Cat(name: "Loading");

  CatProvider() {
    InitializeCat();
  }

  void InitializeCat() async {
    cat = await localStorage.LoadCat();
  }

  Future<void> PreloadImages(BuildContext context) async {
    // List of images to preload

    for (String imagePath in cat.images) {
      await precacheImage(AssetImage(imagePath), context);
    }
  }

  void CalculateThirst(Drink drink) {
    DateTime now = DateTime.now(); // Current date and time
    DateTime startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ); // Start of the day
    Duration difference = now.difference(
      startOfDay,
    ); // Difference between now and start of the day
    int thirst =
        (100 -
                (drink.goal / 24 / drink.goal * 100 * difference.inHours) +
                drink.today / drink.goal * 100)
            .toInt();

    print("Thirst: $thirst");

    cat.thirst = 0;
    AddThirst(thirst);
  }

  void CalculateHappiness() {
    Duration happinessDifference = DateTime.now().difference(
      cat.lastHappinessUpdate,
    );

    UpdateStat("happiness", -(happinessDifference.inMinutes / 2).round());
    cat.lastHappinessUpdate = DateTime.now();

    localStorage.SaveCat(cat);
    notifyListeners();
  }

  void AddThirst(int percentage) {
    cat.thirst += percentage;
    cat.thirst = cat.thirst.clamp(0, 100);

    if (cat.thirst == 0) {
      cat.Kill();
    }

    cat.UpdateMood();
    localStorage.SaveCat(cat);

    notifyListeners();
  }

  void UpdateStat(String stat, int amount) {
    if (cat.dead) return;
    switch (stat) {
      case 'health':
        cat.health += amount;
      case 'happiness':
        cat.happiness += amount;
      case 'thirst':
        cat.thirst += amount;
      case 'hunger':
        cat.hunger += amount;
    }

    cat.health = cat.health.clamp(0, 100);
    cat.happiness = cat.happiness.clamp(0, 100);
    cat.thirst = cat.thirst.clamp(0, 100);
    cat.hunger = cat.hunger.clamp(0, 100);

    if (cat.thirst == 0) {
      cat.Kill();
    }

    cat.UpdateMood();
    localStorage.SaveCat(cat);

    notifyListeners();
  }

  void NewCat() {
    cat = Cat(name: "Macka Hnacka");
    localStorage.SaveCat(cat);
    notifyListeners();
  }

  void SetName(String newName) {
    cat.name = newName;
    localStorage.SaveCat(cat);
    notifyListeners();
  }
}
