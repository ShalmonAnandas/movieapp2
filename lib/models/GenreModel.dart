import 'dart:convert';

Genre genreModelFromJson(String str) => Genre.fromJson(json.decode(str));

String genreModelToJson(Genre data) => json.encode(data.toJson());

class Genre {
  int id;
  String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
