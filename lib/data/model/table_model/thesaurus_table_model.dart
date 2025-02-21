import 'dart:convert';

import 'package:wisdom/data/model/base_table_model.dart';
/// id : 1
/// word_id : 1
/// body : ""

ThesaurusTableModel thesaurusTableModelFromJson(String str) =>
    ThesaurusTableModel.fromJson(json.decode(str));
String thesaurusTableModelToJson(ThesaurusTableModel data) => json.encode(data.toJson());

class ThesaurusTableModel extends BaseTableModel {
  ThesaurusTableModel({
    int? id,
    int? wordId,
    String? body,
  }) {
    _id = id;
    _wordId = wordId;
    _body = body;
  }

  ThesaurusTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordId = json['word_id'];
    _body = json['body'];
  }
  int? _id;
  int? _wordId;
  String? _body;
  ThesaurusTableModel copyWith({
    int? id,
    int? wordId,
    String? body,
  }) =>
      ThesaurusTableModel(
        id: id ?? _id,
        wordId: wordId ?? _wordId,
        body: body ?? _body,
      );
  int? get id => _id;
  int? get wordId => _wordId;
  String? get body => _body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_id'] = _wordId;
    map['body'] = _body;
    return map;
  }
}
