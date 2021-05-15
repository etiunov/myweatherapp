import 'package:flutter/material.dart';
import 'package:myiphoneweather/screens/loading_screen.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }
}
