// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//        {
//             "id": 14,
//             "body": "a+b",
//             "position": 0,
//             "answers": [
//                 {
//                     "id": 35,
//                     "body": "as"
//                 },
//                 {
//                     "id": 36,
//                     "body": "ab"
//                 }
//             ]
//         }

class TestQuestionModel {
  int? id;
  String? body;
  int? position;
  List<AnswerModel>? answers;

  TestQuestionModel({
    this.id,
    this.body,
    this.position,
    this.answers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'body': body,
      'position': position,
      'answers': answers?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory TestQuestionModel.fromMap(Map<String, dynamic> map) {
    return TestQuestionModel(
      id: map['id'] != null ? map['id'] as int : null,
      body: map['body'] != null ? map['body'] as String : null,
      position: map['position'] != null ? map['position'] as int : null,
      answers: map['answers'] != null
          ? List<AnswerModel>.from(
              (map['answers'] as List).map<AnswerModel?>(
                (x) => AnswerModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestQuestionModel.fromJson(String source) =>
      TestQuestionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AnswerModel {
  int? id;
  String? body;
  bool correct;
  bool selected;

  AnswerModel({
    this.id,
    this.body,
    this.correct = false,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'body': body,
      'correct': correct,
      'selected': selected,
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      id: map['id'] != null ? map['id'] as int : null,
      body: map['body'] != null ? map['body'] as String : null,
      selected: map['selected'] != null ? map['selected'] as bool : false,
      correct: map['correct'] != null ? map['correct'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromJson(String source) =>
      AnswerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
