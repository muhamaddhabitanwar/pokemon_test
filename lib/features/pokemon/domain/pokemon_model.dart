import 'dart:convert';

PokemonModel pokemonModelFromJson(String str) => PokemonModel.fromJson(json.decode(str));

String pokemonModelToJson(PokemonModel data) => json.encode(data.toJson());

class PokemonModel {
    int? count;
    String? next;
    String? previous;
    List<PokemonList>? results;

    PokemonModel({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory PokemonModel.fromJson(Map<String, dynamic> json) => PokemonModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<PokemonList>.from(json["results"]!.map((x) => PokemonList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class PokemonList {
    String? name;
    String? url;

    PokemonList({
        this.name,
        this.url,
    });

    factory PokemonList.fromJson(Map<String, dynamic> json) => PokemonList(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}
