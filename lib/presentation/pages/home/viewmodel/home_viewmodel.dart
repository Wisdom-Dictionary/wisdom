import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/ad_state.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';
import 'package:wisdom/presentation/components/custom_progress_indicator.dart';

import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../domain/repositories/profile_repository.dart';
import '../../../../domain/repositories/word_entity_repository.dart';
import '../../../widgets/custom_dialog.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({required super.context});

  final homeRepository = locator<HomeRepository>();
  final dbHelper = locator<DBHelper>();
  final wordEntity = locator<WordEntityRepository>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  List<TargetFocus> targets = [];
  late TutorialCoachMark tutorialCoachMark;
  late int newDbVersion;

  final GlobalKey globalKeyHome = GlobalKey();
  final GlobalKey globalKeyWordBank = GlobalKey();
  final GlobalKey globalKeySearch = GlobalKey();
  final GlobalKey globalKeyCategory = GlobalKey();
  final GlobalKey globalKeyTranslation = GlobalKey();
  final GlobalKey globalKeyCentre = GlobalKey();
  ValueNotifier<bool> isShow = ValueNotifier<bool>(false);
  ValueNotifier<bool> isDownloadingShow = ValueNotifier<bool>(false);
  ValueNotifier<int> downloadedPortion = ValueNotifier<int>(0);
  late bool singleton = true;

  late ProgressDialog progressDialog;

  final controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get stream => controller.stream;

  Future? dialog;

  final String getDailyWordsTag = "getDailyWordsTag";
  final String getAdTag = "getAdTag";
  final String checkSubscriptionTag = "checkSubscriptionTag";

  Future<void> addDeviceToFirebase() async {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        final value = await getBox<bool>(Constants.FIREBASE_SEND, key: 0);
        if (value != true) {
          String? token = await FirebaseMessaging.instance.getToken();
          locator<ProfileRepository>().applyFirebaseId(token!);
          await saveBox<bool>(Constants.FIREBASE_SEND, true, key: 0);
        }
      }
    },
        callFuncName: 'addDeviceToFirebase',
        tag: "addDeviceToFirebase",
        inProgress: false);
  }

  void getRandomDailyWords() {
    safeBlock(() async {
      await homeRepository.getRandomWords();
      controller.add(SwipeRefreshState.hidden);
      setSuccess(tag: getDailyWordsTag);
      getAd();
    },
        callFuncName: 'getRandomDailyWords',
        tag: getDailyWordsTag,
        inProgress: false);
  }

  void getAd() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        var response = await homeRepository.getAd();
        if (response != null && response.image != null) {
          homeRepository.timelineModel.ad = response;
        }
        setSuccess(tag: getAdTag);
      }
    }, callFuncName: 'getAd', tag: getAdTag, inProgress: false);
  }

  isAdHTTPWorking(String uri) async {
    var result = await get(Uri.parse(uri));
    return result.isSuccessful;
  }

  void onAdWebClicked() {
    safeBlock(() async {
      launchUrlString(
        homeRepository.timelineModel.ad!.link!,
        mode: LaunchMode.externalApplication,
      );
    }, callFuncName: 'onAdWebClicked', inProgress: false);
  }

  String? separateDifference(bool isFirst, String? str) {
    if (str != null && str.isNotEmpty) {
      int whereOr = str.indexOf(" or ");
      if (isFirst) {
        return str.substring(0, whereOr).trim();
      } else {
        return str.substring(whereOr + 3, str.length).trim();
      }
    }
    return str;
  }

  Future<void> checkForUpdate() async {
    final lastShown =
        await localViewModel.preferenceHelper.getLastDialogShowTime();
    log("lastShown: $lastShown ${isShow.value}");
    if (isShow.value) {
      return;
    }
    if (lastShown == null ||
        DateTime.now().difference(lastShown) > const Duration(seconds: 7)) {
      await localViewModel.preferenceHelper.updateLastDialogShowTime();
      safeBlock(
        () async {
          var result = await localViewModel.netWorkChecker.isNetworkAvailable();
          if (result && !isTheFirstTime()) {
            var result = await wordEntity.getUpdatedWords();
            if (result != null && !result.id!.isNegative) {
              newDbVersion = result.id!;
              if (newDbVersion > sharedPref.getIDBVersion()) {
                showCustomDialog(
                  context: context!,
                  icon: Assets.icons.download,
                  contentWidget: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      'update_info'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.font15W600Normal.copyWith(
                          color: isDarkTheme
                              ? AppColors.lightGray
                              : AppColors.darkGray),
                    ),
                  ),
                  positive: "update".tr(),
                  onPositiveTap: () {
                    pop();
                    showUpdatingProgress();
                    updatingProcess();
                  },
                  negative: "update_later".tr(),
                  onNegativeTap: () {
                    pop();
                  },
                );
              }
            }
          }
        },
        callFuncName: 'getWords',
      );
    }
  }

  showUpdatingProgress() {
    isDownloadingShow.value = true;
    showCustomDialog(
      context: context!,
      icon: Assets.icons.download,
      contentWidget: ValueListenableBuilder<int>(
        valueListenable: downloadedPortion,
        builder: (ctx, int value, child) {
          if (!isDownloadingShow.value &&
              value == wordEntity.currentSizeOfPathModel) {
            pop();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$value/${wordEntity.currentSizeOfPathModel} ${"downloading".tr()}",
                style: AppTextStyle.font15W600Normal.copyWith(
                  color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "youCanHideTheWindow".tr(),
                style: AppTextStyle.font13W400Normal.copyWith(
                  color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // ProgressWidget(
              //   percent: (value / wordEntity.wordPathModel.files!.length) * 100,
              //   ctx: ctx,
              // ),
              ProgressBar(
                percent: (value / wordEntity.currentSizeOfPathModel) * 100,
                // percent: 50,
                ctx: ctx,
              ),
            ],
          );
        },
      ),
      positive: "close".tr(),
      onPositiveTap: () {
        isDownloadingShow.value = true;
        showTopSnackBar(
          Overlay.of(context!),
          CustomSnackBar.info(
            message: "backgroundInfo".tr(),
          ),
        );
        pop();
      },
      negative: "cancel".tr(),
      onNegativeTap: () {
        isDownloadingShow.value = false;
        cancelProgress = true;
        pop();
      },
    );
  }

  // startUpdating() {
  //   safeBlock(() async {
  //     progressDialog = ProgressDialog(context: context);
  //     progressDialog.show(
  //       msg: "update_progress".tr(),
  //       msgTextAlign: TextAlign.center,
  //       msgMaxLines: 2,
  //       max: wordEntity.wordPathModel.files!.length,
  //       valuePosition: ValuePosition.right,
  //       valueColor: AppColors.darkGray,
  //       cancel: Cancel(
  //         cancelClicked: () {
  //           showTopSnackBar(
  //             Overlay.of(context!),
  //             const CustomSnackBar.info(
  //               message: "Word downloading canceled",
  //             ),
  //           );
  //           cancelProgress = true;
  //           progressDialog.close();
  //         },
  //       ),
  //       barrierDismissible: false,
  //       barrierColor: Colors.black12.withOpacity(.8),
  //       progressType: ProgressType.valuable,
  //     );
  //   }, callFuncName: "startUpdating");
  // }

  bool cancelProgress = false;

  updatingProcess() async {
    safeBlock(() async {
      var index = sharedPref.getInt(Constants.INDEX, 0);
      downloadedPortion.value = index + 1;
      // progressDialog.update(value: index);
      for (int i = index; i < wordEntity.wordPathModel.files!.length; i++) {
        await wordEntity
            .getWordEntity(wordEntity.wordPathModel.files![i].path!);
        // progressDialog.update(value: i);
        downloadedPortion.value = i + 1;
        sharedPref.putInt(Constants.INDEX, i);
        index++;
        if (cancelProgress) {
          showTopSnackBar(
            Overlay.of(context!),
            CustomSnackBar.info(
              message: "downloadingCanceled".tr(),
            ),
          );
          break;
        }
      }
      if (index == wordEntity.wordPathModel.files!.length) {
        sharedPref.saveDBVersion(newDbVersion);
        isDownloadingShow.value = false;
        showTopSnackBar(
          Overlay.of(context!),
          CustomSnackBar.success(
            message: "downloadingCompleted".tr(),
          ),
        );
      }
    }, callFuncName: "startUpdating");
  }

  @override
  callBackError(String text) {
    Future.delayed(Duration.zero, () {
      if (dialog != null) pop();
    });
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.info(
        message: text,
      ),
    );
  }

  void getWordBank() {
    safeBlock(() async {
      await wordEntity.getWordBankList(null);
      await wordEntity.getWordBankCount();
      localViewModel.changeBadgeCount(0);
      wordEntity.getWordBankFolders();
      localViewModel.changeBadgeCount(wordEntity.wordBankList.length);
    }, callFuncName: 'getWordBank', inProgress: false);
  }

  void checkStatus() {
    safeBlock(() async {
      var token = sharedPref.getString(Constants.KEY_TOKEN, '');
      if (token.isEmpty) {
        onProfileStateChanged(Constants.STATE_NOT_REGISTERED);
      } else {
        // onProfileStateChanged(Constants.STATE_ACTIVE);
        onProfileStateChanged(sharedPref.getInt(
            Constants.KEY_PROFILE_STATE, Constants.STATE_NOT_REGISTERED));
        var subscribeModel = await homeRepository.checkSubscription();
        if (subscribeModel != null && subscribeModel.status!) {
          if (subscribeModel.expiryStatus!) {
            onProfileStateChanged(Constants.STATE_ACTIVE);
          } else {
            onProfileStateChanged(Constants.STATE_INACTIVE);
          }
        }
      }
    }, callFuncName: 'checkStatus');
  }

  void onProfileStateChanged(int state) {
    safeBlock(
      () async {
        PurchasesObserver().profileState = state;
        sharedPref.putInt(Constants.KEY_PROFILE_STATE, state);
        if (state != Constants.STATE_ACTIVE) {
          await setupAds();
        }
        notifyListeners();
      },
      callFuncName: 'onProfileStateChanged',
    );
  }

  setupAds() async {
    localViewModel.createInterstitialAd();
    if (!PurchasesObserver().isPro()) {
      var adState = locator<AdState>();
      adState.initialization?.then((status) {
        localViewModel.banner = BannerAd(
          adUnitId: adState.bannerId,
          size: AdSize.mediumRectangle,
          listener: adState.adListener,
          request: const AdRequest(),
        );
      });
    }
  }

  rateApp() async {
    if (Platform.isAndroid) {
      try {
        launchUrl(Uri.parse('market://details?id=uz.usoft.waiodictionary'));
      } catch (e) {
        launchUrl(Uri.parse(
            'http://play.google.com/store/apps/details?id=uz.usoft.waiodictionary'));
      }
    } else if (Platform.isIOS) {
      try {
        launchUrl(Uri.parse(
            'https://apps.apple.com/us/app/wisdom-lugati-english-uzbek/id1514625154'));
      } catch (e) {
        launchUrl(Uri.parse(
            'https://apps.apple.com/us/app/wisdom-lugati-english-uzbek/id1514625154'));
      }
    }
  }

  shareApp() async {
    await Share.share(
        "Wisdom lug'atini tavsiya qilaman! \n\nhttp://onelink.to/wisdomdictionary");
  }

  bool isTheFirstTime() {
    return sharedPref.getBoolean(Constants.APP_STATE, true);
  }

  void redirect() {
    var result = locator<SharedPreferenceHelper>().getBoolean("notif", false);
    if (result) {
      //   localViewModel.changePageIndex(1);
      //   locator<SharedPreferenceHelper>().putBoolean("notif", false);
    }
  }
}

// @pragma('vm:entry-point')
// void isolate2(SendPort sendPort) async {
//   for (int i = 0; i < 100; i++) {
//     sendPort.send("Isolate 2: $i with arg");
//     await Future.delayed(
//       const Duration(seconds: 1),
//     );
//   }
// }
