import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_dio/core/api_client.dart';
import 'package:pokemon_dio/repository/pokemon_repository.dart';
import 'package:pokemon_dio/ui/pokemon_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient().fetchApi();
  final dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2'));
  await PokemonRepository(dio: dio).getPokemonList(5,0);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PokemonListScreen());
  }
}
