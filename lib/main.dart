import 'package:cocktail/screens/CocktailDetails.dart';
import 'package:cocktail/screens/home.dart';
import 'package:cocktail/utilities/constants.dart';
import 'package:flutter/material.dart';


main() => runApp(Coktail());

class Coktail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: apptheme,
      title: 'Coktail',
      initialRoute: Home.id,
      routes: {
        Home.id : (context) => Home(), 
      },
    );
  }
}


