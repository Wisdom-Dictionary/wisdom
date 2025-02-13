import 'dart:convert';

import 'package:wisdom/data/model/base_table_model.dart';
/// id : 1
/// word_id : 1
/// body : ""

MetaphorTableModel metaphorTableModelFromJson(String str) => MetaphorTableModel.fromJson(json.decode(str));
String metaphorTableModelToJson(MetaphorTableModel data) => json.encode(data.toJson());
class MetaphorTableModel extends BaseTableModel {
  MetaphorTableModel({
      int? id, 
      int? wordId, 
      String? body,}){
    _id = id;
    _wordId = wordId;
    _body = body;
}

  MetaphorTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordId = json['word_id'];
    _body = json['body'];
  }
  int? _id;
  int? _wordId;
  String? _body;
MetaphorTableModel copyWith({  int? id,
  int? wordId,
  String? body,
}) => MetaphorTableModel(  id: id ?? _id,
  wordId: wordId ?? _wordId,
  body: body ?? _body,
);
  int? get id => _id;
  int? get wordId => _wordId;
  String? get body => _body;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_id'] = _wordId;
    map['body'] = _body;
    return map;
  }

}
