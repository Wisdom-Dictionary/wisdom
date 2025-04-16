import 'dart:convert';
import 'dart:developer';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/contacts_service.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/ranking_model.dart';
import 'package:wisdom/domain/repositories/ranking_repository.dart';

class RankingRepositoryImpl extends RankingRepository {
  RankingRepositoryImpl(this.customClient, this.preferenceHelper);

  final CustomClient customClient;
  final SharedPreferenceHelper preferenceHelper;
  List<RankingModel> _rankingGlobalList = [];
  List<RankingModel> _rankingContactList = [];
  bool _hasMoreGlobalRankingData = true, _hasMoreContactRankingData = true;
  int _userCurrentGlobalLevel = 0,
      _userGlobalRanking = 0,
      _userCurrentContactLevel = 0,
      _userContactRanking = 0;

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
      _hasMoreGlobalRankingData = (responseData['data'] as List).isNotEmpty;
      for (var item in responseData['data']) {
        _rankingGlobalList.add(RankingModel.fromJson(item));
      }
      _userCurrentGlobalLevel = responseData['you']['user_current_level'];
      _userGlobalRanking = responseData['you']['ranking'];
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  List<RankingModel> get rankingGlobalList => _rankingGlobalList;

  @override
  bool get hasMoreGlobalRankingData => _hasMoreGlobalRankingData;

  @override
  bool get hasMoreContactRankingData => _hasMoreContactRankingData;

  @override
  int get userCurrentGlobalLevel => _userCurrentGlobalLevel;

  @override
  int get userGlobalRanking => _userGlobalRanking;

  @override
  Future<void> getRankingContacts(int page) async {
    final requestBody = {
      "limit": "25",
      "page": "$page",
      'contacts': await CustomContactService.pickContact(),
    };

    var response = await customClient.post(
        Uri.https(
          Urls.baseAddress,
          "/api/rankings/contacts",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      _hasMoreContactRankingData = (responseData['data'] as List).isNotEmpty;
      log(response.body);
      preferenceHelper.putString(
        Constants.KEY_EXERCISE_RESULTS_CONTACTS_DATA,
        response.body,
      );
      if (page == 1) {
        _rankingContactList = [];
      }
      for (var item in responseData['data']) {
        _rankingContactList.add(RankingModel.fromJson(item));
      }
      _userCurrentContactLevel = responseData['you']['user_current_level'];
      _userContactRanking = responseData['you']['ranking'];
    } else {
      throw VMException(response.body, callFuncName: 'getLevels', response: response);
    }
  }

  @override
  List<RankingModel> get rankingContactList => _rankingContactList;

  @override
  int get userContactRanking => _userContactRanking;

  @override
  int get userCurrentContactLevel => _userCurrentContactLevel;

  @override
  Future<void> getRankingContactsFromCache() async {
    _rankingContactList = [];
    String data = preferenceHelper.getString(Constants.KEY_EXERCISE_RESULTS_CONTACTS_DATA, "");
    if (data.isNotEmpty) {
      final contactsData = jsonDecode(data);
      for (var item in contactsData['data']) {
        _rankingContactList.add(RankingModel.fromJson(item));
      }
    }
  }
}
