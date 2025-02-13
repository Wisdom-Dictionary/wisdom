import 'dart:convert';

import '../base_table_model.dart';

/// p_id : 1
/// p_word_id : 1
/// p_word : ""
/// p_star : 1
/// p_synonyms : ""
/// p_word_class_comment : ""
/// p_parent_phrase : ""

PhrasesTableModel phrasesTableModelFromJson(String str) => PhrasesTableModel.fromJson(json.decode(str));

String phrasesTableModelToJson(PhrasesTableModel data) => json.encode(data.toJson());

class PhrasesTableModel extends BaseTableModel {
  PhrasesTableModel({
    int? pId,
    int? pWordId,
    String? pWord,
    int? pStar,
    String? pSynonyms,
    String? pWordClassComment,
    int? pParentPhrase,
  }) {
    _pId = pId;
    _pWordId = pWordId;
    _pWord = pWord;
    _pStar = pStar;
    _pSynonyms = pSynonyms;
    _pWordClassComment = pWordClassComment;
    _pParentPhrase = pParentPhrase;
  }

  PhrasesTableModel.fromJson(dynamic json) {
    _pId = json['p_id'];
    _pWordId = json['p_word_id'];
    _pWord = json['p_word'];
    _pStar = json['p_star'];
    _pSynonyms = json['p_synonyms'];
    _pWordClassComment = json['p_word_class_comment'];
    _pParentPhrase = json['p_parent_phrase'];
  }

  int? _pId;
  int? _pWordId;
  String? _pWord;
  int? _pStar;
  String? _pSynonyms;
  String? _pWordClassComment;
  int? _pParentPhrase;

  PhrasesTableModel copyWith({
    int? pId,
    int? pWordId,
    String? pWord,
    int? pStar,
    String? pSynonyms,
    String? pWordClassComment,
    int? pParentPhrase,
  }) =>
      PhrasesTableModel(
        pId: pId ?? _pId,
        pWordId: pWordId ?? _pWordId,
        pWord: pWord ?? _pWord,
        pStar: pStar ?? _pStar,
        pSynonyms: pSynonyms ?? _pSynonyms,
        pWordClassComment: pWordClassComment ?? _pWordClassComment,
        pParentPhrase: pParentPhrase ?? _pParentPhrase,
      );

  int? get pId => _pId;

  int? get pWordId => _pWordId;

  String? get pWord => _pWord;

  int? get pStar => _pStar;

  String? get pSynonyms => _pSynonyms;

  String? get pWordClassComment => _pWordClassComment;

  int? get pParentPhrase => _pParentPhrase;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['p_id'] = _pId;
    map['p_word_id'] = _pWordId;
    map['p_word'] = _pWord;
    map['p_star'] = _pStar;
    map['p_synonyms'] = _pSynonyms;
    map['p_word_class_comment'] = _pWordClassComment;
    map['p_parent_phrase'] = _pParentPhrase;
    return map;
  }
}
