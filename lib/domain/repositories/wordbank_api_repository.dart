import 'package:wisdom/data/model/folder/folder_response.dart';
import 'package:wisdom/data/model/folder/wordbank_and_folder_response.dart';
import 'package:wisdom/data/model/folder/wordbank_response.dart';
import 'package:wisdom/data/model/word_bank_model.dart';

abstract class WordBankApiRepository {
  Future<WordBankAndFolderResponse> getAllWordBankAndFolders();

  Future<FolderResponse> createFolder(String name);

  Future<bool> deleteFolder(int id);

  Future<WordBankResponse> createWordBank(WordBankModel model);

  Future<bool> deleteWordBank(int id);

  Future<bool> moveWordBank(int id, int folderId);
}
