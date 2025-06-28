import 'package:wisdom/data/model/battle/battle_user_model.dart';

class BattleResultModel {
  BattleResultModel({
    this.user1,
    this.user2,
    this.winnerId,
    this.user1GainedStars,
    this.user2GainedStars,
    this.totalQuestions,
    this.battleDuration,
    this.user1CorrectAnswers,
    this.user2CorrectAnswers,
    this.user1SpentTime,
    this.user2SpentTime,
    this.draw,
    this.result = const [],
  });

  final BattleUserModel? user1;
  static const String user1Key = "user1";

  final BattleUserModel? user2;
  static const String user2Key = "user2";

  final int? winnerId;
  static const String winnerIdKey = "winnerId";

  final int? user1GainedStars;
  static const String user1GainedStarsKey = "user1_gained_stars";

  final int? user2GainedStars;
  static const String user2GainedStarsKey = "user2_gained_stars";

  final int? totalQuestions;
  static const String totalQuestionsKey = "total_questions";

  final int? battleDuration;
  static const String battleDurationKey = "battle_duration";

  final int? user1CorrectAnswers;
  static const String user1CorrectAnswersKey = "user1_correct_answers";

  final int? user2CorrectAnswers;
  static const String user2CorrectAnswersKey = "user2_correct_answers";

  final int? user1SpentTime;
  static const String user1SpentTimeKey = "user1_spent_time";

  final int? user2SpentTime;
  static const String user2SpentTimeKey = "user2_spent_time";

  final bool? draw;
  static const String drawKey = "draw";

  final List<BattleExerciseResultModel> result;
  static const String resultKey = "result";

  factory BattleResultModel.fromJson(Map<String, dynamic> json) {
    return BattleResultModel(
      user1: json["user1"] == null ? null : BattleUserModel.fromMap(json["user1"]),
      user2: json["user2"] == null ? null : BattleUserModel.fromMap(json["user2"]),
      winnerId: json["winnerId"],
      user1GainedStars: json["user1_gained_stars"],
      user2GainedStars: json["user2_gained_stars"],
      totalQuestions: json["total_questions"],
      battleDuration: json["battle_duration"],
      user1CorrectAnswers: json["user1_correct_answers"],
      user2CorrectAnswers: json["user2_correct_answers"],
      user1SpentTime: json["user1_spent_time"],
      user2SpentTime: json["user2_spent_time"],
      draw: json["draw"],
      result: json["result"] == null
          ? []
          : List<BattleExerciseResultModel>.from(
              json["result"]!.map((x) => BattleExerciseResultModel.fromJson(x))),
    );
  }
}

class BattleExerciseResultModel {
  BattleExerciseResultModel({
    required this.word,
    required this.user1IsCorrect,
    required this.user2IsCorrect,
  });

  final String? word;
  static const String wordKey = "word";

  final bool? user1IsCorrect;
  static const String user1IsCorrectKey = "user1_is_correct";

  final bool? user2IsCorrect;
  static const String user2IsCorrectKey = "user2_is_correct";

  factory BattleExerciseResultModel.fromJson(Map<String, dynamic> json) {
    return BattleExerciseResultModel(
      word: json["word"],
      user1IsCorrect: json["user1_is_correct"],
      user2IsCorrect: json["user2_is_correct"],
    );
  }
}
