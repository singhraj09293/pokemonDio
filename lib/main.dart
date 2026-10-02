import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_dio/core/api_client.dart';
import 'package:pokemon_dio/repository/pokemon_repository.dart';
import 'package:pokemon_dio/ui/pokemon_list_screen.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2'));
  final repository = PokemonRepository(dio: dio);
  print(await PokemonRepository(dio: dio).getPokemonDetail(6));
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final PokemonRepository repository;
  const MyApp({super.key, required this.repository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PokemonListScreen(repository: repository),
    );
  }
}
