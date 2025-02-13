import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:jbaza/jbaza.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wisdom/core/extensions/db_extension.dart';
import 'package:wisdom/core/utils/word_mapper.dart';
import 'package:wisdom/data/model/collocation_model.dart';
import 'package:wisdom/data/model/culture_model.dart';
import 'package:wisdom/data/model/difference_model.dart';
import 'package:wisdom/data/model/grammar_model.dart';
import 'package:wisdom/data/model/metaphor_model.dart';
import 'package:wisdom/data/model/parent_phrases_example_model.dart';
import 'package:wisdom/data/model/parent_phrases_model.dart';
import 'package:wisdom/data/model/parent_phrases_translate_model.dart';
import 'package:wisdom/data/model/parents_model.dart';
import 'package:wisdom/data/model/phrases_example_model.dart';
import 'package:wisdom/data/model/phrases_model.dart';
import 'package:wisdom/data/model/phrases_translate_model.dart';
import 'package:wisdom/data/model/search_result_uz_model.dart';
import 'package:wisdom/data/model/speaking_view_model.dart';
import 'package:wisdom/data/model/table_model/collocation_table_model.dart';
import 'package:wisdom/data/model/table_model/grammar_table_model.dart';
import 'package:wisdom/data/model/table_model/metaphor_table_model.dart';
import 'package:wisdom/data/model/table_model/parent_phrases_table_model.dart';
import 'package:wisdom/data/model/table_model/parent_phrases_translate_table_model.dart';
import 'package:wisdom/data/model/table_model/parents_table_model.dart';
import 'package:wisdom/data/model/table_model/phrases_example_table_id.dart';
import 'package:wisdom/data/model/table_model/words_uz_table_model.dart';
import 'package:wisdom/data/model/thesaurus_model.dart';
import 'package:wisdom/data/model/word_and_parents_and_phrases_and_translate_model.dart';
import 'package:wisdom/data/model/word_and_parents_and_phrases_parent_phrases_and_translate_model.dart';
import 'package:wisdom/data/model/word_and_phrases_and_translate_model.dart';
import 'package:wisdom/data/model/word_and_phrases_model.dart';
import 'package:wisdom/data/model/word_entity_model.dart';
import 'package:wisdom/data/model/word_with_collocation_model.dart';
import 'package:wisdom/data/model/word_with_culture_model.dart';
import 'package:wisdom/data/model/word_with_difference_model.dart';
import 'package:wisdom/data/model/word_with_grammar_model.dart';
import 'package:wisdom/data/model/word_with_metaphor_model.dart';
import 'package:wisdom/data/model/word_with_theasurus_model.dart';
import 'package:wisdom/data/model/words_uz_model.dart';

import '../../data/model/catalog_model.dart';
import '../../data/model/phrases_with_all.dart';
import '../../data/model/table_model/culture_table_model.dart';
import '../../data/model/table_model/difference_table_model.dart';
import '../../data/model/table_model/phrases_table_model.dart';
import '../../data/model/table_model/phrases_translate_table_model.dart';
import '../../data/model/table_model/thesaurus_table_model.dart';
import '../../data/model/word_and_parents_and_phrases_model.dart';
import '../../data/model/word_and_parets_and_words_uz_model.dart';
import '../../data/model/word_bank_model.dart';
import '../../data/model/word_model.dart';
import '../../data/model/word_with_difference_new_model.dart';
import '../../data/model/wordbank_folder_model.dart';

class DBHelper {
  DBHelper(this.wordMapper);

  final WordMapper wordMapper;
  late Database database;

  final String databaseName = 'waio_dictionary.db';
  final int databaseVersion = 1;

  final String tableWordEntity = 'word_entity';
  final String tableWordsUz = 'words_uz';
  final String tableCatalogue = 'catalogue';
  final String tableCollocation = 'collocation';
  final String tableCulture = 'culture';
  final String tableDifference = 'difference';
  final String tableGrammar = 'grammar';
  final String tableMetaphor = 'metaphor';
  final String tableParentPhrases = 'parent_phrases';
  final String tableParentPhrasesExample = 'parent_phrases_example';
  final String tableParentPhrasesTranslate = 'parent_phrases_translate';
  final String tableParents = 'parents';
  final String tablePhrases = 'phrases';
  final String tablePhrasesExample = 'phrases_example';
  final String tablePhrasesTranslate = 'phrases_translate';
  final String tableThesaurus = 'thesaurus';
  final String tableWordBank = 'word_bank';
  final String tableWordBankFolder = 'folders';
  final String tableSpeakingView = 'speaking_view';

  // final int _dbVersion = 2;

