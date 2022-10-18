import 'package:flutter/material.dart';
import 'package:notas_diarias/pages/home_page.dart';
// ignore: unused_import
import 'package:notas_diarias/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: Mythemes.lightTheme,
            darkTheme: Mythemes.darkTheme,
            home: const homePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      );
}
