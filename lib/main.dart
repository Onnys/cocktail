import 'package:cocktail/screens/home.dart';
import 'package:flutter/material.dart';


main() => runApp(Coktail());

class Coktail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      title: 'Coktail',
      home: Home(),
    );
  }
}


