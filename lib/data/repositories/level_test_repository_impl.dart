import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/test_answer_response_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';

class LevelTestRepositoryImpl extends LevelTestRepository {
  LevelTestRepositoryImpl(this.dbHelper, this.customClient)
      : _exerciseType = TestExerciseType.levelExercise;

  final DBHelper dbHelper;
  final CustomClient customClient;

  LevelModel? _selectedLevel;
  LevelWordModel? selectedLevelWord;
  TestExerciseType _exerciseType;

  //test-question
  List<TestQuestionModel> _testQuestionsList = [];
  List<TestQuestionModel> _testQuestionsResultList = [];
  LevelExerciseResultModel? _resultModel;
  int _levelExerciseId = 0, _wordTestId = 0, _totalQuestions = 0, _correctAnswers = 0;
  String _startDate = "", _endDate = "";
  bool _pass = false;

  @override
  void setExerciseType(TestExerciseType type) {
    _exerciseType = type;
  }

  @override
  void setSelectedLevelMord(LevelWordModel item) {
    selectedLevelWord = item;
  }

  @override
  void setSelectedLevel(LevelModel item) {
    _selectedLevel = item;
  }

  @override
  Future<void> getTestQuestions() async {
    _startDate = "";
    _endDate = "";
    _testQuestionsList = [];
    var response = await customClient.get(Urls.testQuestions(_selectedLevel!.id!));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _testQuestionsList.add(TestQuestionModel.fromMap(item));
      }

      _endDate = responseData["end_date"];
      _startDate = responseData["start_date"];
      _levelExerciseId = responseData["level_exercise_id"];
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> getTest100Questions() async {
    _startDate = "";
    _endDate = "";
    _testQuestionsList = [];
    var response = await customClient.get(Urls.test100Questions(_selectedLevel!.id!));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _testQuestionsList.add(TestQuestionModel.fromMap(item));
      }

      _endDate = responseData["end_date"];
      _startDate = responseData["start_date"];
      _levelExerciseId = responseData["hundreds_test_id"];
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> getWordQuestions() async {
    _startDate = "";
    _endDate = "";
    _testQuestionsList = [];
    var response = await customClient.get(Urls.wordQuestions(selectedLevelWord!.wordId!));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _testQuestionsList.add(TestQuestionModel.fromMap(item));
      }
      _wordTestId = responseData['word_test_id'];
    } else {
      throw VMException(response.body, callFuncName: 'getWordQuestions', response: response);
    }
  }

  @override
  Future<void> postWordQuestionsCheck(List<AnswerEntity> answers) async {
    _resultModel = null;

    final requestBody = {
      'word_test_id': "$_wordTestId",
      'answers': answers
          .map(
            (e) => e.toMap(),
          )
          .toList()
    };
    var response = await customClient.post(Urls.wordQuestionsCheck(selectedLevelWord!.wordId!),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      _resultModel = LevelExerciseResultModel.fromMap(responseData);
    } else {
      throw VMException(response.body, callFuncName: 'postWordQuestionsCheck', response: response);
    }
  }

  @override
  Future<void> postTestQuestionsCheck(List<AnswerEntity> answers, int timeTaken) async {
    _resultModel = null;

    final requestBody = {
      'level_exercise_id': _levelExerciseId,
      'time_taken': timeTaken,
      'answers': answers
          .map(
            (e) => e.toMap(),
          )
          .toList()
    };
    var response = await customClient.post(Urls.testQuestionsCheck,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      _resultModel = LevelExerciseResultModel.fromMap(responseData);
    } else {
      throw VMException(response.body, callFuncName: 'postWordQuestionsCheck', response: response);
    }
  }

  @override
  Future<void> postTest100QuestionsCheck(List<AnswerEntity> answers, int timeTaken) async {
    _resultModel = null;

    final requestBody = {
      'hundreds_test_id': _levelExerciseId,
      'time_taken': timeTaken,
      'answers': answers
          .map(
            (e) => e.toMap(),
          )
          .toList()
    };
    var response = await customClient.post(Urls.test100QuestionsCheck,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      _resultModel = LevelExerciseResultModel.fromMap(responseData);
    } else {
      throw VMException(response.body, callFuncName: 'postWordQuestionsCheck', response: response);
    }
  }

  @override
  Future<void> postTestQuestionsResult() async {
    _testQuestionsResultList = [];
    final requestBody = {
      'level_exercise_id': _levelExerciseId,
    };
    var response = await customClient.post(Urls.testQuestionsResult,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _testQuestionsResultList.add(TestQuestionModel.fromMap(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> postTest100QuestionsResult() async {
    _testQuestionsResultList = [];
    final requestBody = {
      'hundreds_test_id': _levelExerciseId,
    };
    var response = await customClient.post(Urls.test100QuestionsResult,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _testQuestionsResultList.add(TestQuestionModel.fromMap(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> postWordQuestionsResult() async {
    _testQuestionsResultList = [];
    final requestBody = {
      'word_test_id': _wordTestId,
    };
    var response = await customClient.post(Urls.wordQuestionsResult(selectedLevelWord!.wordId!),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _testQuestionsResultList.add(TestQuestionModel.fromMap(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestionsResult', response: response);
    }
  }

  @override
  List<TestQuestionModel> get testQuestionsList => _testQuestionsList;

  @override
  String get endDate => _endDate;

  @override
  int get levelExerciseId => _levelExerciseId;

  @override
  String get startDate => _startDate;

  @override
  LevelExerciseResultModel? get resultModel => _resultModel;

  @override
  int get correctAnswers => _correctAnswers;

  @override
  bool get pass => _pass;

  @override
  int get totalQuestions => _totalQuestions;

  @override
  TestExerciseType get exerciseType => _exerciseType;

  @override
  List<TestQuestionModel> get testQuestionsResultList => _testQuestionsResultList;

  @override
  LevelModel get selectedLevelItem => _selectedLevel!;

  @override
  Future<String?> postCancelTest() async {
    final requestBody = {
      'level_exercise_id': _levelExerciseId,
    };
    var response = await customClient.post(Urls.cancelLevelTest(_selectedLevel!.id!),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (response.isSuccessful) {
      final responseBody = jsonDecode(response.body);

      return responseBody["message"];
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestionsResult', response: response);
    }
  }
}
