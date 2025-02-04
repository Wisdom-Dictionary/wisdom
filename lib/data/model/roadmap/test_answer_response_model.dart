// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wisdom/data/model/roadmap/test_answer_model.dart';

class LevelExerciseResultModel {
  final int? levelExerciseId;
  final bool? pass;
  final int? star;
  final int? totalQuestions;
  final int? correctAnswers;
  final int? testDuration;
  final int? optimalTime;
  final int? timeTaken;
  final List<TestAnswerModel> answers;

  LevelExerciseResultModel({
    this.levelExerciseId,
    this.pass,
    this.star,
    this.totalQuestions,
    this.correctAnswers,
    this.testDuration,
    this.optimalTime,
    this.timeTaken,
    this.answers = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'levelExerciseId': levelExerciseId,
      'pass': pass,
      'star': star,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'testDuration': testDuration,
      'optimalTime': optimalTime,
      'timeTaken': timeTaken,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  factory LevelExerciseResultModel.fromMap(Map<String, dynamic> map) {
    return LevelExerciseResultModel(
      levelExerciseId: map['level_exercise_id'] != null
          ? map['level_exercise_id'] as int
          : null,
      pass: map['pass'] != null ? map['pass'] as bool : null,
      star: map['star'] != null ? map['star'] as int : null,
      totalQuestions:
          map['total_questions'] != null ? map['total_questions'] as int : null,
      correctAnswers:
          map['correct_answers'] != null ? map['correct_answers'] as int : null,
      testDuration:
          map['test_duration'] != null ? map['test_duration'] as int : null,
      optimalTime:
          map['optimal_time'] != null ? map['optimal_time'] as int : null,
      timeTaken: map['time_taken'] != null ? map['time_taken'] as int : null,
      answers: List<TestAnswerModel>.from(
        (map['answers'] as List).map<TestAnswerModel>(
          (x) => TestAnswerModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LevelExerciseResultModel.fromJson(String source) =>
      LevelExerciseResultModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
