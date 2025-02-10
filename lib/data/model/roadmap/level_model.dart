// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// {
//             "id": 1,
//             "name": "20",
//             "star": 3,
//             "status": "published",
//             "position": 1
//         }

class LevelModel {
  int? id;
  String? name;
  int? star;
  String? type;
  int? position;
  bool? userCurrentLevel;

  LevelModel({
    this.id,
    this.name,
    this.star,
    this.type,
    this.position,
    this.userCurrentLevel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'star': star,
      'status': type,
      'position': position,
      'userLevel': userCurrentLevel,
    };
  }

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      star: map['star'] != null ? map['star'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      position: map['position'] != null ? map['position'] as int : null,
      userCurrentLevel:
          map['user_current_level'] != null ? map['user_current_level'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LevelModel.fromJson(String source) =>
      LevelModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
