import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../services/localStorage.dart';
import '../services/notificationService.dart';
import 'catProvider.dart';

class DrinkProvider extends ChangeNotifier {
  final LocalStorage localStorage = LocalStorage();

  Drink drink = Drink();
  CatProvider catProvider;

  DrinkProvider(this.catProvider) {
    InitializeDrink();
  }

  void UpdateCatProvider(CatProvider newCatProvider) {
    catProvider = newCatProvider;
  }

  void InitializeDrink() async {
    drink = await localStorage.LoadDrink();
    catProvider.CalculateThirst(drink);
  }

  void AddDrink(int amount) {
    drink.AddDrink(amount);
    localStorage.SaveDrink(drink);
    notifyListeners();

    catProvider.CalculateThirst(drink);
  }

  double get drinkRatio => drink.today / drink.goal;
}
