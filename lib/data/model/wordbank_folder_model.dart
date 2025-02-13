import 'dart:convert';

/// id : 1
/// folder_name : ""

WordBankFolderModel wordbankFolderModelFromJson(String str) => WordBankFolderModel.fromJson(json.decode(str));

String wordbankFolderModelToJson(WordBankFolderModel data) => json.encode(data.toJson());

class WordBankFolderModel {
  WordBankFolderModel({
    int? id,
    String? folderName,
    int? isDefault,
  }) {
    _id = id;
    _folderName = folderName;
    _isDefault = isDefault ?? 0;
  }

  WordBankFolderModel.fromJson(dynamic json) {
    _id = json['id'];
    _folderName = json['folder_name'];
    if (json['is_default'] != null) {
      _isDefault = json['is_default'];
    }

  }

  int? _id;
  String? _folderName;
  int? _isDefault;

  WordBankFolderModel copyWith({
    int? id,
    String? folderName,
    int? isDefault,
  }) =>
      WordBankFolderModel(
        id: id ?? _id,
        folderName: folderName ?? _folderName,
        isDefault: isDefault ?? this.isDefault,
      );

  int? get id => _id;

  String? get folderName => _folderName;

  int? get isDefault => _isDefault;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['folder_name'] = _folderName;
    map['is_default'] = _isDefault;
    return map;
  }
}
