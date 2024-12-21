import 'dart:convert' show json;
import 'dart:math' show Random;
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchPokemon(
    {String? name, int offset = 0}) async {
  try {
    final url = name!.isEmpty
        ? Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=25&offset=$offset')
        : Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    
    final response = await http.get(url);
    final data = json.decode(response.body);
    List<Map<String, dynamic>> pokemonWithImages = [];

    if (name.isEmpty) {
      final List results = data['results'];

      for (var pokemon in results) {
        final detailsResponse = await http.get(Uri.parse(pokemon['url']));
        final detailsData = json.decode(detailsResponse.body);
        pokemonWithImages.add({
          'name': pokemon['name'],
          'image': detailsData['sprites']['front_default'],
          'id': detailsData['id'],
        });
      }
    } else {
      pokemonWithImages.add({
        'name': data['name'],
        'image': data['sprites']['front_default'],
        'id': data['id'],
      });
    }

    return pokemonWithImages;
  } catch (error) {
    // Handle error
  }
  return [];
}

Future<Map<String, dynamic>> fetchPokemonDetails(String pokemon) async {
  try {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemon'));
    return json.decode(response.body);
  } catch (error) {
    // Handle error
  }
  return {};
}

Future<Map<String, dynamic>> fetchRandomCharacterDetails() async {
  try {
    int randomNumber = Random().nextInt(19);
    final response = await http.get(
        Uri.parse('https://dragonball-api.com/api/characters/$randomNumber'));
    return json.decode(response.body);
  } catch (error) {
    // Handle error
  }

  return {};
}
