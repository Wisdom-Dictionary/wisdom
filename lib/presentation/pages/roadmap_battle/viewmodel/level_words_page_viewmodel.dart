import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/recent_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/search_result_model.dart';
import 'package:wisdom/data/model/search_result_uz_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/domain/repositories/search_repository.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class LevelWordsPageViewModel extends BaseViewModel {
  LevelWordsPageViewModel(
      {required super.context,
      required this.localViewModel,
      required this.roadmapRepository,
      required this.preferenceHelper,
      required this.searchRepository,
      required this.homeRepository});

  final LocalViewModel localViewModel;
  final RoadmapRepository roadmapRepository;

  final SharedPreferenceHelper preferenceHelper;
  final HomeRepository homeRepository;
  final SearchRepository searchRepository;

  final String getExercisesTag = 'getExercisesTag';
  final String getLevelWordsTag = 'getLevelWordsTag';
  final String exercisesWordDetailsTag = 'exercisesWordDetailsTag';
  List<SearchResultModel> result = [];

  String searchLangMode = '';
  String searchText = '';

  String searchLangKey = "searchLangKey";
  String searchTag = 'searchTag';

  void getLevelWords() {
    safeBlock(() async {
      await roadmapRepository.getLevelWords();
      if (roadmapRepository.levelWordsList.isNotEmpty) {
        setSuccess(tag: getLevelWordsTag);
      } else {
        callBackError("text");
      }
    }, callFuncName: 'getLevelWords', tag: getLevelWordsTag);
  }

  void searchByWord(LevelWordModel levelWordItem) {
    safeBlock(
      () async {
        roadmapRepository.setSelectedLevel(levelWordItem);
        await getSearchLanguageMode();
        searchText = levelWordItem.word!.trim();
        List<SearchResultUzModel> resultUz = [];
        List<SearchResultModel> result = [];
        if (searchText.isNotEmpty) {
          if (searchLangMode == 'en') {
            result = await searchRepository.searchByWord(searchText.toString());
          } else {
            resultUz = await searchRepository.searchByUzWord(searchText.toString());
          }
          if ((result.isNotEmpty && searchLangMode == 'en') ||
              (resultUz.isNotEmpty && searchLangMode == 'uz')) {
            goToDetail(result.first);
          } else {
            notifyListeners();
          }
        }
      },
      callFuncName: 'searchByWord',
    );
  }

  getSearchLanguageMode() async {
    if (searchLangMode.isEmpty) {
      searchLangMode = preferenceHelper.getString(searchLangKey, "en");
      notifyListeners();
    }
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
        localViewModel.wordDetailModel = recentModel;
        Navigator.of(context!).pushNamed(Routes.wordDetailsPage);
      },
      callFuncName: 'goToDetail',
    );
  }

  String replaceSame(String s1, String target) {
    return s1.replaceAll("$target,", "").replaceAll(",$target", "").replaceAll(target, "");
  }

  goMain() {
    localViewModel.changePageIndex(3);
  }
}
