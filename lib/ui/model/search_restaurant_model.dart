import 'dart:convert';

class SearchRestaurant {
  bool error;
  int founded;
  List<Restaurantsearch> restaurants;

  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchRestaurant.fromRawJson(String str) =>
      SearchRestaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) =>
      SearchRestaurant(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurantsearch>.from(
            json["restaurants"].map((x) => Restaurantsearch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class Restaurantsearch {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Restaurantsearch({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurantsearch.fromRawJson(String str) =>
      Restaurantsearch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurantsearch.fromJson(Map<String, dynamic> json) =>
      Restaurantsearch(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
