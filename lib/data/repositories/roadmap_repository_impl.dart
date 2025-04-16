import 'dart:convert';
import 'dart:developer';

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
  int _userCurrentLevel = 0, _bottomLastPage = 0, _topLastPage = 0;
  RankModel? _userRank;
  LevelModel? selectedLevel;
  bool _canMoreLoad = true, _canMoreLoadBottom = true, _canMoreLoadTop = true;

  // getting levels from host
  @override
  Future<void> getLevels() async {
    _levelsList = [];
    var response = await customClient.get(
      Uri.https(Urls.baseAddress, "/api/levels", {"limit": "16"}),
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      _canMoreLoad = (responseData['levels'] as List).isNotEmpty;

      for (var item in responseData['levels']) {
        _levelsList.add(LevelModel.fromMap(item));
      }
      log("limit: 16 = ${_levelsList.length}");
      _userCurrentLevel = responseData['user_current_level'] ?? 0;
      int currentPage = responseData['current_page'] ?? 0;
      _bottomLastPage = currentPage;
      _topLastPage = currentPage;
      _canMoreLoadBottom = _bottomLastPage > 1;
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

  @override
  bool get canMoreLoad => _canMoreLoad;

  @override
  Future<void> getLevelsPaginationBottom() async {
    var response = await customClient.get(
      Uri.https(Urls.baseAddress, "/api/levels", {"limit": "10", "page": "${_bottomLastPage - 1}"}),
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      List items = [];
      for (var item in responseData['levels']) {
        items.add(LevelModel.fromMap(item));
      }
      _levelsList = [...items, ..._levelsList];
      _userCurrentLevel = responseData['user_current_level'] ?? 0;
      _bottomLastPage = responseData['current_page'] ?? 0;
      _canMoreLoadBottom = _bottomLastPage > 1;
      if (responseData['rank'] != null) {
        _userRank = RankModel.fromJson(responseData['rank']);
      }
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  Future<void> getLevelsPaginationTop() async {
    var response = await customClient.get(
      Uri.https(Urls.baseAddress, "/api/levels", {"limit": "10", "page": "${_topLastPage + 1}"}),
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      List items = [];
      for (var item in responseData['levels']) {
        items.add(LevelModel.fromMap(item));
      }
      _levelsList = [..._levelsList, ...items];
      _userCurrentLevel = responseData['user_current_level'] ?? 0;
      _topLastPage = responseData['current_page'] ?? 0;
      _canMoreLoadTop = items.isNotEmpty;
      if (responseData['rank'] != null) {
        _userRank = RankModel.fromJson(responseData['rank']);
      }
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  bool get canMoreLoadBottom => _canMoreLoadBottom;

  @override
  bool get canMoreLoadTop => _canMoreLoadTop;

  @override
  int get bottomLastPage => _bottomLastPage;

  @override
  int get topLastPage => _topLastPage;
}
