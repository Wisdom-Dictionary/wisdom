import 'package:wisdom/config/constants/urls.dart';

class RankingModel {
  RankingModel({
    this.userId,
    this.ranking,
    this.rankIcon,
    this.name,
    this.level,
    this.you,
  });

  final int? userId;

  final int? ranking;
  static const String rankingKey = "ranking";

  final String? rankIcon;
  static const String rankIconKey = "rank_icon";

  final String? name;
  static const String nameKey = "name";

  final int? level;
  static const String levelKey = "level";

  final bool? you;
  static const String youKey = "you";

  String get rankIconUrl {
    if (rankIcon == null) {
      return "";
    }
    return "${Urls.baseUrl}${rankIcon ?? ""}";
  }

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      userId: json["user_id"],
      ranking: json["ranking"],
      rankIcon: json["rank_icon"],
      name: json["name"],
      level: json["level"],
      you: json["you"],
    );
  }
}
