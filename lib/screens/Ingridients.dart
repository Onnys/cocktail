import 'package:flutter/material.dart';

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
