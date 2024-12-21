import 'package:flutter/material.dart';
import 'package:apiconsumption/services/apis.dart' show fetchPokemonDetails;

class PokemonDetails extends StatefulWidget {
  const PokemonDetails({super.key, required this.name});
  final String name;

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  Map<String, dynamic> _pokemonDetails = {};

  @override
  Widget build(BuildContext context) {
    final nameCapitalized =
        widget.name[0].toUpperCase() + widget.name.substring(1);
    return Scaffold(
      appBar: AppBar(
        title: Text(nameCapitalized,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: FutureBuilder(
            future: fetchPokemonDetails(widget.name),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error al cargar los detalles');
              } else if (snapshot.hasData) {
                _pokemonDetails = snapshot.data!;
                String types = '';
                for (var type in _pokemonDetails['types']) {
                  final typeString = type['type']['name'].toString();
                  types +=
                      '${typeString[0].toUpperCase()}${typeString.substring(1)} ';
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        _pokemonDetails['sprites']['other']['official-artwork']
                            ['front_default'],
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nombre: $nameCapitalized',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tipos: ${types.trim()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Altura: ${_pokemonDetails['height'] / 10}m',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Peso: ${_pokemonDetails['weight'] / 10}kg',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Column(
                            children: [
                              ..._pokemonDetails['stats'].map((stat) {
                                return Text(
                                  'Estadistica: ${stat['stat']['name']} - ${stat['base_stat']}',
                                  style: const TextStyle(fontSize: 16),
                                );
                              })
                            ],
                          ))
                    ],
                  ),
                );
              } else {
                return const Text('No se encontro al Pokémon');
              }
            }),
      ),
    );
  }
}
