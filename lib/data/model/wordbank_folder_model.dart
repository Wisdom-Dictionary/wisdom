import 'dart:convert';

/// id : 1
/// folder_name : ""

WordBankFolderModel wordbankFolderModelFromJson(String str) =>
    WordBankFolderModel.fromJson(json.decode(str));

String wordbankFolderModelToJson(WordBankFolderModel data) => json.encode(data.toJson());

class WordBankFolderModel {
  WordBankFolderModel({
    int? id,
    String? folderName,
  }) {
    _id = id;
    _folderName = folderName;
  }

  WordBankFolderModel.fromJson(dynamic json) {
    _id = json['id'];
    _folderName = json['folder_name'];
  }

  int? _id;
  String? _folderName;

  WordBankFolderModel copyWith({
    int? id,
    String? folderName,
  }) =>
      WordBankFolderModel(
        id: id ?? _id,
        folderName: folderName ?? _folderName,
      );

  int? get id => _id;

  String? get folderName => _folderName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['folder_name'] = _folderName;
    return map;
  }
}
