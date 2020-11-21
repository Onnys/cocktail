import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class CocktailDetails extends StatefulWidget {
  CocktailDetails({this.image, this.title});

  String image, title;
  @override
  _CocktailDetailsState createState() => _CocktailDetailsState();
}

class _CocktailDetailsState extends State<CocktailDetails> {
  PaletteColor _appbarColor;
  @override
  void initState() {
    super.initState();
    _getPaletteColor();
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
                title: Text(widget.title,textAlign: TextAlign.end),
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
              Text('data'),
              SizedBox(
                height: 200,
              ),
              Text('data'),
              Text('data'),
              Text('data'),
              Text('data'),
              SizedBox(
                height: 200,
              ),
              Text('data'),
              Text('data'),
              Text('data'),
              Text('data'),
              SizedBox(
                height: 200,
              ),
              Text('data'),
              SizedBox(
                height: 200,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
