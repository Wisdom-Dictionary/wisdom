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
  String? status;
  int? position;
  bool? userLevel;

  LevelModel({
    this.id,
    this.name,
    this.star,
    this.status,
    this.position,
    this.userLevel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'star': star,
      'status': status,
      'position': position,
      'userLevel': userLevel,
    };
  }

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      star: map['star'] != null ? map['star'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      position: map['position'] != null ? map['position'] as int : null,
      userLevel: map['user_level'] != null ? map['user_level'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LevelModel.fromJson(String source) =>
      LevelModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
