import 'dart:convert';

import 'package:wisdom/core/services/dio_client.dart';
import 'package:wisdom/data/model/folder/folder_response.dart';
import 'package:wisdom/data/model/folder/wordbank_response.dart';
import 'package:wisdom/data/model/word_bank_model.dart';

import '../../config/constants/urls.dart';
import '../../domain/repositories/wordbank_api_repository.dart';
import '../model/folder/wordbank_and_folder_response.dart';

class WordBankApiRepositoryImpl extends WordBankApiRepository {
  final DioClient _dioClient;

  WordBankApiRepositoryImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<FolderResponse> createFolder(String name) async {
    final response = await _dioClient.post(
      Urls.createFolder.path,
      data: {
        "name": name,
      },
    );
    final data = FolderResponse.fromJson(jsonDecode(response.data));
    return data;
  }

  @override
  Future<WordBankResponse> createWordBank(WordBankModel model) async {
    final response = await _dioClient.post(
      Urls.createWordBank.path,
      data: {
        "folder_id": model.folderId,
        "word_id": model.id,
        "word_parent_id": model.parentId,
        "word": model.word,
        "translation": model.translation,
        "number": model.number,
        "type": model.type,
        "word_class": model.wordClass,
        "word_class_body": model.wordClassBody,
        "example": model.example,
      },
    );
    final data = WordBankResponse.fromJson(jsonDecode(response.data));
    return data;
  }

  @override
  Future<bool> deleteFolder(int id) async {
    final response = await _dioClient.delete(
      Urls.deleteFolder.path,
      data: {
        "folder_id": id,
      },
    );
    return response.isSuccessful;
  }

  @override
  Future<bool> deleteWordBank(int id) async {
    final response = await _dioClient.delete(
      Urls.deleteWordBank.path,
      data: {
        "wordbank_id": id,
      },
    );
    return response.isSuccessful;
  }

  @override
  Future<WordBankAndFolderResponse> getAllWordBankAndFolders() async {
    final response = await _dioClient.get(Urls.wordBankList.path);
    final data = WordBankAndFolderResponse.fromJson(jsonDecode(response.data));
    return data;
  }

  @override
  Future<bool> moveWordBank(int id, int folderId) async {
    final response = await _dioClient.post(Urls.moveWordBank.path, data: {
      "wordbank_id": id,
      "folder_id": folderId,
    });
    return response.isSuccessful;
  }
}
