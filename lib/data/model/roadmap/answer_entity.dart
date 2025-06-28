// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AnswerEntity {
  int answerId;
  int questionId;

  AnswerEntity({
    required this.answerId,
    required this.questionId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'answer_id': answerId,
      'question_id': questionId,
    };
  }

  factory AnswerEntity.fromMap(Map<String, dynamic> map) {
    return AnswerEntity(
      answerId: map['answer_id'] as int,
      questionId: map['question_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerEntity.fromJson(String source) =>
      AnswerEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
