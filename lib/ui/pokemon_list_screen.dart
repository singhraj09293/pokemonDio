import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_dio/models/pokemon.dart';
import 'package:pokemon_dio/repository/pokemon_repository.dart';

class PokemonListScreen extends StatefulWidget {
  final PokemonRepository repository;
  const PokemonListScreen({super.key, required this.repository});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  bool isLoading = true;
  String? error;
  List<Pokemon> pokemon = [];
  int offset = 0;
  bool isLoadingMore = false;
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadPokemons();
    controller.addListener(() {
      if (controller.position.maxScrollExtent - controller.position.pixels <
          100) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadPokemons() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final result = await widget.repository.getPokemonList(20, offset);
      setState(() {
        pokemon = result;
        offset += 20;
      });
      print('offset is $offset');
    } on DioException catch (e) {
      setState(() {
        error = e.message ?? 'Something wrong';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    setState(() {
      isLoading = false;
      error = null;
    });
    try {
      final result = await widget.repository.getPokemonList(20, offset);
      setState(() {
        pokemon.addAll(result);
        offset += 20;
      });
    } on DioException catch (e) {
      setState(() {
        error = e.message ?? 'Something wrong';
      });
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: CircularProgressIndicator())],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            _loadPokemons();
          },
        ),
      );
    } else if (error != null) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: Text('Oops an Error $error'))],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            _loadPokemons();
          },
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: pokemon.length,
                itemBuilder: ((context, index) {
                  final pok = pokemon[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(pok.image),
                      title: Text(pok.name),
                      trailing: Text(pok.id.toString()),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    }
  }
}
