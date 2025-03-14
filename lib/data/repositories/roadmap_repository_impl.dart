import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';

class RoadmapRepositoryImpl extends RoadmapRepository {
  RoadmapRepositoryImpl(this.dbHelper, this.customClient);

  final DBHelper dbHelper;
  final CustomClient customClient;

  List<LevelWordModel> _levelWordsList = [];
  List<LevelModel> _levelsList = [];
  int _userCurrentLevel = 0;
  RankModel? _userRank;
  LevelModel? selectedLevel;

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
      // _levelsList = [
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      //   ..._levelsList,
      // ];
      _userCurrentLevel = responseData['user_current_level'] ?? 0;
      if (responseData['rank'] != null) {
        _userRank = RankModel.fromJson(responseData['rank']);
      }
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  Future<void> getLevelWords() async {
    _levelWordsList = [];
    var response = await customClient.get(
      Urls.levelWords(selectedLevel!.id!),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
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
  void setSelectedLevel(LevelModel item) {
    selectedLevel = item;
  }

  @override
  List<LevelModel> get levelsList => _levelsList;

  @override
  List<LevelWordModel> get levelWordsList => _levelWordsList;

  @override
  int get userCurrentLevel => _userCurrentLevel;

  @override
  RankModel? get userRank => _userRank;
}
