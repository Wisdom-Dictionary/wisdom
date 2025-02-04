import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';

class RoadmapRepositoryImpl extends RoadmapRepository {
  RoadmapRepositoryImpl(this.dbHelper, this.customClient);

  final DBHelper dbHelper;
  final CustomClient customClient;

  List<TestQuestionModel> _testQuestionsList = [];
  List<LevelWordModel> _levelWordsList = [];
  List<LevelModel> _levelsList = [];
  int _userCurrentLevel = 0;

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
    for (var item in sampleLevelWordsResponse['words'] as List) {
      _levelWordsList.add(LevelWordModel.fromMap(item));
    }
  }

  @override
  Future<void> getTestQuestions() async {
    _testQuestionsList = [];
    for (var item in sampleTestResponse['questions'] as List) {
      _testQuestionsList.add(TestQuestionModel.fromMap(item));
    }
    // var response = await get(Urls.testQuestions);
    // if (response.statusCode == 200) {
    //   if (response.isSuccessful) {
    //     for (var item in jsonDecode(response.body)['questions']) {
    //       items.add(TestQuestionModel.fromJson(item));
    //     }
    //   }
    // return items;
    // } else {
    //   throw VMException(response.body,
    //       callFuncName: 'getTestQuestions', response: response);
    // }
  }

  @override
  List<LevelModel> get levelsList => _levelsList;

  @override
  List<TestQuestionModel> get testQuestionsList => _testQuestionsList;

  static const sampleLevelWordsResponse = {
    "id": 1,
    "name": "20",
    "canStartExercise": false,
    "words": [
      {
        "id": 599,
        "position": 1,
        "word_id": 52,
        "word": "A",
        "word_class": "noun",
        "is_learnt": false
      },
      {
        "id": 600,
        "position": 2,
        "word_id": 3295,
        "word": "akimbo",
        "word_class": "adverb",
        "is_learnt": false
      },
      {
        "id": 601,
        "position": 3,
        "word_id": 2362,
        "word": "beg",
        "word_class": "verb",
        "is_learnt": false
      },
      {
        "id": 602,
        "position": 4,
        "word_id": 28158,
        "word": "forcible",
        "word_class": "adjective",
        "is_learnt": false
      }
    ]
  };

  static const sampleLevelsResponse = {
    "data": [
      {"id": 1, "name": "20", "star": 3, "status": "published", "position": 1},
      {"id": 3, "name": "60", "star": 0, "status": "published", "position": 3},
      {"id": 4, "name": "80", "star": 0, "status": "published", "position": 4},
      {"id": 5, "name": "100", "star": 0, "status": "published", "position": 12}
    ],
    "links": {
      "first": "http://localhost:9007/api/levels?page=1",
      "last": "http://localhost:9007/api/levels?page=1",
      "prev": null,
      "next": null
    },
    "meta": {
      "current_page": 1,
      "from": 1,
      "last_page": 1,
      "links": [
        {"url": null, "label": "&laquo; Previous", "active": false},
        {"url": "http://localhost:9007/api/levels?page=1", "label": "1", "active": true},
        {"url": null, "label": "Next &raquo;", "active": false}
      ],
      "path": "http://localhost:9007/api/levels",
      "per_page": 20,
      "to": 4,
      "total": 4
    }
  };

  static const sampleTestResponse = {
    "count": 8,
    "questions": [
      {
        "id": 14,
        "body": "a+b",
        "position": 0,
        "answers": [
          {"id": 35, "body": "as"},
          {"id": 36, "body": "ab"}
        ]
      },
      {
        "id": 11,
        "body": "a mi?",
        "position": 0,
        "answers": [
          {"id": 29, "body": "a a"},
          {"id": 30, "body": "b"}
        ]
      },
      {
        "id": 12,
        "body": "s",
        "position": 0,
        "answers": [
          {"id": 31, "body": "d"},
          {"id": 32, "body": "g"}
        ]
      },
      {
        "id": 8,
        "body": "kim?",
        "position": 0,
        "answers": [
          {"id": 22, "body": "men"},
          {"id": 23, "body": "u"},
          {"id": 24, "body": "siz"}
        ]
      },
      {
        "id": 9,
        "body": "qaysi javob?",
        "position": 0,
        "answers": [
          {"id": 25, "body": "a"},
          {"id": 26, "body": "b"}
        ]
      },
      {
        "id": 1,
        "body": "Are you ___ student?",
        "position": 1,
        "answers": [
          {"id": 1, "body": "a"},
          {"id": 2, "body": "an"},
          {"id": 3, "body": "the"},
          {"id": 14, "body": "dddd"}
        ]
      },
      {
        "id": 2,
        "body": "I ___ a student.",
        "position": 2,
        "answers": [
          {"id": 5, "body": "am"},
          {"id": 6, "body": "is"},
          {"id": 7, "body": "are"},
          {"id": 8, "body": "be"}
        ]
      },
      {
        "id": 3,
        "body": "She ___ a teacher.",
        "position": 3,
        "answers": [
          {"id": 9, "body": "is"},
          {"id": 10, "body": "am"},
          {"id": 11, "body": "are"},
          {"id": 12, "body": "be"}
        ]
      }
    ]
  };

  @override
  List<LevelWordModel> get levelWordsList => _levelWordsList;

  @override
  int get userCurrentLevel => _userCurrentLevel;
}
