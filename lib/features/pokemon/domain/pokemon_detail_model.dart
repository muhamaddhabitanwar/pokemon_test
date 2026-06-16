import 'dart:convert';

PokemonDetailModel pokemonDetailModelFromJson(String str) => PokemonDetailModel.fromJson(json.decode(str));

String pokemonDetailModelToJson(PokemonDetailModel data) => json.encode(data.toJson());

class PokemonDetailModel {
    Firmness? firmness;
    List<Flavor>? flavors;
    int? growthTime;
    int? id;
    Firmness? item;
    int? maxHarvest;
    String? name;
    int? naturalGiftPower;
    Firmness? naturalGiftType;
    int? size;
    int? smoothness;
    int? soilDryness;

    PokemonDetailModel({
        this.firmness,
        this.flavors,
        this.growthTime,
        this.id,
        this.item,
        this.maxHarvest,
        this.name,
        this.naturalGiftPower,
        this.naturalGiftType,
        this.size,
        this.smoothness,
        this.soilDryness,
    });

    factory PokemonDetailModel.fromJson(Map<String, dynamic> json) => PokemonDetailModel(
        firmness: json["firmness"] == null ? null : Firmness.fromJson(json["firmness"]),
        flavors: json["flavors"] == null ? [] : List<Flavor>.from(json["flavors"]!.map((x) => Flavor.fromJson(x))),
        growthTime: json["growth_time"],
        id: json["id"],
        item: json["item"] == null ? null : Firmness.fromJson(json["item"]),
        maxHarvest: json["max_harvest"],
        name: json["name"],
        naturalGiftPower: json["natural_gift_power"],
        naturalGiftType: json["natural_gift_type"] == null ? null : Firmness.fromJson(json["natural_gift_type"]),
        size: json["size"],
        smoothness: json["smoothness"],
        soilDryness: json["soil_dryness"],
    );

    Map<String, dynamic> toJson() => {
        "firmness": firmness?.toJson(),
        "flavors": flavors == null ? [] : List<dynamic>.from(flavors!.map((x) => x.toJson())),
        "growth_time": growthTime,
        "id": id,
        "item": item?.toJson(),
        "max_harvest": maxHarvest,
        "name": name,
        "natural_gift_power": naturalGiftPower,
        "natural_gift_type": naturalGiftType?.toJson(),
        "size": size,
        "smoothness": smoothness,
        "soil_dryness": soilDryness,
    };
}

class Firmness {
    String? name;
    String? url;

    Firmness({
        this.name,
        this.url,
    });

    factory Firmness.fromJson(Map<String, dynamic> json) => Firmness(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}

class Flavor {
    Firmness? flavor;
    int? potency;

    Flavor({
        this.flavor,
        this.potency,
    });

    factory Flavor.fromJson(Map<String, dynamic> json) => Flavor(
        flavor: json["flavor"] == null ? null : Firmness.fromJson(json["flavor"]),
        potency: json["potency"],
    );

    Map<String, dynamic> toJson() => {
        "flavor": flavor?.toJson(),
        "potency": potency,
    };
}
