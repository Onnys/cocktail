import 'package:cocktail/screens/Ingridients.dart';
import 'package:cocktail/services/CocktailNetwork.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:palette_generator/palette_generator.dart';

class CocktailDetails extends StatefulWidget {
  static const String id = 'CocktailDetails';
  int idcocktail;
  String image;
  String title;
  CocktailDetails({@required this.idcocktail, this.image, this.title});
  @override
  _CocktailDetailsState createState() => _CocktailDetailsState();
}

class _CocktailDetailsState extends State<CocktailDetails> {
  var cocktailDetails;
  PaletteColor _appbarColor;

  Future<void> _getPaletteColor() async {
    PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.image),
      size: Size(100, 100),
    );
    if (generator.lightMutedColor != null) {
      setState(() {
        _appbarColor = generator.lightMutedColor;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPaletteColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.title),
              background: Image(
                image: NetworkImage(widget.image ??
                    'https://i2.wp.com/www.silocreativo.com/en/wp-content/uploads/2017/11/ejemplo-pagina-error-404-creativo.png?fit=666%2C370&quality=100&strip=all&ssl=1'),
                fit: BoxFit.fill,
              ),
            ),
            backgroundColor:
                _appbarColor != null ? _appbarColor.color : Colors.blue,
            expandedHeight: 300,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                FutureBuilder(
                  future: CocktailNetwork()
                      .fetchCocktailDetails(http.Client(), id: widget.idcocktail),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? Ingridients(
                            cocktailDetails: snapshot.data,
                            appbarColor: _appbarColor != null
                                ? _appbarColor.color
                                : Colors.black12,
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
