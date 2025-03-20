// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:wisdom/data/enums/gender.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';

part 'user_details_model.g.dart';
// {
//     "status": true,
//     "user_current_level": 0,
//     "user": {
//         "id": 1,
//         "phone": 997772233,
//         "name": "Jim Samuel",
//         "email": null,
//         "image": null,
//         "birthdate": null,
//         "gender": null,
//         "notification": 1,
//         "profile_photo_url": "https://ui-avatars.com/api/?name=J+S&color=7F9CF5&background=EBF4FF"
//     },
//     "tariff": {
//         "id": 1,
//         "name": {
//             "uz": "7 kunlik bepul",
//             "en": "Free 7 days trial"
//         },
//         "days": 7,
//         "price": 0,
//         "deleted_at": null
//     },
//     "statistics": {
//         "three_star_wins": 0,
//         "user_stars": 0,
//         "win_rate": 0,
//         "game_accuracy": 0,
//         "average_time": 0,
//         "best_time": 0,
//         "daily_record": 0,
//         "weekly_record": 0,
//         "monthly_record": 0
//     }
// }

@JsonSerializable(createToJson: false)
class UserDetailsModel {
  UserDetailsModel({
    this.status,
    this.followed,
    this.following,
    this.userCurrentLevel,
    this.user,
    this.tariff,
    this.statistics,
    this.rank,
  });

  final bool? status;

  final bool? followed;

  final bool? following;

  @JsonKey(name: 'user_current_level')
  final int? userCurrentLevel;

  final User? user;

  final Tariff? tariff;

  final Statistics? statistics;

  final RankModel? rank;

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => _$UserDetailsModelFromJson(json);

  bool get isPremuimStatus => user?.isPremium ?? false;

  bool get isOnlineStatus => user?.isOnline ?? false;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'followed': followed,
      'following': following,
      'userCurrentLevel': userCurrentLevel,
      'user': user?.toMap(),
      'tariff': tariff?.toMap(),
      'statistics': statistics?.toMap(),
      'rank': rank?.toMap(),
    };
  }
}

@JsonSerializable(createToJson: false)
class Statistics {
  Statistics({
    this.threeStarWins,
    this.userStars,
    this.winRate,
    this.gameAccuracy,
    this.averageTime,
    this.bestTime,
    this.dailyRecord,
    this.weeklyRecord,
    this.monthlyRecord,
  });

  @JsonKey(name: 'three_star_wins')
  final int? threeStarWins;
  static const String threeStarWinsKey = "three_star_wins";

  @JsonKey(name: 'user_stars')
  final int? userStars;
  static const String userStarsKey = "user_stars";

  @JsonKey(name: 'win_rate')
  final int? winRate;
  static const String winRateKey = "win_rate";

  @JsonKey(name: 'game_accuracy')
  final int? gameAccuracy;
  static const String gameAccuracyKey = "game_accuracy";

  @JsonKey(name: 'average_time')
  final int? averageTime;
  static const String averageTimeKey = "average_time";

  @JsonKey(name: 'best_time')
  final int? bestTime;
  static const String bestTimeKey = "best_time";

  @JsonKey(name: 'daily_record')
  final int? dailyRecord;
  static const String dailyRecordKey = "daily_record";

  @JsonKey(name: 'weekly_record')
  final int? weeklyRecord;
  static const String weeklyRecordKey = "weekly_record";

  @JsonKey(name: 'monthly_record')
  final int? monthlyRecord;
  static const String monthlyRecordKey = "monthly_record";

  factory Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'three_star_wins': threeStarWins,
      'user_stars': userStars,
      'win_rate': winRate,
      'game_accuracy': gameAccuracy,
      'average_time': averageTime,
      'best_time': bestTime,
      'daily_record': dailyRecord,
      'weekly_record': weeklyRecord,
      'monthly_record': monthlyRecord,
    };
  }
}

@JsonSerializable(createToJson: false)
class Tariff {
  Tariff({
    this.id,
    this.name,
    this.days,
    this.price,
    this.deletedAt,
  });

  final int? id;
  static const String idKey = "id";

  final Name? name;
  static const String nameKey = "name";

  final int? days;
  static const String daysKey = "days";

  final int? price;
  static const String priceKey = "price";

  @JsonKey(name: 'deleted_at')
  final dynamic deletedAt;
  static const String deletedAtKey = "deleted_at";

  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name?.toMap(),
      'days': days,
      'price': price,
      'deleted_at': deletedAt,
    };
  }
}

@JsonSerializable(createToJson: false)
class Name {
  Name({
    required this.uz,
    required this.en,
  });

  final String? uz;
  static const String uzKey = "uz";

  final String? en;
  static const String enKey = "en";

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uz': uz,
      'en': en,
    };
  }
}

@JsonSerializable(createToJson: false)
class User {
  User({
    this.id,
    this.phone,
    this.name,
    this.email,
    this.image,
    this.birthdate,
    this.isOnline,
    this.isPremium,
    this.gender = Gender.none,
    this.notification,
    this.profilePhotoUrl,
  });

  final int? id;
  static const String idKey = "id";

  final int? phone;
  static const String phoneKey = "phone";

  final String? name;
  static const String nameKey = "name";

  final dynamic email;
  static const String emailKey = "email";

  final dynamic image;
  static const String imageKey = "image";

  final dynamic birthdate;
  static const String birthdateKey = "birthdate";

  @JsonKey(name: 'is_online')
  final bool? isOnline;

  @JsonKey(name: 'is_premium')
  final bool? isPremium;

  final Gender gender;
  static const String genderKey = "gender";

  final int? notification;
  static const String notificationKey = "notification";

  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;
  static const String profilePhotoUrlKey = "profile_photo_url";

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'image': image,
      'birthdate': birthdate,
      'gender': gender.name,
      'notification': notification,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}
