import 'dart:convert';

/// tableId : 1
/// id : 1
/// parentId : 1
/// word : ""
/// translation : ""
/// number : 1
/// example : ""
/// created_at : ""
/// word_class : ""
/// word_class_body : ""
/// type : ""
/// folder_id : 1

WordBankModel wordBankModelFromJson(String str) => WordBankModel.fromJson(json.decode(str));

String wordBankModelToJson(WordBankModel data) => json.encode(data.toJson());

class WordBankModel {
  WordBankModel({
    int? tableId,
    int? id,
    int? parentId,
    String? word,
    String? translation,
    int? number,
    String? example,
    String? createdAt,
    String? wordClass,
    String? wordClassBody,
    String? type,
    int? folderId,
  }) {
    _tableId = tableId;
    _id = id;
    _parentId = parentId;
    _word = word;
    _translation = translation;
    _number = number;
    _example = example;
    _createdAt = createdAt;
    _wordClass = wordClass;
    _wordClassBody = wordClassBody;
    _type = type;
    _folderId = folderId;
  }

  WordBankModel.fromJson(dynamic json) {
    _tableId = json['tableId'];
    _id = json['id'];
    _parentId = json['parentId'];
    _word = json['word'];
    _translation = json['translation'];
    _number = json['number'];
    _example = json['example'];
    _createdAt = json['created_at'];
    _wordClass = json['word_class'];
    _wordClassBody = json['word_class_body'];
    _type = json['type'];
    _folderId = json['folder_id'];
  }

  int? _tableId;
  int? _id;
  int? _parentId;
  String? _word;
  String? _translation;
  int? _number;
  String? _example;
  String? _createdAt;
  String? _wordClass;
  String? _wordClassBody;
  String? _type;
  int? _folderId;

  WordBankModel copyWith({
    int? tableId,
    int? id,
    int? parentId,
    String? word,
    String? translation,
    int? number,
    String? example,
    String? createdAt,
    String? wordClass,
    String? wordClassBody,
    String? type,
    int? folderId,
  }) =>
      WordBankModel(
        tableId: tableId ?? _tableId,
        id: id ?? _id,
        parentId: parentId ?? _parentId,
        word: word ?? _word,
        translation: translation ?? _translation,
        number: number ?? _number,
        example: example ?? _example,
        createdAt: createdAt ?? _createdAt,
        wordClass: wordClass ?? _wordClass,
        wordClassBody: wordClassBody ?? _wordClassBody,
        type: type ?? _type,
        folderId: folderId ?? _folderId,
      );

  int? get tableId => _tableId;

  set tableId(int? newTableId) => _tableId = newTableId;

  int? get id => _id;

  int? get parentId => _parentId;

  String? get word => _word;

  String? get translation => _translation;

  int? get number => _number;

  String? get example => _example;

  String? get createdAt => _createdAt;

  String? get wordClass => _wordClass;

  String? get wordClassBody => _wordClassBody;

  String? get type => _type;

  int? get folderId => _folderId;

  set folderId(int? newFolderId) => _folderId = newFolderId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tableId'] = _tableId;
    map['id'] = _id;
    map['parentId'] = _parentId;
    map['word'] = _word;
    map['translation'] = _translation;
    map['number'] = _number;
    map['example'] = _example;
    map['created_at'] = _createdAt;
    map['word_class'] = _wordClass;
    map['word_class_body'] = _wordClassBody;
    map['type'] = _type;
    map['folder_id'] = _folderId;
    return map;
  }
}
