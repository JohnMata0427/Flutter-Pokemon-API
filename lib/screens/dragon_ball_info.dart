import 'package:flutter/material.dart';
import 'package:apiconsumption/services/apis.dart'
    show fetchRandomCharacterDetails;

class DragonBallRandomCharacter extends StatefulWidget {
  const DragonBallRandomCharacter({super.key});

  @override
  State<DragonBallRandomCharacter> createState() =>
      _DragonBallRandomCharacterState();
}

class _DragonBallRandomCharacterState extends State<DragonBallRandomCharacter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Personaje Aleatorio de Dragon Ball',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.orange,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchRandomCharacterDetails(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(
                        'Error al cargar los detalles del personaje');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child:
                            Text('No se encontraron detalles del personaje'));
                  } else {
                    final characterDetails = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(characterDetails['image']),
                        const SizedBox(height: 10),
                        Text('Nombre: ${characterDetails['name']}'),
                        const SizedBox(height: 10),
                        Text(
                          'Ki: ${characterDetails['ki']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Descripción: ${characterDetails['description']}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Planeta de origen: ${characterDetails['originPlanet']['name']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        // Otros detalles del personaje
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
