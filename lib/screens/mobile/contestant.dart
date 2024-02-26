import 'dart:convert';
import 'package:elecpress/screens/desktop/desk_election.dart';

class Contestant {
  String name;
  String gender;
  int votes;
  String imageUrl;
  Election? election; // Include Election property

  Contestant(
    this.name,
    this.gender,
    this.votes, {
    this.imageUrl = '',
    this.election, // Initialize election
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'votes': votes,
      'imageUrl': imageUrl,
      'election': election != null
          ? election!.toJson()
          : null, // Include election in the map
    };
  }

  factory Contestant.fromMap(Map<String, dynamic> map) {
    return Contestant(
      map['name'],
      map['gender'],
      map['votes'],
      imageUrl: map['imageUrl'],
      election: map['election'] != null
          ? Election.fromMap(map['election'])
          : null, // Initialize election from map
    );
  }

  String toJson() => json.encode(toMap());

  factory Contestant.fromJson(String source) =>
      Contestant.fromMap(json.decode(source));
}
