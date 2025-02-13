import 'package:wisdom/data/model/phrases_with_all.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/data/model/word_entity_model.dart';
import 'package:wisdom/data/model/word_path_model/word_path_model.dart';
import 'package:wisdom/domain/entities/word_bank_folder_entity.dart';

abstract class WordEntityRepository {
  Future<void> getWordEntity(String pathUri);

  Future<WordPathModel?> getUpdatedWords();

  Future<void> getRequiredWord(int wordId);

  Future<bool> moveToFolder(int folderId, int tableId, int? wordId);

  Future<void> getWordBankFolders();

  Future<void> deleteWordBankFolder(int folderId);

  Future<void> addNewWordBankFolder(String folderName);

  Future<void> saveWordBank(WordBankModel model);

  Future<int> getWordBankCount();

  Future<void> deleteWorkBank(WordBankModel model);

  Future<void> getWordBankList(int? folderId);

  Future updateWordBank();

  Future clearWordBank();

  List<WordBankModel> get wordBankList;

  List<WordBankModel> get wordBankListForCount;

  List<WordBankFolderEntity> get wordBankFoldersList;

  WordWithAll get requiredWordWithAllModel;

  List<WordEntityModel> get wordWordEntityList;

  WordPathModel get wordPathModel;

  int get currentSizeOfPathModel;
  int get wrongFolderId;
  Future<int> get allWordBanksCount;
}
