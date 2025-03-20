// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailsModel _$UserDetailsModelFromJson(Map<String, dynamic> json) => UserDetailsModel(
      status: json['status'] as bool?,
      followed: json['followed'] as bool?,
      following: json['following'] as bool?,
      userCurrentLevel: (json['user_current_level'] as num?)?.toInt(),
      user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
      tariff:
          json['tariff'] == null ? null : Tariff.fromJson(json['tariff'] as Map<String, dynamic>),
      statistics: json['statistics'] == null
          ? null
          : Statistics.fromJson(json['statistics'] as Map<String, dynamic>),
      rank: json['rank'] == null ? null : RankModel.fromJson(json['rank'] as Map<String, dynamic>),
    );

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      threeStarWins: (json['three_star_wins'] as num?)?.toInt(),
      userStars: (json['user_stars'] as num?)?.toInt(),
      winRate: (json['win_rate'] as num?)?.toInt(),
      gameAccuracy: (json['game_accuracy'] as num?)?.toInt(),
      averageTime: (json['average_time'] as num?)?.toInt(),
      bestTime: (json['best_time'] as num?)?.toInt(),
      dailyRecord: (json['daily_record'] as num?)?.toInt(),
      weeklyRecord: (json['weekly_record'] as num?)?.toInt(),
      monthlyRecord: (json['monthly_record'] as num?)?.toInt(),
    );

Tariff _$TariffFromJson(Map<String, dynamic> json) => Tariff(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] == null ? null : Name.fromJson(json['name'] as Map<String, dynamic>),
      days: (json['days'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      deletedAt: json['deleted_at'],
    );

Name _$NameFromJson(Map<String, dynamic> json) => Name(
      uz: json['uz'] as String?,
      en: json['en'] as String?,
    );

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      phone: (json['phone'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'],
      image: json['image'],
      birthdate: json['birthdate'],
      isPremium: json['is_premium'],
      isOnline: json['is_online'],
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.none,
      notification: (json['notification'] as num?)?.toInt(),
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );

const _$GenderEnumMap = {
  Gender.M: 'M',
  Gender.F: 'F',
  Gender.none: 'none',
};
