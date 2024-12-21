import 'package:flutter/material.dart';
import 'package:apiconsumption/screens/pokemon_info.dart' show PokemonDetails;
import 'package:apiconsumption/services/apis.dart' show fetchPokemon;

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  String pokemon = '';
  int offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokémon',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text('Buscar Pokémon'),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nombre o Posición en la Pokedex del Pokémon',
                    ),
                    onChanged: (value) {
                      pokemon = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchPokemon(name: pokemon, offset: offset),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error al cargar los detalles'));
                  } else if (snapshot.hasData) {
                    final pokemonList = snapshot.data!;
                    return ListView.builder(
                      itemCount: pokemonList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(pokemonList[index]['image']),
                          title: Text(
                              pokemonList[index]['name'][0].toUpperCase() +
                                  pokemonList[index]['name'].substring(1)),
                          subtitle:
                              Text('Pokémon #${pokemonList[index]['id']}'),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PokemonDetails(
                                    name: pokemonList[index]['name'],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.read_more),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No se encontro ningún Pokémon'));
                  }
                }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              offset > 0
                  ? IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        setState(() {
                          offset -= 25;
                        });
                      },
                      icon: const Icon(Icons.navigate_before),
                      color: Colors.white,
                    )
                  : const SizedBox(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/dragonball');
                  },
                  icon: const Icon(Icons.auto_stories_sharp),
                  color: Colors.red),
              offset < 1025
                  ? IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        setState(() {
                          offset += 25;
                        });
                      },
                      icon: const Icon(Icons.navigate_next),
                      color: Colors.white,
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