  Future<void> init() async {
    late String databasesPath;
    if (Platform.isAndroid) {
      databasesPath = await getDatabasesPath();
    } else if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      databasesPath = await databaseFactory.getDatabasesPath();
    } else {
      var platformPath = await getLibraryDirectory();
      databasesPath = platformPath.path;
    }
    var path = p.join(databasesPath, databaseName);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(p.dirname(path)).create(recursive: true);
      } catch (e) {
        log("init", error: e.toString());
      }

      ByteData data = await rootBundle.load(p.join("assets", databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    if (Platform.isWindows) {
      database = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          onUpgrade: _onUpgrade,
          readOnly: false,
          version: 10,
        ),
      );
    } else {
      database = await openDatabase(
        path,
        readOnly: false,
        version: 10,
        onUpgrade: _onUpgrade,
      );
    }
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();
    if (newVersion == 10) {
      _addFolderIsDefault(batch);
    }
    await batch.commit();
  }

  String joinPath(String v1, String v2) {
    return '$v1${Platform.isWindows ? '/' : '\''}$v2';
  }

  void _addFolderIsDefault(Batch batch) {
    batch.execute(
        'alter table folders add  column is_default bolean default false');
  }

  //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/////////////////////////\\\\\\\\\\\\\\\\\\\\\\\///////////////////////////

  Future saveAllWords(List<WordEntityModel> wordEntityModel) async {
    try {
      await saveToWordEntity(wordMapper.wordListToWordEntity(wordEntityModel));
      await saveToWordUz(wordMapper.wordListToWordUz(wordEntityModel));
      await saveToCollocation(
          wordMapper.wordListToCollocation(wordEntityModel));
      await saveToCulture(wordMapper.wordListToCulture(wordEntityModel));
      await saveToDifference(wordMapper.wordListToDifference(wordEntityModel));
      await saveToGrammar(wordMapper.wordListToGrammar(wordEntityModel));
      await saveToMetaphor(wordMapper.wordListToMetaphor(wordEntityModel));
      await saveToThesaurus(wordMapper.wordListToThesaurus(wordEntityModel));
      await saveToPhrases(wordMapper.wordListToPhrases(wordEntityModel));
      await saveToPhrasesTranslate(
          wordMapper.wordListToPhrasesTranslate(wordEntityModel));
      await saveToPhrasesExample(
          wordMapper.wordListToPhrasesExample(wordEntityModel));
      await saveToParentPhrases(
          wordMapper.wordListToParentPhrases(wordEntityModel));
      await saveToParentPhrasesTranslate(
          wordMapper.wordListToParentPhrasesTranslate(wordEntityModel));
      await saveToParentPhrasesExample(
          wordMapper.wordListToParentPhraseExample(wordEntityModel));
      await saveToParents(wordMapper.wordListToParents(wordEntityModel));
    } catch (e) {}
    try {
      await saveToWordUz(wordMapper.wordListToWordUzParent(wordEntityModel));
      await saveToCollocation(
          wordMapper.wordListToCollocationParent(wordEntityModel));
      await saveToCulture(wordMapper.wordListToCultureParent(wordEntityModel));
      await saveToDifference(
          wordMapper.wordListToDifferenceParent(wordEntityModel));
      await saveToGrammar(wordMapper.wordListToGrammarParent(wordEntityModel));
      await saveToMetaphor(
          wordMapper.wordListToMetaphorParent(wordEntityModel));
      await saveToThesaurus(
          wordMapper.wordListToThesaurusParent(wordEntityModel));
      await saveToPhrases(wordMapper.wordListToPhrasesParent(wordEntityModel));
      await saveToPhrasesTranslate(
          wordMapper.wordListToPhrasesTranslateParent(wordEntityModel));
      await saveToPhrasesExample(
          wordMapper.wordListToPhrasesExampleParent(wordEntityModel));
      await saveToParentPhrases(
          wordMapper.wordListToParentPhrasesParent(wordEntityModel));
      await saveToParentPhrasesTranslate(
          wordMapper.wordListToParentPhrasesTranslateParent(wordEntityModel));
      await saveToParentPhrasesExample(
          wordMapper.wordListToPhrasesExampleParent(wordEntityModel));
    } catch (e) {}
  }

  String generateInsertOrUpdateQuery(List<WordModel> entities) {
    if (entities.isEmpty) {
      return '';
    }
    var columns = entities[0].toJson().keys.join(', ');
    var values = entities.map((entity) {
      var formattedValues = entity.toJson().values.map((value) {
        if (value is String) {
          return "'${value.replaceAll("'", "''")}'";
        } else {
          return '$value';
        }
      });
      return '(${formattedValues.join(', ')})';
    }).join(', ');

    var updateValues =
        entities[0].toJson().keys.map((key) => '$key=excluded.$key').join(', ');

    return 'INSERT INTO word_entity ($columns) VALUES $values ON CONFLICT(id) DO UPDATE SET $updateValues;';
  }

  Future<void> saveToWordEntity(List<WordModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableWordEntity);
        if (query.isNotEmpty) await database.rawInsert(query);
        log(wordDBO.last.toJson().toString());
      }
    } catch (e) {
      log("saveToWordEntity", error: e.toString());
    }
  }

  Future<void> saveToWordUz(List<WordsUzTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableWordsUz);
        if (query.isNotEmpty) await database.rawInsert(query);
      }
    } catch (e) {
      log("saveToWordUz", error: e.toString());
    }
  }

  Future<void> saveToCollocation(List<CollocationTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableCollocation);
        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tableCollocation, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToCollocation", error: e.toString());
    }
  }

  Future<void> saveToCulture(List<CultureTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableCulture);
        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tableCulture, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToCulture", error: e.toString());
    }
  }

  Future<void> saveToDifference(List<DifferenceTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableDifference);
        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tableDifference, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToDifference", error: e.toString());
    }
  }

  Future<void> saveToGrammar(List<GrammarTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableGrammar);
        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tableGrammar, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToGrammar", error: e.toString());
    }
  }

  Future<void> saveToMetaphor(List<MetaphorTableModel> wordDBO) async {
    var query = '';
    try {
      if (database.isOpen) {
        query = wordDBO.generateInsertOrReplaceQuery(tableMetaphor);

        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tableMetaphor, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToMetaphor", error: query);
      log("saveToMetaphor", error: e.toString());
    }
  }

  Future<void> saveToThesaurus(List<ThesaurusTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableThesaurus);
        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tableThesaurus, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToThesaurus", error: e.toString());
    }
  }

  Future<void> saveToPhrases(List<PhrasesTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tablePhrases);
        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tablePhrases, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToPhrases", error: e.toString());
    }
  }

  Future<void> saveToPhrasesTranslate(
      List<PhrasesTranslateTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query =
            wordDBO.generateInsertOrReplaceQuery(tablePhrasesTranslate);
        if (query.isNotEmpty) await database.rawInsert(query);
        // for (var element in wordDBO) {
        //   await database.insert(tablePhrasesTranslate, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToPhrasesTranslate", error: e.toString());
    }
  }

  Future<void> saveToPhrasesExample(List<PhrasesExampleTableId> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tablePhrasesExample);
        if (query.isNotEmpty) await database.rawInsert(query);

        // for (var element in wordDBO) {
        //   await database.insert(tablePhrasesExample, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToPhrasesExample", error: e.toString());
    }
  }

  Future<void> saveToParentPhrases(
      List<ParentPhrasesTableModel> wordDBO) async {
    var query = '';
    try {
      if (database.isOpen) {
        query = wordDBO.generateInsertOrReplaceQuery(tableParentPhrases);
        log('saveToParentPhrases --->$query<---');
        if (query.isNotEmpty) await database.rawInsert(query);

        // for (var element in wordDBO) {
        //   await database.insert(tableParentPhrases, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log('saveToParentPhrases --->$query<---');
      log("saveToParentPhrases", error: e.toString());
    }
  }

  Future<void> saveToParentPhrasesTranslate(
      List<ParentPhrasesTranslateTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query =
            wordDBO.generateInsertOrReplaceQuery(tableParentPhrasesTranslate);
        if (query.isNotEmpty) await database.rawInsert(query);

        // for (var element in wordDBO) {
        //   await database.insert(tableParentPhrasesTranslate, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToParentPhrasesTranslate", error: e.toString());
    }
  }

  Future<void> saveToParentPhrasesExample(
      List<PhrasesExampleTableId> wordDBO) async {
    try {
      if (database.isOpen) {
        final query =
            wordDBO.generateInsertOrReplaceQuery(tableParentPhrasesExample);
        if (query.isNotEmpty) await database.rawInsert(query);

        // for (var element in wordDBO) {
        //   await database.insert(tableParentPhrasesExample, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToParentPhrasesExample", error: e.toString());
    }
  }

  Future<void> saveToParents(List<ParentsTableModel> wordDBO) async {
    try {
      if (database.isOpen) {
        final query = wordDBO.generateInsertOrReplaceQuery(tableParents);
        if (query.isNotEmpty) await database.rawInsert(query);

        // for (var element in wordDBO) {
        //   await database.insert(tableParents, element.toJson(),
        //       conflictAlgorithm: ConflictAlgorithm.replace);
        // }
      }
    } catch (e) {
      log("saveToParents", error: e.toString());
    }
  }

  //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/////////////////////////\\\\\\\\\\\\\\\\\\\\\\\///////////////////////////

  Future<void> saveSpeakingView(SpeakingViewModel speakingViewModel) async {
    try {
      if (database.isOpen) {
        database.insert(tableSpeakingView, speakingViewModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } catch (e) {
      log("saveWordToDB", error: e.toString());
    }
  }

  Future<List<CatalogModel>?> getSpeakingViewList(
      int parentId, String query) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT * FROM $tableSpeakingView WHERE parentId=$parentId AND word LIKE '${query.replaceAll("'", "''")}%' ");
        var speakingViewList = List<CatalogModel>.from(response.map((e) {
          var item = SpeakingViewModel.fromJson(e);
          return CatalogModel(
              id: item.wordId,
              word: item.word,
              translate: item.translation,
              category: item.parentId.toString());
        }));
        return speakingViewList;
      }
    } catch (e) {
      log("getSpeakingViewList", error: e.toString());
    }
    return null;
  }

  Future<WordWithGrammarModel?> getGrammar() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,g.id as g_id FROM word_entity we INNER JOIN grammar g ON we.id=g.word_id order by random() limit 1");
        var model = WordWithGrammarModel.fromJson(response.first);
        return model;
      }
    } catch (e) {
      log("getGrammar", error: e.toString());
    }
    return null;
  }

  Future<WordWithDifferenceNewModel?> getDifference() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,d.id as d_id,d.word as d_word FROM word_entity we INNER JOIN difference d ON we.id=d.word_id WHERE d.word LIKE '%or%' ORDER BY random() limit 1");
        var model = WordWithDifferenceNewModel.fromJson(response.first);
        return model;
      }
    } catch (e) {
      log("getDifference", error: e.toString());
    }
    return null;
  }

  Future<WordWithTheasurusModel?> getThesaurus() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,t.id as t_id,t.body as t_body FROM word_entity we INNER JOIN thesaurus t ON we.id=t.word_id order by random() limit 1");
        var model = WordWithTheasurusModel.fromJson(response.first);
        return model;
      }
    } catch (e) {
      log("getThesaurus", error: e.toString());
    }
    return null;
  }

  Future<WordWithCollocationModel?> getCollocation() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,c.id as c_id FROM word_entity we INNER JOIN collocation c ON we.id=c.word_id order by random() limit 1");
        var model = WordWithCollocationModel.fromJson(response.first);
        return model;
      }
    } catch (e) {
      log("getCollocation", error: e.toString());
    }
    return null;
  }

  Future<WordWithMetaphorModel?> getMetaphor() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,m.id as m_id FROM word_entity we INNER JOIN metaphor m ON we.id=m.word_id order by random() limit 1");
        var model = WordWithMetaphorModel.fromJson(response.first);
        return model;
      }
    } catch (e) {
      log("getMetaphor", error: e.toString());
    }
    return null;
  }

  Future<WordModel?> getImage() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "select * from word_entity where image!='null' order by random() limit 1");
        var model = WordModel.fromJson(response.first);
        return model;
      }
    } catch (e) {
      log("getImage", error: e.toString());
    }
    return null;
  }

  Future<WordModel?> getWord() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "select * from word_entity where word !='[]' order by random() limit 1");
        var wordModel = WordModel.fromJson(response.first);
        return wordModel;
      }
    } catch (e) {
      log("getWord", error: e.toString());
    }
    return null;
  }

  Future<WordWithGrammarModel?> getTimeLineGrammar1(String grammarId) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,g.id as g_id,g.body as g_body FROM word_entity we INNER JOIN grammar g ON we.id=g.word_id WHERE g.id=$grammarId");
        var wordModel = WordWithGrammarModel.fromJson(response.first);
        return wordModel;
      }
    } catch (e) {
      log("getTimeLineGrammar1", error: e.toString());
    }
    return null;
  }

  Future<WordWithTheasurusModel?> getTimeLineThesaurus(
      String thesaurusId) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,t.id as t_id,t.body as t_body FROM word_entity we INNER JOIN thesaurus t ON we.id=t.word_id WHERE t.id=$thesaurusId ");
        var wordModel = WordWithTheasurusModel.fromJson(response.first);
        return wordModel;
      }
    } catch (e) {
      log("getTimeLineThesaurus", error: e.toString());
    }
    return null;
  }

  Future<WordWithCollocationModel?> getTimeLineCollocation(
      String collocationId) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,c.id as c_id,c.body as c_body FROM word_entity we INNER JOIN collocation c ON we.id=c.word_id WHERE c.id=$collocationId");
        var wordModel = WordWithCollocationModel.fromJson(response.first);
        return wordModel;
      }
    } catch (e) {
      log("getTimeLineCollocation", error: e.toString());
    }
    return null;
  }

  Future<WordWithMetaphorModel?> getTimeLineMetaphor(String metaphorId) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,m.id as m_id,m.body as m_body FROM word_entity we INNER JOIN metaphor m ON we.id=m.word_id WHERE m.id= $metaphorId");
        var wordModel = WordWithMetaphorModel.fromJson(response.first);
        return wordModel;
      }
    } catch (e) {
      log("getTimeLineMetaphor", error: e.toString());
    }
    return null;
  }

  Future<WordWithCultureModel?> getTimeLineCulture(String cultureId) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,c.id as c_id,c.body as c_body FROM word_entity we INNER JOIN culture c ON we.id=c.word_id WHERE c.id=$cultureId");
        var wordModel = WordWithCultureModel.fromJson(response.first);
        return wordModel;
      }
    } catch (e) {
      log("getTimeLineCulture", error: e.toString());
    }
    return null;
  }

  Future<WordWithDifferenceModel?> getTimeLineDifference(
      String differenceId) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT d.id as d_id,d.word as d_word,d.body as d_body FROM difference d WHERE d.id=$differenceId");
        var wordModel = WordWithDifferenceModel.fromJson(response.first);
        return wordModel;
      }
    } catch (e) {
      log("getTimeLineDifference", error: e.toString());
    }
    return null;
  }

  Future<CatalogModel?> getSpeaking() async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT id, title as word from catalogue where title NOTNULL and category != 'speaking' ORDER BY random() LIMIT 1");
        var model = CatalogModel.fromJson(response.last);
        return model;
      }
    } catch (e) {
      log("getSpeaking", error: e.toString());
    }
    return null;
  }

  Future<List<CatalogModel>?> getCatalogsList(String catalogId) async {
    try {
      if (database.isOpen) {
        var response = await database
            .rawQuery("SELECT * FROM catalogue WHERE category= '$catalogId' ");
        var model = List<CatalogModel>.from(
            response.map((e) => CatalogModel.fromJson(e)));
        return model;
      }
    } catch (e) {
      log("getCatalogsList", error: e.toString());
    }
    return null;
  }

  Future<List<CatalogModel>?> getCollocationList(String? searchText) async {
    try {
      if (database.isOpen) {
        var newQuery =
            searchText != null ? "WHERE we.word LIKE '$searchText%'" : "";
        var response = await database.rawQuery(
            "SELECT c.id,we.word FROM word_entity we INNER JOIN collocation c ON we.id=c.word_id $newQuery");
        var model = List<CatalogModel>.from(
            response.map((e) => CatalogModel.fromJson(e)));
        return model;
      }
    } catch (e) {
      log("getCatalogsList", error: e.toString());
    }
    return null;
  }

  Future<List<CatalogModel>?> getTitleList(
      String categoryId, String? title) async {
    try {
      var newTitle = title != null ? "AND title LIKE '$title%'" : "";
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT * FROM catalogue WHERE category='$categoryId' $newTitle");
        var model = List<CatalogModel>.from(
            response.map((e) => CatalogModel.fromJson(e)));
        return model;
        // TODO:
      }
    } catch (e) {
      log("getTitleList", error: e.toString());
    }
    return null;
  }

  Future<List<CatalogModel>?> getCatalogWordList(
      String categoryId, String query) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT * FROM catalogue WHERE category= '$categoryId' AND word LIKE '${query.replaceAll("'", "''")}%'");
        var model = List<CatalogModel>.from(
            response.map((e) => CatalogModel.fromJson(e)));
        return model;
        // TODO:
      }
    } catch (e) {
      log("getCatalogWordList", error: e.toString());
    }
    return null;
  }

  Future<List<CatalogModel>?> getIfWordIsWordenList(
      String categoryId, String query) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT * FROM catalogue WHERE category= '$categoryId' AND wordenword LIKE '${query.replaceAll("'", "''")}%'");
        var model = List<CatalogModel>.from(
            response.map((e) => CatalogModel.fromJson(e)));
        return model;
      }
    } catch (e) {
      log("getIfWordIsWordenList", error: e.toString());
    }
    return null;
  }

  Future<WordWithAll?> getWord1(int? id) async {
    try {
      WordWithAll _word;
      if (database.isOpen) {
        var responseAll = await database
            .rawQuery("SELECT * FROM word_entity WHERE id=$id LIMIT 1");
        var word = responseAll.isNotEmpty
            ? WordModel.fromJson(responseAll.first)
            : null;

        var responseWordUz =
            await database.rawQuery("SELECT * FROM words_uz WHERE word_id=$id");
        var wordWordUz = responseWordUz.isNotEmpty
            ? List<WordsUzModel>.from(
                responseWordUz.map((e) => WordsUzModel.fromJson(e)))
            : null;

        var responseCollocation = await database
            .rawQuery("SELECT * FROM collocation WHERE word_id=$id ");
        var wordCollocation = responseCollocation.isNotEmpty
            ? List<CollocationModel>.from(
                responseCollocation.map((e) => CollocationModel.fromJson(e)))
            : null;

        var responseCulture =
            await database.rawQuery("SELECT * FROM culture WHERE word_id=$id ");
        var wordCulture = responseCulture.isNotEmpty
            ? List<CultureModel>.from(
                responseCulture.map((e) => CultureModel.fromJson(e)))
            : null;

        var responseDifference = await database
            .rawQuery("SELECT * FROM difference WHERE word_id=$id ");
        var wordDifference = responseDifference.isNotEmpty
            ? List<DifferenceModel>.from(
                responseDifference.map((e) => DifferenceModel.fromJson(e)))
            : null;

        var responseGrammar =
            await database.rawQuery("SELECT * FROM grammar WHERE word_id=$id ");
        var wordGrammar = responseGrammar.isNotEmpty
            ? List<GrammarModel>.from(
                responseGrammar.map((e) => GrammarModel.fromJson(e)))
            : null;

        var responseMetaphor = await database
            .rawQuery("SELECT * FROM metaphor WHERE word_id=$id ");
        var wordMetaphor = responseMetaphor.isNotEmpty
            ? List<MetaphorModel>.from(
                responseMetaphor.map((e) => MetaphorModel.fromJson(e)))
            : null;

        var responseThesaurus = await database
            .rawQuery("SELECT * FROM thesaurus WHERE word_id=$id ");
        var wordThesaurus = responseThesaurus.isNotEmpty
            ? List<ThesaurusModel>.from(
                responseThesaurus.map((e) => ThesaurusModel.fromJson(e)))
            : null;

        var phrasesWithAll = await getPhrasesAll(id);

        var parentWithAll = await getParentsWithAll(id);

        _word = WordWithAll(
            word: word,
            phrasesWithAll: phrasesWithAll,
            thesaurus: wordThesaurus,
            metaphor: wordMetaphor,
            grammar: wordGrammar,
            difference: wordDifference,
            culture: wordCulture,
            collocation: wordCollocation,
            wordsUz: wordWordUz,
            parentsWithAll: parentWithAll);

        return _word;
      }
    } catch (e) {
      log("getWord1", error: e.toString());
    }
    return null;
  }

  Future<List<PhrasesWithAll>> getPhrasesAll(int? id) async {
    List<PhrasesWithAll> phrasesWithAll = [];

    var responsePhrases =
        await database.rawQuery("SELECT * FROM phrases WHERE p_word_id=$id ");
    var phrases = responsePhrases.isNotEmpty
        ? List<PhrasesModel>.from(
            responsePhrases.map((e) => PhrasesModel.fromJson(e)))
        : [];

    for (var element in phrases) {
      var responsePhrasesTranslate = await database.rawQuery(
          "SELECT * FROM phrases_translate WHERE phrase_id=${element.pId} ");
      var wordPhraseTranslate = responsePhrasesTranslate.isNotEmpty
          ? List<PhrasesTranslateModel>.from(responsePhrasesTranslate
              .map((e) => PhrasesTranslateModel.fromJson(e)))
          : null;

      var responsePhrasesExample = await database.rawQuery(
          "SELECT * FROM phrases_example WHERE phrase_id=${element.pId} ");
      var wordPhraseExample = responsePhrasesExample.isNotEmpty
          ? List<PhrasesExampleModel>.from(responsePhrasesExample
              .map((e) => PhrasesExampleModel.fromJson(e)))
          : null;

      var parentsPhrasesWithAll =
          await getParentPhrasesWithAll(element.pId, element.pWord);

      phrasesWithAll.add(PhrasesWithAll(element, wordPhraseTranslate,
          wordPhraseExample, parentsPhrasesWithAll));
    }
    return phrasesWithAll;
  }

  Future<List<ParentPhrasesWithAll>> getParentPhrasesWithAll(
      int? pId, String pWord) async {
    List<ParentPhrasesWithAll>? _parentPhrasesWithAll = [];

    var responseParentPhrases = await database
        .rawQuery("SELECT * FROM parent_phrases WHERE phrase_id=$pId");
    var parentPhrases = responseParentPhrases.isNotEmpty
        ? List<ParentPhrasesModel>.from(
            responseParentPhrases.map((e) => ParentPhrasesModel.fromJson(e)))
        : [];

    for (var element in parentPhrases) {
      element.word = pWord;
      var responseParentPhrasesExample = await database.rawQuery(
          "SELECT * FROM parent_phrases_example WHERE phrase_id=${element.id}");
      var wordPhraseParentPhrasesExample = responseParentPhrasesExample
              .isNotEmpty
          ? List<ParentPhrasesExampleModel>.from(responseParentPhrasesExample
              .map((e) => ParentPhrasesExampleModel.fromJson(e)))
          : null;

      var responseParentPhrasesTranslate = await database.rawQuery(
          "SELECT * FROM parent_phrases_translate WHERE phrase_id=${element.id}");
      var wordPhraseParentPhrasesTranslate =
          responseParentPhrasesTranslate.isNotEmpty
              ? List<ParentPhrasesTranslateModel>.from(
                  responseParentPhrasesTranslate
                      .map((e) => ParentPhrasesTranslateModel.fromJson(e)))
              : null;
      if ((responseParentPhrasesTranslate.isNotEmpty)) {
        _parentPhrasesWithAll.add(ParentPhrasesWithAll(element,
            wordPhraseParentPhrasesExample, wordPhraseParentPhrasesTranslate));
      }
    }
    return _parentPhrasesWithAll;
  }

  Future<List<ParentsWithAll>?> getParentsWithAll(int? id) async {
    List<ParentsWithAll> _parentsWithAll = [];

    var responseParents =
        await database.rawQuery("SELECT * FROM parents WHERE word_id=$id");
    var parents = responseParents.isNotEmpty
        ? List<ParentsModel>.from(
            responseParents.map((e) => ParentsModel.fromJson(e)))
        : [];

    for (var value in parents) {
      var responseWordUz = await database
          .rawQuery("SELECT * FROM words_uz WHERE word_id=${value.id} ");
      var wordWordUz = responseWordUz.isNotEmpty
          ? List<WordsUzModel>.from(
              responseWordUz.map((e) => WordsUzModel.fromJson(e)))
          : null;

      var responseCollocation = await database
          .rawQuery("SELECT * FROM collocation WHERE word_id=${value.id} ");
      var wordCollocation = responseCollocation.isNotEmpty
          ? List<CollocationModel>.from(
              responseCollocation.map((e) => CollocationModel.fromJson(e)))
          : null;

      var responseCulture = await database
          .rawQuery("SELECT * FROM culture WHERE word_id=${value.id}");
      var wordCulture = responseCulture.isNotEmpty
          ? List<CultureModel>.from(
              responseCulture.map((e) => CultureModel.fromJson(e)))
          : null;

      var responseDifference = await database
          .rawQuery("SELECT * FROM difference WHERE word_id=${value.id} ");
      var wordDifference = responseDifference.isNotEmpty
          ? List<DifferenceModel>.from(
              responseDifference.map((e) => DifferenceModel.fromJson(e)))
          : null;

      var responseGrammar = await database
          .rawQuery("SELECT * FROM grammar WHERE word_id=${value.id} ");
      var wordGrammar = responseGrammar.isNotEmpty
          ? List<GrammarModel>.from(
              responseGrammar.map((e) => GrammarModel.fromJson(e)))
          : null;

      var responseMetaphor = await database
          .rawQuery("SELECT * FROM metaphor WHERE word_id=${value.id} ");
      var wordMetaphor = responseMetaphor.isNotEmpty
          ? List<MetaphorModel>.from(
              responseMetaphor.map((e) => MetaphorModel.fromJson(e)))
          : null;

      var responseThesaurus = await database
          .rawQuery("SELECT * FROM thesaurus WHERE word_id=${value.id} ");
      var wordThesaurus = responseThesaurus.isNotEmpty
          ? List<ThesaurusModel>.from(
              responseThesaurus.map((e) => ThesaurusModel.fromJson(e)))
          : null;

      var phrasesWithAll = await getPhrasesAll(value.id);

      _parentsWithAll.add(
        ParentsWithAll(
            value,
            wordWordUz,
            wordCollocation,
            wordCulture,
            wordDifference,
            wordGrammar,
            wordMetaphor,
            wordThesaurus,
            phrasesWithAll),
      );
    }

    return _parentsWithAll;
  }

  Future<List<WordModel>?> searchByWord(String word) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT we.id,we.word,we.word_classid,we.word_classword_id,we.word_classword_class, we.star, group_concat(wu.word) as body FROM word_entity we LEFT JOIN words_uz wu ON we.id=wu.word_id WHERE we.word LIKE '${word.replaceAll("'", "''")}%' GROUP BY we.id ORDER BY we.word COLLATE NOCASE ASC LIMIT 40");
        // "SELECT id,word,word_classid,word_classword_id,word_classword_class, star FROM word_entity WHERE word LIKE '${word.replaceAll("'", "''")}%' ORDER BY word COLLATE NOCASE ASC LIMIT 40");
        var words =
            List<WordModel>.from(response.map((e) => WordModel.fromJson(e)));
        return words;
      }
    } catch (e) {
      log("searchByWord", error: e.toString());
    }
    return null;
  }

  Future<List<WordAndPhrasesModel>?> searchByPhrases(String search) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            // "SELECT id,word_classid,word_classword_id,word_classword_class,p_word, p_star as star FROM word_entity INNER JOIN phrases ON id=p_word_id AND p_word LIKE '${search.replaceAll("'", "''")}%' ORDER BY word COLLATE NOCASE asc limit 40");
            "SELECT we.id,we.word_classid,we.word_classword_id,we.word_classword_class, ph.p_word, ph.p_star as star, group_concat(pt.word) as body FROM word_entity we LEFT JOIN phrases ph ON we.id=ph.p_word_id INNER JOIN phrases_translate pt ON ph.p_id=pt.phrase_id AND ph.p_word LIKE '${search.replaceAll("'", "''")}%' GROUP BY we.id ORDER BY we.word COLLATE NOCASE asc limit 40");
        var wordWithPhrases = List<WordAndPhrasesModel>.from(
            response.map((e) => WordAndPhrasesModel.fromJson(e)));
        return wordWithPhrases;
      }
    } catch (e) {
      log("searchByPhrases", error: e.toString());
    }
    return null;
  }

  Future<List<WordAndParentsAndPhrasesModel>?> searchByWordParent1(
      String parents) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            // "SELECT w.id,w.word_classid,w.word_classword_id,w.word_classword_class,ph.p_word, ph.p_star as star, wu.word FROM word_entity w INNER JOIN parents p ON w.id=p.word_id INNER JOIN phrases ph ON p.id=ph.p_word_id INNER JOIN words_uz wu ON w.word_classword_id=wu.word_id AND ph.p_word LIKE '${parents.replaceAll("'", "''")}%' GROUP BY w.id ORDER BY ph.p_word COLLATE NOCASE asc limit 40");
            "SELECT w.id,w.word_classid,w.word_classword_id,w.word_classword_class,ph.p_word, ph.p_star as star, group_concat(pt.word) as word FROM word_entity w LEFT JOIN parents p ON w.id=p.word_id INNER JOIN phrases ph ON p.id=ph.p_word_id INNER JOIN phrases_translate pt ON ph.p_id=pt.phrase_id AND ph.p_word LIKE '${parents.replaceAll("'", "''")}%' GROUP BY ph.p_word ORDER BY ph.p_word COLLATE NOCASE asc limit 40");
        var wordsAndParentsAndWordsUzModel =
            List<WordAndParentsAndPhrasesModel>.from(
                response.map((e) => WordAndParentsAndPhrasesModel.fromJson(e)));
        return wordsAndParentsAndWordsUzModel;
      }
    } catch (e) {
      log("searchByWordParent1", error: e.toString());
    }
    return null;
  }

  Future<List<WordAndParentsAndWordsUzModel>?> searchByWordParent2(
      String parents) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT w.id,w.word as word_class,p.star,wu.word as word FROM word_entity w INNER JOIN parents p ON w.id=p.word_id INNER JOIN words_uz wu ON p.id=wu.word_id AND wu.word LIKE '${parents.replaceAll("'", "''")}%' order by w.word COLLATE NOCASE asc limit 40");
        var wordsAndParentsAndWordsUzModel =
            List<WordAndParentsAndWordsUzModel>.from(
                response.map((e) => WordAndParentsAndWordsUzModel.fromJson(e)));
        return wordsAndParentsAndWordsUzModel;
      }
    } catch (e) {
      log("searchByWordParent2", error: e.toString());
    }
    return null;
  }

  Future<List<WordAndParentsAndPhrasesAndTranslateModel>?> searchByWordParent3(
      String parents) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT w.id,ph.p_word as word_class,ph.p_star,pt.word as word FROM word_entity w INNER JOIN parents p ON w.id=p.word_id INNER JOIN phrases ph ON p.id=ph.p_word_id INNER JOIN phrases_translate pt ON ph.p_id=pt.phrase_id AND pt.word LIKE '${parents.replaceAll("'", "''")}%' order by w.word COLLATE NOCASE asc limit 40");
        var wordsAndParentsAndWordsUzModel =
            List<WordAndParentsAndPhrasesAndTranslateModel>.from(response.map(
                (e) => WordAndParentsAndPhrasesAndTranslateModel.fromJson(e)));
        return wordsAndParentsAndWordsUzModel;
      }
    } catch (e) {
      log("searchByWordParent3", error: e.toString());
    }
    return null;
  }

  Future<List<WordAndParentsAndPhrasesParentPhrasesAndTranslateModel>?>
      searchWordAndParentsAndPhrasesParentPhrasesAndTranslate(
          String parents) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT w.id,w.word as word_class,p_ph.star,ppt.word as word FROM word_entity w INNER JOIN parents p ON w.id=p.word_id INNER JOIN phrases ph ON p.id=ph.p_word_id INNER JOIN parent_phrases p_ph ON ph.p_id=p_ph.phrase_id INNER JOIN parent_phrases_translate ppt ON p_ph.id=ppt.parent_phrase_id AND ppt.word LIKE '${parents.replaceAll("'", "''")}%' order by  w.word COLLATE NOCASE asc limit 40");
        var wordAndParentsAndPhrasesParentPhrasesAndTranslateModel =
            List<WordAndParentsAndPhrasesParentPhrasesAndTranslateModel>.from(
                response.map((e) =>
                    WordAndParentsAndPhrasesParentPhrasesAndTranslateModel
                        .fromJson(e)));
        return wordAndParentsAndPhrasesParentPhrasesAndTranslateModel;
      }
    } catch (e) {
      log("searchWordAndParentsAndPhrasesParentPhrasesAndTranslate",
          error: e.toString());
    }
    return null;
  }

  Future<List<SearchResultUzModel>?> searchByWordUz1(String word) async {
    try {
      if (database.isOpen) {
        var queryWord = word.replaceAll("'", "''");
        if (Platform.isIOS) {
          queryWord = word.replaceAll("’", "''");
        }
        var response = await database.rawQuery('''SELECT
  words_uz.word_id AS id,
  ftword.word AS word,
  word_entity.word AS word_class,
  word_entity.star AS star,
  group_concat(words_uz.word) AS same,
  'word' as type
FROM
  words_uz
INNER JOIN (
  SELECT DISTINCT
    (word_id),
    word
  FROM
    words_uz
  WHERE
    word LIKE '$queryWord%'
) AS ftword ON ftword.word_id = words_uz.word_id
INNER JOIN word_entity ON words_uz.word_id = word_entity.id
GROUP BY
  words_uz.word_id --wordsuz 
UNION
  -- parent
  SELECT
    parents.word_id AS id,
    ftword.word AS word,
    parents.word AS word_class,
    parents.star AS star,
    group_concat(words_uz.word) AS same,
    'word' as type
  FROM
    words_uz
  INNER JOIN (
    SELECT DISTINCT
      (word_id),
      word
    FROM
      words_uz
    WHERE
      word LIKE '$queryWord%'
  ) AS ftword ON ftword.word_id = words_uz.word_id
  INNER JOIN parents ON words_uz.word_id = parents.id
  GROUP BY
    words_uz.word_id -- parent 
  UNION
    SELECT
      parents.word_id AS id,
      ftword.word AS word,
      phrases.p_word AS word_class,
      phrases.p_star AS star,
      group_concat(phrases_translate.word) AS same,
      'phrases' as type
    FROM
      phrases_translate
    INNER JOIN (
      SELECT DISTINCT
        (phrase_id),
        word
      FROM
        phrases_translate
      WHERE
        word LIKE '$queryWord%'
    ) AS ftword ON ftword.phrase_id = phrases_translate.phrase_id
    INNER JOIN phrases ON phrases_translate.phrase_id = phrases.p_id
    INNER JOIN parents ON parents.id=phrases.p_word_id
    GROUP BY
      phrases_translate.phrase_id -- phrases translate
    UNION
      SELECT
        parents.word_id AS id,
        ftword.word AS word,
        phrases.p_word AS word_class,
        parent_phrases.star AS star,
        group_concat(
          parent_phrases_translate.word
        ) AS same,
        'phrases' as type
      FROM
        parent_phrases_translate
      INNER JOIN (
        SELECT DISTINCT
          (parent_phrase_id),
          word
        FROM
          parent_phrases_translate
        WHERE
          word LIKE '$queryWord%'
      ) AS ftword ON ftword.parent_phrase_id = parent_phrases_translate.parent_phrase_id
      INNER JOIN parent_phrases ON parent_phrases.id = parent_phrases_translate.parent_phrase_id
      INNER JOIN phrases ON phrases.p_id = parent_phrases.phrase_id
      INNER JOIN parents ON parents.id=phrases.p_word_id 
      GROUP BY
        parent_phrases_translate.parent_phrase_id
      ORDER BY
        star DESC LIMIT 40''');
        var wordAndWordsUzModel = List<SearchResultUzModel>.from(
            response.map((e) => SearchResultUzModel.fromJson(e)));
        return wordAndWordsUzModel;
      }
    } catch (e) {
      log("searchByWordUz1", error: e.toString());
    }
    return null;
  }

  Future<List<WordAndPhrasesAndTranslateModel>?> searchByPhrasesUz1(
      String phrases) async {
    try {
      if (database.isOpen) {
        var response = await database.rawQuery(
            "SELECT w.id,w.word as word_class,p.p_star,pt.word as word FROM word_entity w INNER JOIN phrases p ON w.id=p.p_word_id INNER JOIN phrases_translate pt ON p.p_id=pt.phrase_id AND p.p_word LIKE '${phrases.replaceAll("'", "''")}%' order by w.word COLLATE NOCASE asc,w.star desc limit 40");
        var wordAndPhrasesAndTranslateModel =
            List<WordAndPhrasesAndTranslateModel>.from(response
                .map((e) => WordAndPhrasesAndTranslateModel.fromJson(e)));
        return wordAndPhrasesAndTranslateModel;
      }
    } catch (e) {
      log("searchByPhrasesUz1", error: e.toString());
    }
    return null;
  }

  Future<List<WordBankModel>?> getWordBankList(int? folderId) async {
    try {
      if (database.isOpen) {
        var filter = '';
        if (folderId != null) filter = "WHERE folder_id='$folderId'";
        var response = await database.rawQuery(
            "SELECT * from word_bank $filter ORDER BY created_at DESC");
        var wordBankList = List<WordBankModel>.from(
            response.map((e) => WordBankModel.fromJson(e)));
        return wordBankList;
      }
    } catch (e) {
      log("getWordBankList", error: e.toString());
    }
    return null;
  }

  Future<List<WordBankFolderModel>?> getWordBankFolderList() async {
    try {
      if (database.isOpen) {
        var response = await database
            .rawQuery("select * from folders order by is_default desc");
        var wordBankFolderList = List<WordBankFolderModel>.from(
            response.map((e) => WordBankFolderModel.fromJson(e)));
        return wordBankFolderList;
      }
    } catch (e) {
      log("getWordBankFolderList", error: e.toString());
    }
    return null;
  }

  Future<List<WordBankFolderModel>?> deleteWordBankFolderList(
      int folderId) async {
    try {
      if (database.isOpen) {
        await database
            .delete('folders', where: "id = ?", whereArgs: [folderId]);
      }
    } catch (e) {
      log("deleteWordBankFolderList", error: e.toString());
    }
    return null;
  }

  Future<int?> saveToWordBank(WordBankModel wordBankModel) async {
    try {
      if (database.isOpen) {
        var id = await database.insert(
          tableWordBank,
          wordBankModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return id;
      }
    } catch (e) {
      log("saveToWordBank", error: e.toString());
    }
    return null;
  }

  Future<bool> moveToFolder(
      {required int folderId,
      required int tableId,
      required int? wordId}) async {
    try {
      if (database.isOpen) {
        var all = await getWordBankList(folderId);
        var same = all != null
            ? all.where((element) => element.id == wordId).length
            : 0;
        if (same == 0) {
          await database.update(tableWordBank, {'folder_id': folderId},
              where: 'tableId = ?',
              whereArgs: [tableId],
              conflictAlgorithm: ConflictAlgorithm.fail);
          return true;
        }
        return false;
      }
    } catch (e) {
      log("saveToWordBank", error: e.toString());
    }
    return false;
  }

  Future<int?> saveToWordBankFolder(String folderName, int id) async {
    try {
      if (database.isOpen) {
        var newId = await database.insert(
            tableWordBankFolder,
            {
              'id': id,
              'folder_name': folderName,
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
        return newId;
      }
    } catch (e) {
      log("saveToWordBank", error: e.toString());
    }
    return null;
  }

  Future<List<WordBankModel>> getWordBankCount() async {
    try {
      var response = await database.rawQuery("SELECT * FROM $tableWordBank");
      var wordBankList = List<WordBankModel>.from(
          response.map((e) => WordBankModel.fromJson(e)));
      return wordBankList;
    } catch (e) {
      log("saveToWordBank", error: e.toString());
    }
    return [];
  }

  Future<void> deleteAllWordBank() async {
    try {
      if (database.isOpen) {
        await database.delete(tableWordBank);
      }
    } catch (e) {
      log("deleteAllWordBank", error: e.toString());
    }
  }

  Future deleteAllWordBankFolder() async {
    try {
      if (database.isOpen) {
        await database.delete(tableWordBankFolder);
      }
    } catch (e) {
      log("deleteAllWordBankFolder", error: e.toString());
    }
  }

  Future<int> getWordbankCount() async {
    try {
      if (database.isOpen) {
        final data = await database.rawQuery('select count(*) from word_bank');
        return data.first.values.first as int;
      }
    } catch (e) {
      log('');
    }
    return 0;
  }

  Future saveWordBankFolderList(
      List<WordBankFolderModel> wordBankFolderList) async {
    try {
      if (database.isOpen) {
        for (var element in wordBankFolderList) {
          await database.insert(
            tableWordBankFolder,
            element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
      log("saveWordBankFolderList", error: e.toString());
    }
  }

  Future saveWordBankList(List<WordBankModel> wordBankList) async {
    try {
      if (database.isOpen) {
        for (var element in wordBankList) {
          await database.insert(
            tableWordBank,
            element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
      log("saveWordBankList", error: e.toString());
    }
  }

  Future<void> deleteWordBank(int id) async {
    try {
      if (database.isOpen) {
        await database
            .delete(tableWordBank, where: "tableId = ?", whereArgs: [id]);
      }
    } catch (e) {
      log("deleteWordBank", error: e.toString());
    }
  }

  Future<void> deleteWordBankByFolder(int folderId) async {
    try {
      if (database.isOpen) {
        await database.delete(tableWordBank,
            where: "folder_id = ?", whereArgs: [folderId]);
      }
    } catch (e) {
      log("deleteWordBankByFolder", error: e.toString());
    }
  }

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Future<List<String>> getRelateWords(int id, String searchText) async {
    try {
      List<String> all = [];
      if (database.isOpen) {
        List<String> responseWordUz = await wordsUz(id, searchText);
        List<String> parentWithAll =
            await getParentsWithAllTranslate(id, searchText);
        List<String> phrasesWithAll =
            await getPhrasesAllTranslate(id, searchText);
        all.addAll(responseWordUz);
        all.addAll(phrasesWithAll);
        all.addAll(parentWithAll);
        return all;
      }
    } catch (e) {
      log("getRelateWords", error: e.toString());
    }
    return [];
  }

  Future<List<String>> wordsUz(int id, String searchText) async {
    try {
      var responseWordUz = await database
          .rawQuery("SELECT word FROM words_uz WHERE word_id=$id");
      List<String> wordWordUz = responseWordUz.isNotEmpty
          ? List<String>.from(
              responseWordUz.map((e) => WordsUzModel.fromJson(e).word ?? ""))
          : [];
      if (wordWordUz.toString().contains(searchText)) {
        return wordWordUz;
      }
    } catch (e) {
      log("wordsUz", error: e.toString());
    }
    return [];
  }

  Future<List<String>> getPhrasesAllTranslate(
      int? id, String searchText) async {
    List<String> wordsUzAll = [];

    var responsePhrases =
        await database.rawQuery("SELECT * FROM phrases WHERE p_word_id=$id");
    var phrases = responsePhrases.isNotEmpty
        ? List<PhrasesModel>.from(
            responsePhrases.map((e) => PhrasesModel.fromJson(e)))
        : [];

    for (var element in phrases) {
      var responsePhrasesTranslate = await database.rawQuery(
          "SELECT word FROM phrases_translate WHERE phrase_id=${element.pId}");
      List<String> wordsUz = responsePhrasesTranslate.isNotEmpty
          ? List<String>.from(responsePhrasesTranslate
              .map((e) => PhrasesTranslateModel.fromJson(e).word ?? ""))
          : [];
      if (wordsUz.toString().contains(searchText)) {
        wordsUzAll.addAll(wordsUz);
      }
    }
    return wordsUzAll;
  }

  Future<List<String>> getParentsWithAllTranslate(
      int? id, String searchText) async {
    List<String> translations = [];

    var responseParents =
        await database.rawQuery("SELECT * FROM parents WHERE word_id=$id");
    var parents = responseParents.isNotEmpty
        ? List<ParentsModel>.from(
            responseParents.map((e) => ParentsModel.fromJson(e)))
        : [];

    for (var value in parents) {
      var responseWordUz = await database
          .rawQuery("SELECT * FROM words_uz WHERE word_id=${value.id}");
      List<String> wordWordUz = responseWordUz.isNotEmpty
          ? List<String>.from(
              responseWordUz.map((e) => WordsUzModel.fromJson(e).word))
          : [];
      var phrasesWithAll = await getPhrasesAllTranslate(value.id, searchText);

      if (wordWordUz.toString().contains(searchText)) {
        translations.addAll(wordWordUz);
      }
      translations.addAll(phrasesWithAll);
    }
    return translations;
  }
}
