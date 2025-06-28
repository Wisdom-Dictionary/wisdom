// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/task_level_indicator_widget.dart';

// {
//             "id": 1,
//             "name": "20",
//             "star": 3,
//             "status": "published",
//             "position": 1
//         }
enum LevelType {
  level,
  test,
  battle,
  none,
}

class LevelModel {
  int? id;
  String? name;
  int? star;
  int? starsToUnlock;
  LevelType type;
  int? position;
  bool? userCurrentLevel;

  LevelModel({
    this.id,
    this.name,
    this.star,
    this.starsToUnlock,
    this.type = LevelType.none,
    this.position,
    this.userCurrentLevel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'star': star,
      'starsToUnlock': starsToUnlock,
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
      starsToUnlock: map['stars_to_unlock'] != null ? map['stars_to_unlock'] as int : null,
      type: map['type'] != null
          ? LevelType.values.firstWhere((element) => element.name == map['type'])
          : LevelType.none,
      position: map['position'] != null ? map['position'] as int : null,
      userCurrentLevel:
          map['user_current_level'] != null ? map['user_current_level'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LevelModel.fromJson(String source) =>
      LevelModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension LevelModelExtension on LevelModel {
  Widget get itemWidget => switch (type) {
        LevelType.level => LevelItem(
            item: this,
          ),
        LevelType.battle => BattleItem(
            item: this,
          ),
        LevelType.test => TestItem(
            item: this,
          ),
        LevelType.none => Center(),
      };
}

extension LevelTypeExtension on LevelType {
  // Color get backgroundColor {
  //   switch (this) {
  //     case ItemType.item:
  //       return Colors.blue;
  //     case ItemType.battle:
  //       return Colors.red;
  //     case ItemType.text:
  //       return Colors.green;
  //     case ItemType.level:
  //       return Colors.purple;
  //   }
  // }

  // BoxDecoration get decoration {
  //   switch (this) {
  //     case ItemType.item:
  //       return BoxDecoration(
  //         color: Colors.blue,
  //         borderRadius: BorderRadius.circular(8),
  //       );
  //     case ItemType.battle:
  //       return BoxDecoration(
  //         color: Colors.red,
  //         borderRadius: BorderRadius.circular(16),
  //       );
  //     case ItemType.text:
  //       return BoxDecoration(
  //         color: Colors.green,
  //         border: Border.all(color: Colors.black),
  //       );
  //     case ItemType.level:
  //       return BoxDecoration(
  //         gradient: LinearGradient(colors: [Colors.purple, Colors.orange]),
  //       );
  //   }
  // }
}
