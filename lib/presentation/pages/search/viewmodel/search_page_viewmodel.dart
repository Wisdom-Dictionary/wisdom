import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/recent_model.dart';
import 'package:wisdom/data/model/search_result_uz_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/search_repository.dart';

import '../../../../data/model/search_result_model.dart';

class SearchPageViewModel extends BaseViewModel {
  SearchPageViewModel({
    required super.context,
    required this.preferenceHelper,
    required this.dbHelper,
    required this.searchRepository,
    required this.localViewModel,
  });

  final SharedPreferenceHelper preferenceHelper;
  final SearchRepository searchRepository;
  final DBHelper dbHelper;
  final LocalViewModel localViewModel;
  List<RecentModel> recentList = [];
  List<RecentModel> recentListUz = [];
  String initTag = 'initTag';
  String searchTag = 'searchTag';
  String searchText = '';
  String searchLangMode = '';
  String searchLangKey = "searchLangKey";

  getSearchLanguageMode() async {
    if (searchLangMode.isEmpty) {
      searchLangMode = preferenceHelper.getString(searchLangKey, "en");
      notifyListeners();
    }
  }

  setSearchLanguageMode() {
    if (searchLangMode == "en") {
      searchLangMode = "uz";
    } else {
      searchLangMode = "en";
    }
    preferenceHelper.putString(searchLangKey, searchLangMode);
    if (searchText.isNotEmpty) {
      searchByWord(searchText);
    } else {
      init();
    }
  }

  void searchByWord(String word) {
    safeBlock(
      () async {
        await getSearchLanguageMode();
        searchText = word.trim();
        List<SearchResultUzModel> resultUz = [];
        List<SearchResultModel> result = [];
        if (searchText.isNotEmpty) {
          if (searchLangMode == 'en') {
            result = await searchRepository.searchByWord(searchText.toString());
          } else {
            resultUz = await searchRepository.searchByUzWord(searchText.toString());
          }
          if ((result.isNotEmpty && searchLangMode == 'en') || (resultUz.isNotEmpty && searchLangMode == 'uz')) {
            setSuccess(tag: searchTag);
          } else {
            notifyListeners();
          }
        } else {
          await searchRepository.cleanList(searchLangMode);
          await init();
        }
      },
      callFuncName: 'searchByWord',
    );
  }

  Future init() async {
    safeBlock(() async {
      recentList.clear();
      recentListUz.clear();
      await getSearchLanguageMode();
      var result = await getRecentHistory();
      if (result.isNotEmpty) {
        if (searchLangMode == 'en') {
          recentList.addAll(result);
        } else {
          recentListUz.addAll(result);
        }
        setSuccess(tag: initTag);
      } else {
        notifyListeners();
      }
    }, callFuncName: 'init');
  }

  goBackToMain() {
    localViewModel.changePageIndex(0);
  }

  goToDetail(var model) {
    safeBlock(
      () async {
        localViewModel.isFromMain = false;
        localViewModel.toDetailFromHistory = false;
        FocusScope.of(context!).unfocus();
        RecentModel recentModel = RecentModel();
        if (model is SearchResultModel) {
          localViewModel.isSearchByUz = false;
          recentModel = RecentModel(
              id: model.id,
              word: model.word,
              wordClass: model.wordClasswordClass,
              star: model.star.toString(),
              type: model.type,
              same: model.translation);
        } else if (model is SearchResultUzModel) {
          localViewModel.isSearchByUz = true;
          recentModel = RecentModel(
              id: model.id,
              word: model.wordClass,
              wordClass: model.word,
              star: model.star,
              type: model.type,
              same: replaceSame(model.same ?? "", model.word ?? ""));
        } else {
          localViewModel.isSearchByUz = false;
          localViewModel.toDetailFromHistory = true;
          if (searchLangMode == 'uz') localViewModel.isSearchByUz = true;
          recentModel = model as RecentModel;
        }
        saveRecentHistory(recentModel);
        localViewModel.wordDetailModel = recentModel;

        // If we go back we search for text that was written
        localViewModel.goingBackFromDetail = false;
        localViewModel.lastSearchedText = searchText;
        localViewModel.changePageIndex(18);
      },
      callFuncName: 'goToDetail',
    );
  }

  String replaceSame(String s1, String target) {
    return s1.replaceAll("$target,", "").replaceAll(",$target", "").replaceAll(target, "");
  }

  Future<void> saveRecentHistory(RecentModel recent) async {
    var recentList = await getRecentHistory();
    if (recentList.length == 10) {
      recentList.removeAt(recentList.length - 1);
    }
    var result = recentList.singleWhere((it) => it.id == recent.id, orElse: () => RecentModel());
    if (result.word != null) {
      recentList.remove(result);
    }
    recentList.insert(0, recent);
    var json = jsonEncode(recentList);
    if (searchLangMode == "en") {
      preferenceHelper.putString(Constants.KEY_RECENT, json);
    } else {
      preferenceHelper.putString(Constants.KEY_RECENT_UZ, json);
    }
  }

  void cleanHistory() async {
    if (searchLangMode == 'en') {
      preferenceHelper.putString(Constants.KEY_RECENT, "");
    } else {
      preferenceHelper.putString(Constants.KEY_RECENT_UZ, "");
    }
    init();
  }

  Future<List<RecentModel>> getRecentHistory() async {
    List<RecentModel> newList = [];
    var json = "";
    if (searchLangMode == 'en') {
      json = preferenceHelper.getString(Constants.KEY_RECENT, "");
    } else {
      json = preferenceHelper.getString(Constants.KEY_RECENT_UZ, "");
    }
    if (json.isNotEmpty) {
      List<dynamic> jsonList = jsonDecode(json);
      List<RecentModel> list = List<RecentModel>.from(jsonList.map((e) => RecentModel.fromJson(e)));
      newList.addAll(list);
    }
    return newList;
  }
}
