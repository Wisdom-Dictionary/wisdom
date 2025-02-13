import 'dart:convert';

import '../base_table_model.dart';
/// id : 1
/// word_id : 1
/// word : ""
/// body : ""

DifferenceTableModel differenceTableModelFromJson(String str) => DifferenceTableModel.fromJson(json.decode(str));
String differenceTableModelToJson(DifferenceTableModel data) => json.encode(data.toJson());
class DifferenceTableModel extends BaseTableModel {
  DifferenceTableModel({
      int? id, 
      int? wordId, 
      String? word, 
      String? body,}){
    _id = id;
    _wordId = wordId;
    _word = word;
    _body = body;
}

  DifferenceTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordId = json['word_id'];
    _word = json['word'];
    _body = json['body'];
  }
  int? _id;
  int? _wordId;
  String? _word;
  String? _body;
DifferenceTableModel copyWith({  int? id,
  int? wordId,
  String? word,
  String? body,
}) => DifferenceTableModel(  id: id ?? _id,
  wordId: wordId ?? _wordId,
  word: word ?? _word,
  body: body ?? _body,
);
  int? get id => _id;
  int? get wordId => _wordId;
  String? get word => _word;
  String? get body => _body;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_id'] = _wordId;
    map['word'] = _word;
    map['body'] = _body;
    return map;
  }

}
