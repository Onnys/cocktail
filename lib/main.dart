import 'package:cocktail/Cocktail.dart';
import 'package:cocktail/CocktailNetwork.dart';
import 'package:cocktail/CocktailReuseble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

main() => runApp(Coktail());

class Coktail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.grey[100],accentColor: Colors.grey[800]),
      title: 'Coktail',
      home: Home(),
    );
  }
}
class Navegation extends StatefulWidget {
  @override
  _NavegationState createState() => _NavegationState();
}

class _NavegationState extends State<Navegation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigationBar(

        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        items:[ BottomNavigationBarItem( icon: Icon(Icons.home)),BottomNavigationBarItem(icon: Icon(Icons.home))]),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CocktailNetwork cock = CocktailNetwork();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cocktail'),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(
              text: 'Non Alcoholic',
            ),
            Tab(text: 'Alcoholic'),
          ]),
        ),
        body: TabBarView(children: [
          FutureBuilder<List<Cocktail>>(
              future: cock.fetchCocktail(http.Client(), alcoholic: true),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? CocktailList(
                        cocktails: snapshot.data,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              }),
          FutureBuilder<List<Cocktail>>(
              future: cock.fetchCocktail(http.Client(), alcoholic: false),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? CocktailList(
                        cocktails: snapshot.data,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              })
        ]),
      ),
    );
  }
}

class CocktailList extends StatefulWidget {
  List<Cocktail> cocktails = List<Cocktail>();
  CocktailList({this.cocktails});

  @override
  _CocktailListState createState() => _CocktailListState();
}

class _CocktailListState extends State<CocktailList> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      controller: controller,
      itemCount: widget.cocktails.length,
      itemBuilder: (context, index) {
        return CocktailTile(
          cocktails: widget.cocktails,
          index: index,
        );
      },
    );
  }
}

