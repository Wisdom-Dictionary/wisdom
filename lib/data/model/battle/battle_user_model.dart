// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wisdom/data/model/roadmap/rank_model.dart';

class BattleUserModel {
  final int? id;
  final String? name;
  final int? level;
  final bool? isPremium;
  final RankModel? rank;

  BattleUserModel({
    this.id,
    this.name,
    this.level,
    this.isPremium,
    this.rank,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'level': level,
      'isPremium': isPremium,
      'rank': rank?.toMap(),
    };
  }

  bool get isPremuimStatus => isPremium ?? false;

  factory BattleUserModel.fromMap(Map<String, dynamic> map) {
    return BattleUserModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null
          ? map['level'] as int
          : map['current_level'] != null
              ? map['current_level'] as int
              : null,
      isPremium: map['is_premium'] != null ? _parseBool(map['is_premium']) : null,
      rank: map['rank'] != null ? RankModel.fromJson(map['rank'] as Map<String, dynamic>) : null,
    );
  }

  /// `is_premium` ni har xil formatda kelishiga moslash
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1; // Agar int bo'lsa, 1 -> true, 0 -> false
    return false; // Agar noma'lum format bo'lsa, default false
  }

  String toJson() => json.encode(toMap());

  factory BattleUserModel.fromJson(String source) =>
      BattleUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
