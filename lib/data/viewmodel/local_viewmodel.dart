import 'dart:io';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jbaza/jbaza.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/catalog_model.dart';
import 'package:wisdom/data/model/recent_model.dart';
import 'package:wisdom/data/model/word_bank_model.dart';

import '../../core/domain/entities/def_enum.dart';
import '../model/exercise_model.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel(
      {required super.context,
      required this.preferenceHelper,
      required this.netWorkChecker});

  final SharedPreferenceHelper preferenceHelper;

  final NetWorkChecker netWorkChecker;

  FocusNode? searchFocusNode;

  BannerAd? banner;

  String exerciseLangOption = '';

  late ExerciseType exerciseType;

  PageController pageController = PageController();

  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  ValueNotifier<bool> isNetworkAvailable = ValueNotifier<bool>(false);

  ValueNotifier<int> cleanNotifier = ValueNotifier<int>(0);

  RecentModel wordDetailModel = RecentModel();
  bool isSearchByUz = false;

  List<WordBankModel> wordBankList = [];

  ValueNotifier<int> badgeCount = ValueNotifier<int>(0);

  Set<ExerciseFinalModel> finalList = {};

  bool isFromMain = false;
  bool detailToFromBank = false;
  bool toDetailFromHistory = false;

  bool isTitle = false;
  bool isSubSub = false;
  bool isFinal = false;

  bool goingBackFromDetail = false;
  String searchingText = '';

  // used for search when we go back to search page from word detail
  String lastSearchedText = '';

  CatalogModel speakingCatalogModel = CatalogModel();

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  late Function(GlobalKey) runAddToCartAnimation;

  double get fontSize =>
      preferenceHelper.getDouble(preferenceHelper.fontSize, 17);

  int subId = -1;

  int? folderId; // to change folder when enter

  InterstitialAd? interstitialAd;

  final adapty = Adapty();

  List<AdaptyPaywall> tests = [];

  bool boundException = false;
  bool boundExceptionLoop = false;

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-6651367008928070/9544986489'
          : 'ca-app-pub-6651367008928070/2683354223',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialAd = null;
          createInterstitialAd();
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    // interstitialAd = null;
    // initialised
  }

  void checkNetworkConnection() async {
    isNetworkAvailable.value = await netWorkChecker.isNetworkAvailable();
  }

  void changePageIndex(int index) async {
    if (banner != null) {
      banner!.dispose();
    }
    if (index < 5) {
      currentIndex.value = index;
    }
    if (index == 2) {
      cleanNotifier.value++;
      // if (searchFocusNode != null) {
      //   Future.delayed(
      //       Duration.zero,
      //       () => FocusScope.of(searchFocusNode!.context!)
      //           .requestFocus(FocusNode()));
      //   Future.delayed(
      //     const Duration(milliseconds: 300),
      //     () => FocusScope.of(searchFocusNode!.context!)
      //         .requestFocus(searchFocusNode),
      //   );
      // }
    }
    notifyListeners();
    pageController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    pageController.jumpToPage(index);
    checkNetworkConnection();
  }

  void changeBadgeCount(int how) {
    if (how == -1 && badgeCount.value >= 0) {
      badgeCount.value--;
    } else if (how == 1) {
      badgeCount.value++;
    } else if (how == 0) {
      badgeCount.value = 0;
    } else {
      badgeCount.value = how;
    }
    cartKey.currentState!.runCartAnimation(
      (badgeCount.value).toString(),
    );
  }

  void shareWord(String word) async {
    await Share.share(
        "Wisdom Dictionary : https://t.me/@wisdom_uz.\nSharing word: $word");
  }

  void goByLink(String linkWord) async {
    searchingText = linkWord;
    changePageIndex(2);
  }
}
