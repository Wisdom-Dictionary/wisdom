import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/recent_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/search_result_model.dart';
import 'package:wisdom/data/model/search_result_uz_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/domain/repositories/search_repository.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class LevelWordsPageViewModel extends BaseViewModel {
  LevelWordsPageViewModel(
      {required super.context,
      required this.localViewModel,
      required this.roadmapRepository,
      required this.levelTestRepository,
      required this.preferenceHelper,
      required this.searchRepository,
      required this.homeRepository});

  final LocalViewModel localViewModel;
  final RoadmapRepository roadmapRepository;
  final LevelTestRepository levelTestRepository;

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

  void goContactsPage() {
    Navigator.pushNamed(context!, Routes.myContactsPage);
  }

  bool get hasUserLifes => context!.read<CountdownProvider>().hasUserLives;

  goRoadmapPage() {
    locator<LocalViewModel>().changePageIndex(3);
  }

  void goLevelExercisesPage() {
    levelTestRepository.setExerciseType(TestExerciseType.levelExercise);
    Navigator.pushNamed(context!, Routes.wordExercisesPage).then((onValue) {
      if (hasUserLifes) {
        getLevelWords();
      } else {
        goRoadmapPage();
      }
    });
  }

  void getLevelWords() async {
    try {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        setBusy(true, tag: getLevelWordsTag);
        await roadmapRepository.getLevelWords();
        setSuccess(tag: getLevelWordsTag);
      } else {
        setBusy(false, tag: getLevelWordsTag);
        callBackError(LocaleKeys.no_internet.tr());
      }
    } catch (e) {
      if (e is VMException) {
        if (e.response?.statusCode == 403) {
          locator<LocalViewModel>().changePageIndex(3);
        }
        final messageData = jsonDecode(e.responseBody ?? "");

        setError(VMException(messageData["message"] ?? ""), tag: getLevelWordsTag);
      }
    }
  }

  void searchByWord(LevelWordModel levelWordItem) {
    safeBlock(
      () async {
        levelTestRepository.setSelectedLevelMord(levelWordItem);
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
        Navigator.of(context!).pushNamed(Routes.wordDetailsPage).then((value) {
          getLevelWords();
        });
      },
      callFuncName: 'goToDetail',
    );
  }

  String replaceSame(String s1, String target) {
    return s1.replaceAll("$target,", "").replaceAll(",$target", "").replaceAll(target, "");
  }

  goMain() {
    localViewModel.changePageIndex(3);
    localViewModel.changeRoadMapLoadingStatus(true);
  }

  @override
  callBackError(String text) {
    log(text);
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
