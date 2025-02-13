import 'dart:convert';

import 'package:wisdom/data/model/base_table_model.dart';
/// id : 1
/// word : ""
/// phrase_id : 1
/// parent_phrase_id : 1

ParentPhrasesTranslateTableModel parentPhrasesTranslateTableModelFromJson(String str) => ParentPhrasesTranslateTableModel.fromJson(json.decode(str));
String parentPhrasesTranslateTableModelToJson(ParentPhrasesTranslateTableModel data) => json.encode(data.toJson());
class ParentPhrasesTranslateTableModel extends BaseTableModel{
  ParentPhrasesTranslateTableModel({
      int? id, 
      String? word, 
      int? phraseId, 
      int? parentPhraseId,}){
    _id = id;
    _word = word;
    _phraseId = phraseId;
    _parentPhraseId = parentPhraseId;
}

  ParentPhrasesTranslateTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _word = json['word'];
    _phraseId = json['phrase_id'];
    _parentPhraseId = json['parent_phrase_id'];
  }
  int? _id;
  String? _word;
  int? _phraseId;
  int? _parentPhraseId;
ParentPhrasesTranslateTableModel copyWith({  int? id,
  String? word,
  int? phraseId,
  int? parentPhraseId,
}) => ParentPhrasesTranslateTableModel(  id: id ?? _id,
  word: word ?? _word,
  phraseId: phraseId ?? _phraseId,
  parentPhraseId: parentPhraseId ?? _parentPhraseId,
);
  int? get id => _id;
  String? get word => _word;
  int? get phraseId => _phraseId;
  int? get parentPhraseId => _parentPhraseId;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word'] = _word;
    map['phrase_id'] = _phraseId;
    map['parent_phrase_id'] = _parentPhraseId;
    return map;
  }

}
