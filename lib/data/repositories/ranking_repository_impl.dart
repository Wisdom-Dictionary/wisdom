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

  // getting levels from host
  @override
  Future<void> getRankingGlobal() async {
    _rankingGlobalList = [];
    var response = await customClient.get(
      Uri.https(Urls.baseAddress, "/api/rankings/global", {"per_page": "100", "page": "1"}),
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      for (var item in responseData['data']) {
        _rankingGlobalList.add(RankingModel.fromJson(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  List<RankingModel> get rankingGlobalList => _rankingGlobalList;
}
