import 'package:Cicado/views/catScreen.dart';
import 'package:Cicado/views/homeScreen.dart';
import 'package:Cicado/views/drinkScreen.dart';
import 'package:flutter/material.dart';
import '../providers/themeProvider.dart';
import '../providers/catProvider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final catProvider = Provider.of<CatProvider>(context);
    final List<Widget> screens = [
      HomeScreen(
        themeMode: themeProvider.themeMode,
        ToggleTheme: themeProvider.ToggleTheme,
      ),
      CatScreen(),
      DrinkScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                catProvider.CalculateHappiness();
              });
            }
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Todo'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Cat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink_rounded),
            label: 'Drink',
          ),
        ],
      ),
    );
  }
}
