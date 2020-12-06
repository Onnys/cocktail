import 'package:cocktail/screens/CocktailReuseble.dart';
import 'package:cocktail/services/Cocktail.dart';
import 'package:cocktail/services/CocktailNetwork.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
