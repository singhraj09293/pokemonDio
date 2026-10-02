import 'package:dio/dio.dart';
import 'package:pokemon_dio/models/pokemon.dart';
import 'package:pokemon_dio/models/pokemon_detail.dart';

class PokemonRepository {
  final Dio dio;

  PokemonRepository({required this.dio});

  Future<List<Pokemon>> getPokemonList(int limit, int offset) async {
    final response = await dio.get(
      '/pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final result = response.data['results'];
    final List<Pokemon> pokemons = [];
    for (final items in result) {
      final String name = items['name'];
      final String url = items['url'];
      final parts = url.split('/');
      final int id = int.parse(parts[parts.length - 2]);
      final String image =
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
      pokemons.add(Pokemon(id: id, name: name, image: image));
    }
    return pokemons;
  }

  Future<PokemonDetail> getPokemonDetail(int id) async {
    final response = await dio.get('/pokemon/$id');
    return PokemonDetail.fromMap(response.data);  //PokemonDetail.fromMap(response.data) store the reponse.data only what pokemonDetail wants
  }
}
