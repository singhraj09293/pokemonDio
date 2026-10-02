import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_dio/models/pokemon.dart';
import 'package:pokemon_dio/repository/pokemon_repository.dart';
import 'package:pokemon_dio/ui/pokemon_detail_screen.dart';

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
  bool hasMore = true;
  List<Pokemon> allPokemon = [];
  TextEditingController search = TextEditingController();
  final ScrollController controller = ScrollController();

  List<Pokemon> get filtered => search.text.isEmpty
      ? pokemon
      : allPokemon
            .where(
              (e) => e.name.toLowerCase().startsWith(
                search.text.trim().toLowerCase(),
              ),
            )
            .toList();
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
    loadAll();
  }

  @override
  void dispose() {
    controller.dispose();
    search.dispose();
    super.dispose();
  }

  Future<void> loadAll() async {
    try {
      final result = await widget.repository.getPokemonList(1400, 0);
      setState(() {
        allPokemon = result;
      });
    } on DioException catch (e) {
      setState(() {
        error = e.message ?? 'Something wrong';
      });
    }
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
    if (isLoadingMore || !hasMore) return;
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
        if (result.length < 20) {
          hasMore = false;
        }
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: Text('Oops an Error $error'))],
          ),
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: search,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search Pokemon`',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: filtered.length,
                  itemBuilder: ((context, index) {
                    final pok = filtered[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(pok.image),
                        title: Text(pok.name),
                        trailing: Text(pok.id.toString()),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PokemonDetailScreen(
                              repository: widget.repository,
                              id: pok.id,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
