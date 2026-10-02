// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PokemonDetail {
  final String name;
  final int height;
  final int weight;
  final int id;
  final List<String> types;

  PokemonDetail({
    required this.name,
    required this.height,
    required this.weight,
    required this.id,
    required this.types,
  });

  PokemonDetail copyWith({
    String? name,
    int? height,
    int? weight,
    int? id,
    List<String>? types,
  }) {
    return PokemonDetail(
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      id: id ?? this.id,
      types: types ?? this.types,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'height': height,
      'weight': weight,
      'id': id,
      'types': types,
    };
  }

  factory PokemonDetail.fromMap(Map<String, dynamic> map) {
    return PokemonDetail(
      name: map['name'] as String,
      height: map['height'] as int,
      weight: map['weight'] as int,
      id: map['id'] as int,
      types: (map['types'] as List)
          .map((items) => items['type']['name'] as String)
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonDetail.fromJson(String source) =>
      PokemonDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PokemonDetail(name: $name, height: $height, weight: $weight, id: $id, types: $types)';
  }

  @override
  bool operator ==(covariant PokemonDetail other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.height == height &&
        other.weight == weight &&
        other.id == id &&
        listEquals(other.types, types);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        height.hashCode ^
        weight.hashCode ^
        id.hashCode ^
        types.hashCode;
  }
}
