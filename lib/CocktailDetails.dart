import 'package:cocktail/Cocktail.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:cocktail/CocktailNetwork.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CocktailDetails extends StatefulWidget {
  CocktailDetails({this.id, this.image, this.title});

  int id;
  String image, title;
  @override
  _CocktailDetailsState createState() => _CocktailDetailsState();
}

class _CocktailDetailsState extends State<CocktailDetails> {
  PaletteColor _appbarColor;
  String strInstructions = '',
      strIngredient1 = '',
      strTags = '',
      strCategory = '';
  var cocktailDetails;
  @override
  void initState() {
    super.initState();
    _getPaletteColor();
    _getCocktailDetails();
  }

  _getCocktailDetails() async {
    var jsonDetails = await CocktailNetwork()
        .fetchCocktailDetails(http.Client(), id: widget.id);
    cocktailDetails = (convert.jsonDecode(jsonDetails)['drinks'] as List)[0];
    setState(() {
      strTags = cocktailDetails['strTags'];
      strCategory = cocktailDetails['strCategory'];
    });
  }

  _getPaletteColor() async {
    PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.image),
      size: Size(100, 100),
    );
    setState(() {
      if (generator.lightMutedColor != null) {
        _appbarColor = generator.lightMutedColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(

        slivers: [
          SliverAppBar(
            backgroundColor:
                _appbarColor != null ? _appbarColor.color : Colors.blue,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.title, textAlign: TextAlign.end),
                collapseMode: CollapseMode.pin,
                background: Image(
                  image: NetworkImage(widget.image),
                  fit: BoxFit.fill,
                )),
            expandedHeight: 300,
            pinned: true,
          ),
          
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              FutureBuilder<dynamic>(
                future: _getCocktailDetails(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? Ingridients(
                          appbarColor: _appbarColor,
                          cocktailDetails: cocktailDetails)
                      :  Container(
                        padding: EdgeInsets.only(top:100),
                        
                          child: Center(child: CircularProgressIndicator()),
                        );
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class Ingridients extends StatelessWidget {
  const Ingridients({
    Key key,
    @required PaletteColor appbarColor,
    @required this.cocktailDetails,
  })  : _appbarColor = appbarColor,
        super(key: key);

  final PaletteColor _appbarColor;
  final cocktailDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          expandedAlignment: Alignment.topLeft,
          childrenPadding: EdgeInsets.all(16),
          title: Text(
            'Ingredients',
            style: TextStyle(color: _appbarColor.color ?? Colors.blue),
          ),
          children: [
            DataTable(
                dividerThickness: 2,
                columnSpacing: MediaQuery.of(context).size.width / 3,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('Ingredients',
                        style: TextStyle(
                            color: _appbarColor.color ?? Colors.blue)),
                  ),
                  DataColumn(
                    label: Text('Measure',
                        style: TextStyle(
                            color: _appbarColor.color ?? Colors.blue)),
                  ),
                ],
                rows: <DataRow>[
                  for (int i = 0; i < 15; i++)
                    if (cocktailDetails['strIngredient${i + 1}'] != null)
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(cocktailDetails['strIngredient${i + 1}']),
                        ),
                        DataCell(
                          Text(cocktailDetails['strMeasure${i + 1}']),
                        ),
                      ]),
                ])
          ],
        ),
        ExpansionTile(
          expandedAlignment: Alignment.topLeft,
          childrenPadding: EdgeInsets.all(16),
          title: Text('Instructions',
              style: TextStyle(color: _appbarColor.color ?? Colors.blue)),
          children: [
            Text('${cocktailDetails['strInstructions']}'),
          ],
        ),
      ],
    );
  }
}
