import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/ranking_model.dart';
import 'package:wisdom/domain/repositories/ranking_repository.dart';

class RankingRepositoryImpl extends RankingRepository {
  RankingRepositoryImpl(this.customClient);

  final CustomClient customClient;

  List<RankingModel> _rankingGlobalList = [];
  bool _hasMoreData = true;
  int _userCurrentLevel = 0, _userRanking = 0;

  // getting levels from host
  @override
  Future<void> getRankingGlobal(int page) async {
    if (page == 1) {
      _rankingGlobalList = [];
    }
    var response = await customClient.get(
      Uri.https(Urls.baseAddress, "/api/rankings/global", {"per_page": "100", "page": "$page"}),
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      _hasMoreData = (responseData['data'] as List).isNotEmpty;
      for (var item in responseData['data']) {
        _rankingGlobalList.add(RankingModel.fromJson(item));
      }
      _userCurrentLevel = responseData['you']['user_current_level'];
      _userRanking = responseData['you']['ranking'];
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  List<RankingModel> get rankingGlobalList => _rankingGlobalList;

  @override
  bool get hasMoreData => _hasMoreData;

  @override
  int get userCurrentLevel => _userCurrentLevel;

  @override
  int get userRanking => _userRanking;
}
