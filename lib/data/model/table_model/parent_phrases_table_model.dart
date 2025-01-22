import 'dart:convert';

import 'package:wisdom/data/model/base_table_model.dart';
/// id : 0
/// phrase_id : 0
/// word : ""
/// star : 0
/// synonyms : ""
/// word_class_comment : ""
/// parent_phrase : ""

ParentPhrasesTableModel parentPhrasesTableModelFromJson(String str) => ParentPhrasesTableModel.fromJson(json.decode(str));
String parentPhrasesTableModelToJson(ParentPhrasesTableModel data) => json.encode(data.toJson());
class ParentPhrasesTableModel extends BaseTableModel {
  ParentPhrasesTableModel({
      int? id, 
      int? phraseId, 
      String? word, 
      int? star, 
      String? synonyms, 
      String? wordClassComment, 
      String? parentPhrase,}){
    _id = id;
    _phraseId = phraseId;
    _word = word;
    _star = star;
    _synonyms = synonyms;
    _wordClassComment = wordClassComment;
    _parentPhrase = parentPhrase;
}

  ParentPhrasesTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _phraseId = json['phrase_id'];
    _word = json['word'];
    _star = json['star'];
    _synonyms = json['synonyms'];
    _wordClassComment = json['word_class_comment'];
    _parentPhrase = json['parent_phrase'];
  }
  int? _id;
  int? _phraseId;
  String? _word;
  int? _star;
  String? _synonyms;
  String? _wordClassComment;
  String? _parentPhrase;
ParentPhrasesTableModel copyWith({  int? id,
  int? phraseId,
  String? word,
  int? star,
  String? synonyms,
  String? wordClassComment,
  String? parentPhrase,
}) => ParentPhrasesTableModel(  id: id ?? _id,
  phraseId: phraseId ?? _phraseId,
  word: word ?? _word,
  star: star ?? _star,
  synonyms: synonyms ?? _synonyms,
  wordClassComment: wordClassComment ?? _wordClassComment,
  parentPhrase: parentPhrase ?? _parentPhrase,
);
  int? get id => _id;
  int? get phraseId => _phraseId;
  String? get word => _word;
  int? get star => _star;
  String? get synonyms => _synonyms;
  String? get wordClassComment => _wordClassComment;
  String? get parentPhrase => _parentPhrase;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phrase_id'] = _phraseId;
    map['word'] = _word;
    map['star'] = _star;
    map['synonyms'] = _synonyms;
    map['word_class_comment'] = _wordClassComment;
    map['parent_phrase'] = _parentPhrase;
    return map;
  }

}