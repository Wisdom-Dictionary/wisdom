import 'dart:convert';

import '../base_table_model.dart';
/// id : 1
/// value : ""
/// phrase_id : 1

PhrasesExampleTableId phrasesExampleTableIdFromJson(String str) => PhrasesExampleTableId.fromJson(json.decode(str));
String phrasesExampleTableIdToJson(PhrasesExampleTableId data) => json.encode(data.toJson());
class PhrasesExampleTableId extends BaseTableModel {
  PhrasesExampleTableId({
      int? id, 
      String? value, 
      int? phrasesId,}){
    _id = id;
    _value = value;
    _phrasesId = phrasesId;
}

  PhrasesExampleTableId.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
    _phrasesId = json['phrase_id'];
  }
  int? _id;
  String? _value;
  int? _phrasesId;
PhrasesExampleTableId copyWith({  int? id,
  String? value,
  int? phrasesId,
}) => PhrasesExampleTableId(  id: id ?? _id,
  value: value ?? _value,
  phrasesId: phrasesId ?? _phrasesId,
);
  int? get id => _id;
  String? get value => _value;
  int? get phrasesId => _phrasesId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    map['phrase_id'] = _phrasesId;
    return map;
  }

}
