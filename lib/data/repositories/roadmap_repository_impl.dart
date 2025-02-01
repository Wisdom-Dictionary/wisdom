import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/model/roadmap/word_answer_model.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';

class RoadmapRepositoryImpl extends RoadmapRepository {
  RoadmapRepositoryImpl(this.dbHelper, this.customClient);

  final DBHelper dbHelper;
  final CustomClient customClient;

  List<LevelWordModel> _levelWordsList = [];
  List<LevelModel> _levelsList = [];
  int _userCurrentLevel = 0;
  LevelWordModel? selectedLevelWord;

  //test-question
  List<TestQuestionModel> _testQuestionsList = [];
  List<TestQuestionModel> _wordQuestionsList = [];
  List<WordAnswerModel> _wordQuestionsCheckList = [];
  int _levelExerciseId = 0, _wordTestId = 0, _totalQuestions = 0, _correctAnswers = 0;
  String _startDate = "", _endDate = "";
  bool _pass = false;

  // getting levels from host
  @override
  Future<void> getLevels(int page) async {
    _levelsList = [];
    var response = await customClient.get(
      Uri.https(Urls.baseAddress, "/api/levels", {"page": "$page"}),
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      for (var item in responseData['levels']) {
        _levelsList.add(LevelModel.fromMap(item));
      }
      _userCurrentLevel = responseData['user_current_level'];
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  Future<void> getLevelWords() async {
    _levelWordsList = [];
    var response = await customClient.get(
      Urls.levelWords(1),
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      for (var item in responseData['words']) {
        _levelWordsList.add(LevelWordModel.fromMap(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  void setSelectedLevel(LevelWordModel item) {
    selectedLevelWord = item;
  }

  @override
  Future<void> getTestQuestions() async {
    _testQuestionsList = [];

    var response = await customClient.get(Urls.testQuestions(1));
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
  Future<void> getWordQuestions() async {
    _wordQuestionsList = [];

    var response = await customClient.get(Urls.wordQuestions(selectedLevelWord!.wordId!));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _wordQuestionsList.add(TestQuestionModel.fromMap(item));
      }
      _wordTestId = responseData['word_test_id'];
    } else {
      throw VMException(response.body, callFuncName: 'getWordQuestions', response: response);
    }
  }

  @override
  Future<void> postWordQuestionsCheck(List<AnswerEntity> answers) async {
    _wordQuestionsCheckList = [];

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
    // var response = await customClient.post(Uri.parse('https://wisdom.yangixonsaroy.uz/api/word/3295/word-questions-check'), headers: {"Accept":"application/json"}, body: requestBody );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['answers'] as List)) {
        _wordQuestionsCheckList.add(WordAnswerModel.fromMap(item));
      }
      _pass = responseData['pass'];
      _totalQuestions = responseData['total_questions'];
      _correctAnswers = responseData['correct_answers'];
    } else {
      throw VMException(response.body, callFuncName: 'postWordQuestionsCheck', response: response);
    }
  }

  static const sampleResponseWordExercisesCheck = {
    "pass": 1,
    "percentage": 100,
    "total_questions": 2,
    "correct_answers": 2,
    "answers": [
      {"question_id": 11, "answer_id": 29, "correct": true},
      {"question_id": 12, "answer_id": 31, "correct": true}
    ]
  };

  @override
  List<LevelModel> get levelsList => _levelsList;

  @override
  List<TestQuestionModel> get testQuestionsList => _testQuestionsList;

  @override
  List<TestQuestionModel> get wordQuestionsList => _wordQuestionsList;

  @override
  List<LevelWordModel> get levelWordsList => _levelWordsList;

  @override
  int get userCurrentLevel => _userCurrentLevel;

  @override
  String get endDate => _endDate;

  @override
  int get levelExerciseId => _levelExerciseId;

  @override
  String get startDate => _startDate;

  @override
  List<WordAnswerModel> get wordQuestionsCheckList => _wordQuestionsCheckList;

  @override
  int get correctAnswers => _correctAnswers;

  @override
  bool get pass => _pass;

  @override
  int get totalQuestions => _totalQuestions;
}
