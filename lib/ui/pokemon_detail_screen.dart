import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_dio/models/pokemon_detail.dart';
import 'package:pokemon_dio/repository/pokemon_repository.dart';

class PokemonDetailScreen extends StatefulWidget {
  final PokemonRepository repository;
  final int id;
  const PokemonDetailScreen({
    super.key,
    required this.repository,
    required this.id,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  PokemonDetail? detail;
  bool isLoading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      final result = await widget.repository.getPokemonDetail(widget.id);
      setState(() {
        detail = result;
      });
    } on DioException catch (e) {
      setState(() {
        error = e.message ?? 'Somethings Wrong $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (error != null) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: Text('Oops an Error $error'))],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            loadDetails();
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            detail!.name,
            style: TextStyle(
              fontSize: 20,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${detail!.id}.png",
                height: 200,
              ),
              SizedBox(height: 10),
              Text(
                detail!.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(detail!.height.toString()),
              Text(detail!.weight.toString()),
              Text(detail!.types.join(', ')),
            ],
          ),
        ),
      );
    }
  }
}
