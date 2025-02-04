// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// {
//     "id": 599,
//     "position": 1,
//     "word_id": 52,
//     "word": "A",
//     "word_class": "noun",
//     "is_learnt": false
// },

class LevelWordModel {
  int? id;
  int? wordId;
  int? position;
  String? word;
  String? wordClass;
  bool? isLearnt;

  LevelWordModel({
    this.id,
    this.wordId,
    this.position,
    this.word,
    this.wordClass,
    this.isLearnt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'wordId': wordId,
      'position': position,
      'word': word,
      'wordClass': wordClass,
      'isLearnt': isLearnt,
    };
  }

  factory LevelWordModel.fromMap(Map<String, dynamic> map) {
    return LevelWordModel(
      id: map['id'] != null ? map['id'] as int : null,
      wordId: map['word_id'] != null ? map['word_id'] as int : null,
      position: map['position'] != null ? map['position'] as int : null,
      word: map['word'] != null ? map['word'] as String : null,
      wordClass: map['word_class'] != null ? map['word_class'] as String : null,
      isLearnt: map['is_learnt'] != null ? map['is_learnt'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LevelWordModel.fromJson(String source) =>
      LevelWordModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
