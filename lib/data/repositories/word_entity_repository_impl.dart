import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/phrases_with_all.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/data/model/word_entity_model.dart';
import 'package:wisdom/data/model/word_path_model/word_path_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/entities/word_bank_folder_entity.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';

import '../../domain/repositories/wordbank_api_repository.dart';

class WordEntityRepositoryImpl extends WordEntityRepository {
  WordEntityRepositoryImpl({
    required this.client,
    required this.dbHelper,
    required this.wordBankApiRepository,
  });

  final WordBankApiRepository wordBankApiRepository;
  final CustomClient client;
  final DBHelper dbHelper;
  final List<WordEntityModel> _wordEntityList = [];
  final List<WordBankModel> _wordBankList = [];
  final Set<WordBankModel> _wordBankListForCount = {};
  final List<WordBankFolderEntity> _wordBankFolderList = [];
  WordPathModel _wordPathModel = WordPathModel();
  WordWithAll _requitedWordWithAll = WordWithAll();
  final String _wrongFolderName = 'wrong_answers';

  @override
  int get wrongFolderId {
    var defaultFolders = _wordBankFolderList.where((element) => element.isDefault == 1).toList();
    final data =
        defaultFolders.indexWhere((element) => element.folderName.contains(_wrongFolderName));
    return data == -1 ? defaultFolders.first.id : defaultFolders[data].id;
  }

  // getting words from api
  @override
  Future<void> getWordEntity(String pathUri) async {
    try {
      var response = await get(Uri.parse('${Urls.baseUrl}$pathUri'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final mappedData = data.map((item) => WordEntityModel.fromJson(item)).toList();
        // _wordEntityList = [for (final item in jsonDecode(response.body)) WordEntityModel.fromJson(item)];
        await dbHelper.saveAllWords(mappedData);
        log("LOG: ${Urls.baseUrl}$pathUri added");
      } else {
        throw VMException(response.body, callFuncName: 'getWordEntity', response: response);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // getting words version, paths to update
  @override
  Future<WordPathModel?> getUpdatedWords() async {
    var response = await get(Urls.getWordsPaths);
    if (response.statusCode == 200) {
      _wordPathModel = WordPathModel.fromJson(jsonDecode(response.body));
      return _wordPathModel;
    } else {
      throw VMException(response.body, callFuncName: 'getWordsPaths', response: response);
    }
  }

  @override
  List<WordEntityModel> get wordWordEntityList => _wordEntityList;

  @override
  WordPathModel get wordPathModel => _wordPathModel;

  @override
  Future<void> getRequiredWord(int wordId) async {
    var response = await dbHelper.getWord1(wordId);
    if (response != null) {
      _requitedWordWithAll = response;
    }
  }

  @override
  WordWithAll get requiredWordWithAllModel => _requitedWordWithAll;

  @override
  Future<void> saveWordBank(WordBankModel model) async {
    await wordBankApiRepository.createWordBank(model).then(
      (value) async {
        if (value.wordBank != null) {
          await dbHelper.saveToWordBank(model.copyWith(tableId: value.wordBank!.id)).then((value) {
            model.tableId = value;
            _wordBankList.add(model);
            _wordBankListForCount.add(model);
          });
        }
      },
    );
  }

  @override
  Future<bool> moveToFolder(int folderId, int tableId, int? wordId) async {
    return await wordBankApiRepository.moveWordBank(tableId, folderId).then(
      (value) async {
        if (value) {
          return await dbHelper.moveToFolder(
            folderId: folderId,
            tableId: tableId,
            wordId: wordId,
          );
        }
        return false;
      },
    );
  }

  @override
  Future<void> getWordBankList(int? folderId) async {
    _wordBankList.clear();
    var response = await dbHelper.getWordBankList(folderId);
    if (response != null && response.isNotEmpty) {
      _wordBankList.addAll(response);
    }
  }

  @override
  List<WordBankModel> get wordBankList => _wordBankList;

  @override
  Future<void> deleteWorkBank(WordBankModel model) async {
    await wordBankApiRepository.deleteWordBank(model.tableId!).then((value) {
      if (value) {
        dbHelper.deleteWordBank(model.tableId!);
        _wordBankList.remove(model);
        _wordBankListForCount.remove(model);
        getWordBankCount();
      }
    });
  }

  @override
  Future<int> getWordBankCount() async {
    _wordBankListForCount.clear();
    var result = await dbHelper.getWordBankCount();
    if (result.isNotEmpty) {
      _wordBankListForCount.addAll(result);
    }
    return _wordBankListForCount.length;
  }

  @override
  Future<void> getWordBankFolders() async {
    _wordBankFolderList.clear();
    var response = await dbHelper.getWordBankFolderList();
    if (response != null && response.isNotEmpty) {
      for (var element in response) {
        _wordBankFolderList.add(
          WordBankFolderEntity(
            id: element.id!,
            folderName: element.folderName!,
            isChecked: false,
            isDefault: element.isDefault!,
          ),
        );
      }
    }
  }

  @override
  Future<void> deleteWordBankFolder(int folderId) async {
    await wordBankApiRepository.deleteFolder(folderId).then(
      (value) {
        if (value) {
          dbHelper.deleteWordBankByFolder(folderId);
          dbHelper.deleteWordBankFolderList(folderId);
          _wordBankList.removeWhere((element) => element.folderId == folderId);
          _wordBankListForCount.removeWhere((element) => element.folderId == folderId);
          _wordBankFolderList.removeWhere((element) => element.id == folderId);
        }
      },
    );
  }

  @override
  List<WordBankFolderEntity> get wordBankFoldersList => _wordBankFolderList;

  @override
  Future<void> addNewWordBankFolder(String folderName) async {
    await wordBankApiRepository.createFolder(folderName).then(
      (value) async {
        if (value.status == true) {
          await dbHelper.saveToWordBankFolder(folderName, value.folder!.id).then(
                (value) => _wordBankFolderList.add(
                  WordBankFolderEntity(
                    id: value!,
                    folderName: folderName,
                    isChecked: false,
                    isDefault: 0,
                  ),
                ),
              );
        }
      },
    );
  }

  @override
  List<WordBankModel> get wordBankListForCount => _wordBankListForCount.toList();

  @override
  int get currentSizeOfPathModel => _wordPathModel.files?.length ?? 0;

  @override
  Future updateWordBank() async {
    try {
      await dbHelper.deleteAllWordBank();
      await dbHelper.deleteAllWordBankFolder();
      final wordBankList = await wordBankApiRepository.getAllWordBankAndFolders();
      await dbHelper.saveWordBankFolderList(wordBankList.folders.map((e) => e.toEntity()).toList());
      await dbHelper.saveWordBankList(wordBankList.wordBanks.map((e) => e.toEntity()).toList());
    } catch (e) {
      log("updateWordBank", error: e.toString());
    }
  }

  @override
  Future clearWordBank() async {
    await dbHelper.deleteAllWordBank();
    await dbHelper.deleteAllWordBankFolder();
    _wordBankList.clear();
    _wordBankListForCount.clear();
    _wordBankFolderList.clear();
    locator.get<LocalViewModel>().changeBadgeCount(0);
  }

  @override
  Future<int> get allWordBanksCount async => await dbHelper.getWordbankCount();
}
