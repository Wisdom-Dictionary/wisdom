import 'dart:convert';

import '../base_table_model.dart';

/// id : 1
/// word_id : 1
/// body : ""

CollocationTableModel collocationTableModelFromJson(String str) =>
    CollocationTableModel.fromJson(json.decode(str));
String collocationTableModelToJson(CollocationTableModel data) => json.encode(data.toJson());

class CollocationTableModel extends BaseTableModel {
  CollocationTableModel({
    int? id,
    int? wordId,
    String? body,
  }) {
    _id = id;
    _wordId = wordId;
    _body = body;
  }

  CollocationTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordId = json['word_id'];
    _body = json['body'];
  }
  int? _id;
  int? _wordId;
  String? _body;
  CollocationTableModel copyWith({
    int? id,
    int? wordId,
    String? body,
  }) =>
      CollocationTableModel(
        id: id ?? _id,
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
