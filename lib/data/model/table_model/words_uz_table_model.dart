import 'dart:convert';

import 'package:wisdom/data/model/base_table_model.dart';

/// id : 1
/// word_id : 1
/// word : ""

WordsUzTableModel wordsUzTableModelFromJson(String str) =>
    WordsUzTableModel.fromJson(json.decode(str));

String wordsUzTableModelToJson(WordsUzTableModel data) => json.encode(data.toJson());

class WordsUzTableModel extends BaseTableModel {
  WordsUzTableModel({
    int? id,
    int? wordId,
    String? word,
  }) {
    _id = id;
    _wordId = wordId;
    _word = word;
  }

  WordsUzTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordId = json['word_id'];
    _word = json['word'];
  }

  int? _id;
  int? _wordId;
  String? _word;

  WordsUzTableModel copyWith({
    int? id,
    int? wordId,
    String? word,
  }) =>
      WordsUzTableModel(
        id: id ?? _id,
        wordId: wordId ?? _wordId,
        word: word ?? _word,
      );

  int? get id => _id;

  int? get wordId => _wordId;

  String? get word => _word;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_id'] = _wordId;
    map['word'] = _word;
    return map;
  }
}
