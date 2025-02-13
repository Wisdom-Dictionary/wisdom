import 'dart:convert';

import 'package:wisdom/data/model/base_table_model.dart';

/// id : 1
/// word : ""
/// phrase_id : 1

PhrasesTranslateTableModel phrasesTranslateTableModelFromJson(String str) =>
    PhrasesTranslateTableModel.fromJson(json.decode(str));

String phrasesTranslateTableModelToJson(PhrasesTranslateTableModel data) => json.encode(data.toJson());

class PhrasesTranslateTableModel extends BaseTableModel {
  PhrasesTranslateTableModel({
    int? id,
    String? word,
    int? phraseId,
  }) {
    _id = id;
    _word = word;
    _phraseId = phraseId;
  }

  PhrasesTranslateTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _word = json['word'];
    _phraseId = json['phrase_id'];
  }

  int? _id;
  String? _word;
  int? _phraseId;

  PhrasesTranslateTableModel copyWith({
    int? id,
    String? word,
    int? phraseId,
  }) =>
      PhrasesTranslateTableModel(
        id: id ?? _id,
        word: word ?? _word,
        phraseId: phraseId ?? _phraseId,
      );

  int? get id => _id;

  String? get word => _word;

  int? get phraseId => _phraseId;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word'] = _word;
    map['phrase_id'] = _phraseId;
    return map;
  }
}
