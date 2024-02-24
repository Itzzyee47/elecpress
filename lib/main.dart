import 'package:flutter/material.dart';
import 'package:elecpress/screens/desktop/desk_home.dart';
import 'package:elecpress/screens/mobile/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add MaterialApp here
      // title: 'ELECTPRESS',
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Display desktop view
              return DesktopView();
            } else {
              // Display mobile view
              return MyHomePage();
            }
          },
        ),
      ),
    );
  }
}
