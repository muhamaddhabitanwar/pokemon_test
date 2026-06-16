import 'dart:convert';

import 'package:http/http.dart' as http;

class PokemonRepository {
  final client = http.Client();
  static const String _baseUrl = 'https://pokeapi.co/api/v2/berry/';

  Future<Map<String, dynamic>?> fetchPokemon(int offset, int limit) async {
    final response = await client.get(
      Uri.parse('$_baseUrl?offset=$offset&limit=$limit'),
    );

    try {
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Gagal memuat data pokemon: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchPokemonDetail(String url) async {
    final response = await client.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Gagal memuat detail pokemon: $e');
    }
  }
}
