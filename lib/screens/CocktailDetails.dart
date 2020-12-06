import 'package:cocktail/services/CocktailNetwork.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:palette_generator/palette_generator.dart';

class CocktailDetails extends StatefulWidget {
  int id;
  String image;
  String title;
  CocktailDetails({@required this.id, this.image, this.title});
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
                image: NetworkImage(widget.image ?? 'https://i2.wp.com/www.silocreativo.com/en/wp-content/uploads/2017/11/ejemplo-pagina-error-404-creativo.png?fit=666%2C370&quality=100&strip=all&ssl=1'),
                fit: BoxFit.fill,
              ),
            ),
            backgroundColor:
                _appbarColor != null ? _appbarColor.color : Colors.blue,
            expandedHeight: 300,
            pinned: true,
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            FutureBuilder(
                future: CocktailNetwork()
                    .fetchCocktailDetails(http.Client(), id: widget.id),
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
                          child: Center(child: CircularProgressIndicator()));
                })
          ]))
        ],
      ),
    );
  }
}

class Ingridients extends StatelessWidget {
  Ingridients({
    Key key,
    this.appbarColor,
    @required this.cocktailDetails,
  });

  Color appbarColor;
  final cocktailDetails;

  @override
  Widget build(BuildContext context) {
    return cocktailDetails != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Icon(Icons.local_drink),
                  Text(
                    'Glass Type :${cocktailDetails['strGlass']}' ?? '',
                    style: TextStyle(color: appbarColor ?? Colors.blue),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              ExpansionTile(
                expandedAlignment: Alignment.topLeft,
                childrenPadding: EdgeInsets.all(16),
                title: Text(
                  'Ingredients',
                  style: TextStyle(color: appbarColor ?? Colors.blue),
                ),
                children: [
                  DataTable(
                      dividerThickness: 2,
                      columnSpacing: MediaQuery.of(context).size.width / 3,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Ingredients',
                              style:
                                  TextStyle(color: appbarColor ?? Colors.blue)),
                        ),
                        DataColumn(
                          label: Text('Measure',
                              style:
                                  TextStyle(color: appbarColor ?? Colors.blue)),
                        ),
                      ],
                      rows: <DataRow>[
                        for (int i = 0; i < 15; i++)
                          if (cocktailDetails['strIngredient${i + 1}'] != null)
                            getIngridientes(i)
                      ])
                ],
              ),
              ExpansionTile(
                expandedAlignment: Alignment.topLeft,
                childrenPadding: EdgeInsets.all(16),
                title: Text('Instructions',
                    style: TextStyle(color: appbarColor ?? Colors.blue)),
                children: [
                  Text('${cocktailDetails['strInstructions']}'),
                ],
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text('Does Have info yet'),
            ),
          );
  }

  DataRow getIngridientes(int i) {
    return DataRow(cells: <DataCell>[
      DataCell(
        Text(cocktailDetails['strIngredient${i + 1}'] ?? ''),
      ),
      DataCell(
        Text(cocktailDetails['strMeasure${i + 1}'] ?? ''),
      ),
    ]);
  }
}
