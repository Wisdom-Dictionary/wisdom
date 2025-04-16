import 'dart:developer';
import 'dart:io';

// import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jbaza/jbaza.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/catalog_model.dart';
import 'package:wisdom/data/model/recent_model.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../config/constants/app_colors.dart';
import '../../core/domain/entities/def_enum.dart';
import '../../presentation/widgets/custom_dialog.dart';
import '../model/exercise_model.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel(
      {required super.context, required this.preferenceHelper, required this.netWorkChecker}) {
    netWorkChecker.networkListener().listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoConnectionDialog();
      }
      //  else {
      //   _closeDialogIfOpen();
      // }
    });
  }

  final SharedPreferenceHelper preferenceHelper;

  final NetWorkChecker netWorkChecker;

  FocusNode? searchFocusNode;

  String exerciseLangOption = '';

  late ExerciseType exerciseType;

  PageController pageController = PageController();

  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  ValueNotifier<bool> isNetworkAvailable = ValueNotifier<bool>(false);
  bool _isDialogShown = false;

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

  double get fontSize => preferenceHelper.getDouble(preferenceHelper.fontSize, 17);

  int subId = -1;

  int? folderId; // to change folder when enter

  InterstitialAd? interstitialAd;
  // BannerAd? banner;
  bool boundException = false;
  bool boundExceptionLoop = false;
  bool userLevelsSatusChanged = true;

  Widget get bannerAdWidget => locator.get<AdService>().getBannerAdWidget();

  AdService get adService => locator.get<AdService>();

  void _showNoConnectionDialog() {
    if (!_isDialogShown) {
      _isDialogShown = true;
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (_) => NoInternetConnectionDialog(),
      ).then(
        (value) {
          _isDialogShown = false;
        },
      );
    }
  }

  void _closeDialogIfOpen() {
    if (_isDialogShown) {
      Navigator.of(context!).pop();
      _isDialogShown = false;
    }
  }

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
    adService.showInterstitialAd();
    // if (interstitialAd == null) {
    //   return;
    // }
    // interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
    //     ad.dispose();
    //     createInterstitialAd();
    //   },
    //   onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
    //     ad.dispose();
    //     createInterstitialAd();
    //   },
    // );
    // interstitialAd!.show();
    // interstitialAd = null;
    // initialised
  }

  void checkNetworkConnection() async {
    isNetworkAvailable.value = await netWorkChecker.isNetworkAvailable();
  }

  void changeRoadMapLoadingStatus(bool userLevelsSatusValue) {
    userLevelsSatusChanged = userLevelsSatusValue;
  }

  void changePageIndex(int index) async {
    // if (banner != null) {
    //   banner!.dispose();
    // }
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
    if (index == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
          pageController.jumpToPage(index);
          // checkNetworkConnection();
          // log('changePageIndex : $index');
          // notifyListeners();
        }
      });
      return;
    } else {
      pageController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      pageController.jumpToPage(index);
    }

    checkNetworkConnection();
    log('changePageIndex : $index');
  }

  Future changeBadgeCount(int how) async {
    int count = await locator.get<WordEntityRepository>().allWordBanksCount;
    log('allWordBanksCount $count');
    badgeCount.value = count;
    // if (how == -1 && badgeCount.value >= 0) {
    //   badgeCount.value--;
    // } else if (how == 1) {
    //   badgeCount.value++;
    // } else if (how == 0) {
    //   badgeCount.value = 0;
    // } else {
    //   badgeCount.value = how;
    // }
    cartKey.currentState!.runCartAnimation(
      (badgeCount.value).toString(),
    );
  }

  void shareWord(String word) async {
    await Share.share("Wisdom Dictionary : https://t.me/@wisdom_uz.\nSharing word: $word");
  }

  void goByLink(String linkWord) async {
    searchingText = linkWord;
    changePageIndex(2);
  }

  bool get isLoggedIn => preferenceHelper.getString(Constants.KEY_TOKEN, '') != '';

  bool hasConnection() => isNetworkAvailable.value;

  Future<bool> canAddWordBank(BuildContext context) async {
    if (isLoggedIn) {
      if (await netWorkChecker.isNetworkAvailable()) {
        return true;
      } else {
        noInternetMessage(context);
        return false;
      }
    } else {
      showLoginDialog(context);
      return false;
    }
  }

  Future canAddWordBankFree(BuildContext context) async {
    if (isLoggedIn) {
      if (await netWorkChecker.isNetworkAvailable()) {
        return true;
      } else {
        noInternetMessage(context);
        return false;
      }
    } else {
      showLoginDialog(context);
      return false;
    }
  }

  void noInternetMessage(BuildContext context) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: LocaleKeys.no_internet.tr(),
      ),
    );
  }

  void showLoginDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      iconColor: AppColors.blue,
      iconBackgroundColor: AppColors.borderWhite,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "login_required".tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.font15W600Normal.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      positive: "login".tr(),
      onPositiveTap: () async {
        Navigator.popAndPushNamed(context, Routes.loginPage);
      },
      negative: "cancel".tr(),
      onNegativeTap: () async {
        Navigator.pop(context);
      },
    );
  }
}
