import 'dart:convert';

class Contestant {
  String name;
  String gender;
  int votes;
  String imageUrl;
  String electionName;

  Contestant({
    required this.name,
    required this.gender,
    required this.votes,
    required this.imageUrl,
    required this.electionName,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'votes': votes,
      'imageUrl': imageUrl,
      'electionName': electionName,
    };
  }

  factory Contestant.fromMap(Map<String, dynamic> map) {
    return Contestant(
      name: map['name'],
      gender: map['gender'],
      votes: map['votes'],
      imageUrl: map['imageUrl'],
      electionName: map['electionName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contestant.fromJson(String source) =>
      Contestant.fromMap(json.decode(source));
}
