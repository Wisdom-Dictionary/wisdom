// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TestAnswerModel {
  int questionId;
  bool isCorrect;

  TestAnswerModel({
    required this.questionId,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': questionId,
      'isCorrect': isCorrect,
    };
  }

  factory TestAnswerModel.fromMap(Map<String, dynamic> map) {
    return TestAnswerModel(
      questionId: map['question_id'] as int,
      isCorrect: map['is_correct'] != null ? map['is_correct'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestAnswerModel.fromJson(String source) =>
      TestAnswerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
