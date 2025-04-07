import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/battle/battle_result_model.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/opponent_was_rejected_rematch_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/rematch_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/waiting_opponent_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/want_to_rematch_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';

import '../../../../core/di/app_locator.dart';

class BattleResultViewmodel extends BaseViewModel {
  BattleResultViewmodel({required super.context}) {
    _listenToWebSocket();
  }

  final battleRepository = locator<BattleRepository>();
  final profileRepository = locator<ProfileRepository>();
  final sharedPref = locator<SharedPreferenceHelper>();

  final localViewModel = locator<LocalViewModel>();

  final String postInviteTag = "postInviteTag",
      postWordExercisesResultTag = "postWordExercisesResultTag",
      postRematchRequestTag = "postRematchRequestTag",
      rejectedTag = "rejected",
      acceptedTag = "accepted";
  String statusTag = "";

  ValueNotifier<int> seconds = ValueNotifier<int>(20);
  ValueNotifier<bool> rematchUpdateStatus = ValueNotifier<bool>(false);
  ValueNotifier<bool> rematchInProgress = ValueNotifier<bool>(false);
  ValueNotifier<bool> waitingRematch = ValueNotifier<bool>(false);

  BattleResultModel result = BattleResultModel();

  int? userId,
      winnerId,
      currentUserGainedStars,
      opponentUserGainedStars,
      totalQuestions,
      currentUserCorrectAnswers,
      opponentUserCorrectAnswers,
      currentUserSpentTime,
      opponentUserSpentTime,
      battleDuration,
      battleId;
  bool? draw;

  String? battleChannel;

  bool user1IsCurrentUser = false;
  Timer? _timer;
  BattleUserModel? rematchOpponentUser = BattleUserModel();
  BattleUserModel? opponentUser = BattleUserModel();
  BattleUserModel? currentUser = BattleUserModel();

  bool get currentUserWon => userId == winnerId;

  bool get hasOpponentData =>
      opponentUserCorrectAnswers != null &&
      opponentUserGainedStars != null &&
      opponentUserSpentTime != null;

  bool get hasCurrentUserData =>
      currentUserCorrectAnswers != null &&
      currentUserGainedStars != null &&
      currentUserSpentTime != null;

  late final StreamSubscription _subscription;

  goBack() async {
    battleRepository.searchingOpponentsChannelClose();
    Navigator.pop(navigatorKey.currentContext!);
  }

