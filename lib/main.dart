import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(Discord());
}

class Discord extends StatelessWidget {
  const Discord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
