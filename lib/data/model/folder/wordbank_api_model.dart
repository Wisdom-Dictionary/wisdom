import '../word_bank_model.dart';

class WordBankApiModel {
  final int? folderId;
  final int? wordId;
  final int? wordParentId;
  final String? word;
  final String? translation;
  final int? number;
  final String? type;
  final String? wordClass;
  final String? wordClassBody;
  final String? example;
  final int? userId;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  WordBankApiModel({
    this.folderId,
    this.wordId,
    this.wordParentId,
    this.word,
    this.translation,
    this.number,
    this.type,
    this.wordClass,
    this.wordClassBody,
    this.example,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory WordBankApiModel.fromJson(Map<String, dynamic> json) {
    return WordBankApiModel(
      folderId: json['folder_id'],
      wordId: json['word_id'],
      wordParentId: json['word_parent_id'],
      word: json['word'],
      translation: json['translation'],
      number: json['number'],
      type: json['type'],
      wordClass: json['word_class'],
      wordClassBody: json['word_class_body'],
      example: json['example'],
      userId: json['user_id'],
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folder_id': folderId,
      'word_id': wordId,
      'word_parent_id': wordParentId,
      'word': word,
      'translation': translation,
      'number': number,
      'type': type,
      'word_class': wordClass,
      'word_class_body': wordClassBody,
      'example': example,
      'user_id': userId,
      'updated_at': updatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'id': id,
    };
  }

  WordBankModel toEntity() {
    return WordBankModel(
      id: wordId,
      folderId: folderId,
      tableId: id,
      parentId: wordParentId,
      word: word,
      translation: translation,
      number: number,
      type: type,
      wordClass: wordClass,
      wordClassBody: wordClassBody,
      example: example,
    );
  }
}
