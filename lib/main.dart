import 'package:flutter/material.dart';
import 'screens/galeria_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galería SQLite',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GaleriaScreen(),
    );
  }
}
