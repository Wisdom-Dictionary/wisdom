import 'package:wisdom/data/model/wordbank_folder_model.dart';

class FolderApiModel {
  final int userId;
  final String name;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;
  final bool isDefault;

  FolderApiModel({
    required this.userId,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.isDefault,
  });

  factory FolderApiModel.fromJson(Map<String, dynamic> json) {
    return FolderApiModel(
      userId: json['user_id'],
      name: json['name'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
      'is_default': isDefault
    };
  }

  WordBankFolderModel toEntity() {
    return WordBankFolderModel(
      id: id,
      folderName: name,
      isDefault: isDefault ? 1 : 0,
    );
  }
}
