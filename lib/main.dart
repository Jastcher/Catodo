import 'package:Cicado/services/notificationService.dart';
import 'package:Cicado/views/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/taskProvider.dart';
import 'providers/themeProvider.dart';
import 'providers/catProvider.dart';
import 'providers/drinkProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService().InitNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CatProvider()),
        ChangeNotifierProxyProvider<CatProvider, DrinkProvider>(
          create: (context) => DrinkProvider(context.read<CatProvider>()),
          update: (context, catProvider, drinkProvider) {
            drinkProvider?.UpdateCatProvider(catProvider);
            return drinkProvider!;
          },
        ),
      ],
      child: const ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      home: const MainScreen(),
    );
  }
}
