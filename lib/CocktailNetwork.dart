import 'package:cocktail/Cocktail.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CocktailNetwork {
  CocktailNetwork();

  Future<List<Cocktail>> fetchCocktail(http.Client client, {bool alcoholic= false}) async {
    http.Response response;
    try {
      alcoholic ? 
      response = await client.get(
          "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"):

      response = await client.get(
          "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic");
      
    } catch (e) {
      print(e);
    }
    return compute(parseCocktail,response.body);
    
  }
  
}

List<Cocktail> parseCocktail(String responseBody) {
    var parsedJsonCocktail = convert.jsonDecode(responseBody)['drinks'] as List;
    
    return parsedJsonCocktail.map((cocktailJson) => Cocktail.fromJson(cocktailJson)).toList();
    
}
