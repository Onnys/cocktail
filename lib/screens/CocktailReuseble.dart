import 'package:cocktail/services/Cocktail.dart';
import 'package:cocktail/screens/CocktailDetails.dart';
import 'package:flutter/material.dart';

class CocktailTile extends StatefulWidget {
  const CocktailTile({
    @required this.cocktails,
    @required this.index,
  });

  final List<Cocktail> cocktails;
  final int index;

  @override
  _CocktailTileState createState() => _CocktailTileState();
}

class _CocktailTileState extends State<CocktailTile> {
  Color favoriteColor = Colors.black;
  bool isfavorite = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
         
          return CocktailDetails(
            id: widget.cocktails[widget.index].idDrink,
            title: widget.cocktails[widget.index].strDrink,
            image: widget.cocktails[widget.index].strDrinkThumb,
          );
        }));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width / 2,
                height: 450,
                child: Image.network(
                  widget.cocktails[widget.index].strDrinkThumb ?? 'https://i2.wp.com/www.silocreativo.com/en/wp-content/uploads/2017/11/ejemplo-pagina-error-404-creativo.png?fit=666%2C370&quality=100&strip=all&ssl=1',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(widget.cocktails[widget.index].strDrink,
                    textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
