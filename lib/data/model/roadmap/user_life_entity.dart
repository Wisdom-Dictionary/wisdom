// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// {
//     "lives": 2,
//     "max_lives": 3,
//     "recovery_time_datetime": "2025-01-28 22:28:05"
// }

class UserLifeModel {
  int? lives;
  int? maxLives;
  String? recoveryTimeDatetime;

  UserLifeModel({
    this.lives,
    this.maxLives,
    this.recoveryTimeDatetime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lives': lives,
      'maxLives': maxLives,
      'recoveryTimeDatetime': recoveryTimeDatetime,
    };
  }

  factory UserLifeModel.fromMap(Map<String, dynamic> map) {
    return UserLifeModel(
      lives: map['lives'] != null ? map['lives'] as int : null,
      maxLives: map['max_lives'] != null ? map['max_lives'] as int : null,
      recoveryTimeDatetime:
          map['recovery_time_datetime'] != null ? map['recovery_time_datetime'] as String : null,
    );
  }
}