  void _listenToWebSocket() {
    _subscription = battleRepository.searchingOpponents.listen((message) async {
      final messageData = jsonDecode(message);

      if (messageData['event'] == 'battle-finished') {
        log(messageData['data']);
        final eventData = jsonDecode(messageData['data']);
        userId = profileRepository.userCabinet!.user!.id;
        result = BattleResultModel.fromJson(eventData['data']);
        user1IsCurrentUser = result.user1?.id == userId;

        currentUser = user1IsCurrentUser ? result.user1 : result.user2;
        opponentUser = user1IsCurrentUser ? result.user2 : result.user1;

        winnerId = result.winnerId;
        currentUserGainedStars =
            user1IsCurrentUser ? result.user1GainedStars : result.user2GainedStars;
        opponentUserGainedStars =
            !user1IsCurrentUser ? result.user1GainedStars : result.user2GainedStars;
        totalQuestions = result.totalQuestions;
        battleDuration = result.battleDuration;
        currentUserCorrectAnswers =
            user1IsCurrentUser ? result.user1CorrectAnswers : result.user2CorrectAnswers;
        opponentUserCorrectAnswers =
            !user1IsCurrentUser ? result.user1CorrectAnswers : result.user2CorrectAnswers;
        currentUserSpentTime = user1IsCurrentUser ? result.user1SpentTime : result.user2SpentTime;
        opponentUserSpentTime = !user1IsCurrentUser ? result.user1SpentTime : result.user2SpentTime;
        draw = result.draw;

        final isOpenDialog =
            (ModalRoute.of(navigatorKey.currentContext!)?.isCurrent ?? false) != true;

        if (!hasOpponentData && !isOpenDialog) {
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) => WaitingOpponentBattleDialog(
              opponentUser: opponentUser!,
            ),
          );
        }
        if (!currentUserWon) {
          await navigatorKey.currentContext!.read<CountdownProvider>().getLives();
        }
        if (sharedPref.getInt(Constants.KEY_USER_BATTLE_END_TIME, 0) != 0) {
          await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_END_TIME);
          await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_ID);
          await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_OPPONENT_USER);
        }
        notifyListeners(); // UI-ni yangilash
      } else if (messageData['event'] == 'rematch') {
        final eventData = jsonDecode(messageData['data']);
        rematchOpponentUser = BattleUserModel.fromMap(eventData['opponent']);
        battleId = eventData['battle_id'];
        battleChannel = eventData['battle_channel'];
        showTopDialog();
        _startTimer(_decrementTimer);
      } else if (messageData['event'] == 'battle-invitation-status-update') {
        rejectedRematchBattle(messageData);
      }
    }, cancelOnError: true, onDone: () {}, onError: (error) {});
  }

  void rejectedRematchBattle(Map<String, dynamic> messageData) {
    waitingRematch.value = false;
    final eventData = jsonDecode(messageData['data']);
    String status = eventData['status'];
    if (status == rejectedTag) {
      rematchInProgress.value = false;
      Navigator.pop(navigatorKey.currentContext!);
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => OpponentWasRejectedRematchDialog(viewmodel: this),
      );

      // showTopSnackBar(
      //   Overlay.of(context!),
      //   CustomSnackBar.error(
      //     message: "Opponent rejected invitation",
      //   ),
      // );
    }
  }

  void showTopDialog() {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: "Top Dialog",
      pageBuilder: (context, anim1, anim2) {
        return RematchBattleDialog(
          viewmodel: this,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void showRematchDialog() {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: "Top Dialog",
      pageBuilder: (context, anim1, anim2) {
        return WantRematchBattleDialog(
          viewmodel: this,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // void postInviteBattle({required int opponentId}) {
  //   setBusy(true, tag: postInviteTag);
  //   safeBlock(() async {
  //     if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
  //       await battleRepository.invite(opponentId: opponentId);
  //       setSuccess(tag: postInviteTag);
  //     } else {
  //       showDialog(
  //         context: context!,
  //         builder: (context) => const DialogBackground(
  //           child: NoInternetConnectionDialog(),
  //         ),
  //       );
  //       setBusy(false, tag: postInviteTag);
  //     }
  //   }, callFuncName: 'postInvite', tag: postInviteTag, inProgress: false);
  // }

  void postTestQuestionsResult() {
    setBusy(true, tag: postWordExercisesResultTag);
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await battleRepository.postFullBattleResult();
        setSuccess(tag: postWordExercisesResultTag);
      } else {
        callBackError(LocaleKeys.no_internet.tr());
        setBusy(false, tag: postWordExercisesResultTag);
      }
    }, callFuncName: 'postWordExercisesResult', tag: postWordExercisesResultTag, inProgress: false);
  }

  void cancelRematch() {
    waitingRematch.value = false;
    rematchInProgress.value = false;
  }

  void postRematchRequest() {
    setBusy(true, tag: postRematchRequestTag);

    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        rematchInProgress.value = true;
        await battleRepository.rematchRequest(opponentId: opponentUser!.id!);
        setSuccess(tag: postRematchRequestTag);
        waitingRematch.value = true;
      } else {
        callBackError(LocaleKeys.no_internet.tr());
        setBusy(false, tag: postRematchRequestTag);
      }
    }, callFuncName: 'postRematchRequest', tag: postRematchRequestTag, inProgress: false);
  }

  void postRematchUpdateStatus(String status) {
    if (!Navigator.of(navigatorKey.currentContext!).canPop()) {
      return;
    }
    seconds.value = 20;
    statusTag = status;
    _resetTimer();
    rematchUpdateStatus.value = true;
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await battleRepository.rematchUpdateStatus(battleId: battleId!, status: status);
        statusTag = "";
        rematchUpdateStatus.value = false;
        if (Navigator.of(navigatorKey.currentContext!).canPop()) {
          Navigator.pop(navigatorKey.currentContext!);
        }
      } else {
        callBackError(LocaleKeys.no_internet.tr());
        statusTag = "";
        rematchUpdateStatus.value = false;
      }
    },
        callFuncName: 'postRematchUpdateStatus',
        tag: "postRematchUpdateStatusTag",
        inProgress: false);
  }

  void _startTimer(Function() onChange) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onChange();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  _decrementTimer() {
    if (seconds.value > 0) {
      seconds.value--;
    } else if (seconds.value == 0) {
      _resetTimer();
      postRematchUpdateStatus(rejectedTag);
    }
  }

  void _resetTimer() {
    _stopTimer();

    seconds.value = 20;
  }

  @override
  void dispose() async {
    // if (_timer != null) {
    //   _timer!.cancel();
    // }
    _subscription.cancel();
    super.dispose();
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
