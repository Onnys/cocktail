class Cocktail {
  final String strDrink, strDrinkThumb;
  final int idDrink;
  
  Cocktail({this.strDrink, this.strDrinkThumb, this.idDrink});
  

  factory Cocktail.fromJson(Map<String, dynamic> cocktailJson){
    return Cocktail(
      idDrink: int.parse(cocktailJson['idDrink']),
      strDrink: cocktailJson['strDrink'] as String,
      strDrinkThumb: cocktailJson['strDrinkThumb'] as String,
    );
  }
}