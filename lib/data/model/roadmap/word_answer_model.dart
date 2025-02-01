// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WordAnswerModel {
  int id;
  int questionId;
  int selectedAnswerId;
  int correctAnswerId;
  bool isCorrect;

  WordAnswerModel({
    required this.id,
    required this.questionId,
    required this.selectedAnswerId,
    required this.correctAnswerId,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'questionId': questionId,
      'selectedAnswerId': selectedAnswerId,
      'correctAnswerId': correctAnswerId,
      'isCorrect': isCorrect,
    };
  }

  factory WordAnswerModel.fromMap(Map<String, dynamic> map) {
    return WordAnswerModel(
      id: map['id'] as int,
      questionId: map['question_id'] as int,
      selectedAnswerId: map['selected_answer_id'] as int,
      correctAnswerId: map['correct_answer_id'] as int,
      isCorrect: map['is_correct'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory WordAnswerModel.fromJson(String source) =>
      WordAnswerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
