import 'package:flutter/material.dart';
import 'package:apiconsumption/screens/pokemon_list.dart';
import 'package:apiconsumption/screens/dragon_ball_info.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PokemonList(),
      routes: {
        '/pokemon': (context) => const PokemonList(),
        '/dragonball': (context) => const DragonBallRandomCharacter(),
      },
    );
  }
}
