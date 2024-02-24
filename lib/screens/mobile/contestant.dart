import 'dart:convert';

class Contestant {
  String name;
  String gender;
  int votes;
  String imageUrl;

  Contestant(this.name, this.gender, this.votes, {this.imageUrl = ''});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'votes': votes,
      'imageUrl': imageUrl,
    };
  }

  factory Contestant.fromMap(Map<String, dynamic> map) {
    return Contestant(
      map['name'],
      map['gender'],
      map['votes'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contestant.fromJson(String source) =>
      Contestant.fromMap(json.decode(source));
}
