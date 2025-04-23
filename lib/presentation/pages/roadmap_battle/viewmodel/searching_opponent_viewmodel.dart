import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/opponent_was_found_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/opponent_was_not_found_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/opponent_was_rejected_invitation_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/out_of_lives_dialog.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

enum BattleCreateType { fromSearchingOpponent, fromInvitation }

class SearchingOpponentViewmodel extends BaseViewModel {
  SearchingOpponentViewmodel({
    required super.context,
  }) {
    _listener = () {
      final status = battleRepository.clientConnectedToWebsocket.value;
      if (status == FormzSubmissionStatus.success && inviteStatus.isInitial) {
        seconds.value = 20;
        _startTimer(_decrementInvitationTimer);
      }
    };

    battleRepository.clientConnectedToWebsocket.addListener(_listener);
  }
  BattleCreateType connectionType = BattleCreateType.fromSearchingOpponent;
  final battleRepository = locator<BattleRepository>();
  final profileRepository = locator<ProfileRepository>();

  final dbHelper = locator<DBHelper>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String searchingOpponentTag = "searchingOpponentTag",
      stopSearchingOpponentTag = "stopSearchingOpponentTag",
      readyBattleTag = "readyBattleTag",
      getGetUserTag = "getGetUserTag";
  int page = 0;

  UserDetailsModel userDetailsModel = UserDetailsModel();
  String statusMessage = "Waiting for events...";
  Timer? _timer;
  late DateTime _startTime;
  ValueNotifier<int> seconds = ValueNotifier<int>(0);
  ValueNotifier<bool> readyBattleTagLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> matchCancelledTag = ValueNotifier<bool>(false);
  ValueNotifier<bool> inviteUpdateStatus = ValueNotifier<bool>(false);
  FormzSubmissionStatus inviteStatus = FormzSubmissionStatus.initial;
  late final VoidCallback _listener;

  BattleUserModel? user1, user2;
  BattleUserModel battleInviteUser = BattleUserModel();
  int? _battleId;

  BattleUserModel? get opponentUser => user1!.id! == userDetailsModel.user!.id! ? user2 : user1;

  final String postInviteTag = "postInviteTag",
      postWordExercisesResultTag = "postWordExercisesResultTag",
      postRematchRequestTag = "postRematchRequestTag",
      rejectedTag = "rejected",
      acceptedTag = "accepted";
  String statusTag = "";

  StreamSubscription? _subscription;

  void _startTimer(Function() onChange) {
    _startTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onChange();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  _incrementTimer() {
    final elapsed = DateTime.now().difference(_startTime).inSeconds;
    seconds.value = elapsed;
  }

  _decrementTimer() {
    if (seconds.value > 0) {
      seconds.value--;
    } else if (seconds.value == 0) {
      _resetTimer();

      battleStarted();
    }
  }

  _decrementInvitationTimer() {
    if (seconds.value > 0) {
      seconds.value--;
    } else if (seconds.value == 0) {
      _stopTimer();
      if (!inviteUpdateStatus.value) {
        postInviteUpdateStatus(rejectedTag);
      }
    }
  }

  void _resetTimer() {
    _stopTimer();

    seconds.value = 0;
  }

  void startSearchOpponentTimer() {
    _resetTimer();
    _startTimer(_incrementTimer);
  }

  @override
  callBackError(String text) {
    if (context == null) {
      return;
    }
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  void listenToWebSocket() async {
    if (userDetailsModel.user == null) {
      if (!profileRepository.userCabinet.hasUser) {
        userDetailsModel = await profileRepository.getUserCabinet();
      } else {
        userDetailsModel = profileRepository.userCabinet;
      }
    }
    if (isSubscribed) {
      return;
    }
    _subscription = battleRepository.searchingOpponents.listen(
        (message) async {
          final messageData = jsonDecode(message);

          statusMessage = message;
          if (messageData['event'] == 'user-matched' &&
              (messageData['channel'] as String).contains('private-user.')) {
            log('user-matched');
            userMatched(messageData);
            _stopTimer();
          } else if (messageData['event'] == 'match-cancelled') {
            matchCancelled();
          } else if (messageData['event'] == 'user-search-failed') {
            _stopTimer();
            battleRepository.stopSearchingOpponents();
            battleRepository.dispose();
            showDialog<bool>(
              barrierDismissible: false,
              context: navigatorKey.currentContext!,
              builder: (context) => const OpponentWasNotFoundDialog(),
            ).then(
              (value) {
                if (value == null || !value) {
                  Navigator.pop(navigatorKey.currentContext!);
                } else {
                  startSearchOpponentTimer();
                  battleRepository.connectBattle(battleRepository.subscribeSearchingChannels);
                }
              },
            );
          } else if (messageData['event'] == 'battle-started') {
            _startTimer(_decrementTimer);
          }
          // else if (messageData['event'] == 'ready-for-battle') {
          //   statusMessage = "Ready users for battle";
          //   final data = jsonDecode(messageData["data"]);
          //   if (_readyUser1Id == null) {
          //     _readyUser1Id = data["user_id"];
          //   } else {
          //     _readyUser2Id = data["user_id"];
          //   }
          // }
          else if (messageData['event'] == 'user-search-failed') {
            statusMessage = "Search failed. No opponent found.";
          } else if (messageData['event'] == 'battle-invitation-status-update') {
            rejectedRematchBattle(messageData);
            if (connectionType == BattleCreateType.fromInvitation) {
              battleRepository.dispose();
            }
          }

          notifyListeners(); // UI-ni yangilash
        },
        cancelOnError: true,
        onDone: () {
          _stopTimer();
        },
        onError: (error) {
          _stopTimer();
          matchCancelledTag.value = false;
        });
  }

  void rejectedRematchBattle(Map<String, dynamic> messageData) {
    // waitingRematch.value = false;
    final eventData = jsonDecode(messageData['data']);
    String status = eventData['status'];
    if (status == rejectedTag) {
      // rematchInProgress.value = false;
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => OpponentWasRejectedInvitationDialog(),
        // builder: (context) => OpponentWasRejectedRematchDialog(viewmodel: this),
      );
    }
  }
  // void rejectedRematchBattle(Map<String, dynamic> messageData) {
  //   // waitingRematch.value = false;
  //   final eventData = jsonDecode(messageData['data']);
  //   String status = eventData['status'];
  //   if (status == rejectedTag) {
  //     // rematchInProgress.value = false;
  //     // Navigator.pop(navigatorKey.currentContext!);
  //     showDialog(
  //       context: navigatorKey.currentContext!,
  //       builder: (context) => const OpponentWasRejectedInvitationDialog(),
  //     );
  //   }
  // }

  Future<dynamic> userMatched(Map<String, dynamic> messageData) async {
    statusMessage = "Matched with opponent: ${messageData['data']}";
    _resetTimer();
    seconds.value = 3;

    final data = jsonDecode(messageData['data'] ?? '');

    _battleId = data['battleId'];
    user1 = BattleUserModel.fromMap(data['user1']);
    user2 = BattleUserModel.fromMap(data['user2']);
    if (userDetailsModel.user == null) {
      if (profileRepository.userCabinet.user == null) {
        userDetailsModel = await profileRepository.getUserCabinet();
      } else {
        userDetailsModel = profileRepository.userCabinet;
      }
    }
    sharedPref.putString(Constants.KEY_USER_BATTLE_OPPONENT_USER, opponentUser!.toJson());
    battleRepository.subscribeToChannel(channelName: "private-battle.${user1!.id}.${user2!.id}");
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) => OpponentWasFoundDialog(
        viewmodel: this,
      ),
    );
  }

  battleStarted() {
    //Search opponent page
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.popUntil(
      navigatorKey.currentState!.context,
      (route) => route.isFirst ? true : false,
    );
    Navigator.pushNamed(navigatorKey.currentState!.context, Routes.battleExercisesPage);
    // });
  }

  void connectBattle() {
    listenToWebSocket();
    battleRepository.connectBattle(battleRepository.subscribeSearchingChannels);
  }

  getUser() {
    setBusy(true, tag: getGetUserTag);
    safeBlock(
      () async {
        if (profileRepository.userCabinet.user == null) {
          userDetailsModel = await profileRepository.getUserCabinet();
        } else {
          userDetailsModel = profileRepository.userCabinet;
        }
        setSuccess(tag: getGetUserTag);
      },
      callFuncName: 'getUser',
      inProgress: false,
    );
  }

  void stopSearchOpponent() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        setBusy(true, tag: stopSearchingOpponentTag);
        await battleRepository.stopSearchingOpponents();
        stopListening();
        battleRepository.dispose();
        Navigator.pop(navigatorKey.currentContext!);
        setSuccess(tag: stopSearchingOpponentTag);
      } else {
        callBackError(LocaleKeys.no_internet.tr());
      }
    }, callFuncName: 'stopSearchingOpponent', tag: stopSearchingOpponentTag, inProgress: false);
  }

  void readyBattle() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        readyBattleTagLoading.value = true;
        setBusy(true, tag: readyBattleTag);
        await battleRepository.readyBattle(
            battleId: _battleId!, battleChannel: "private-battle.${user1!.id}.${user2!.id}");
        readyBattleTagLoading.value = false;
        setSuccess(tag: readyBattleTag);
      }
    }, callFuncName: 'stopSearchingOpponent', tag: stopSearchingOpponentTag, inProgress: false);
  }

  // void startBattle() {
  //   safeBlock(() async {
  //     if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
  //       readyBattleTagLoading.value = true;
  //       setBusy(true, tag: readyBattleTag);
  //       final int user1Id = user1!.id!;
  //       final int user2Id = user2!.id!;
  //       await battleRepository.startBattle(
  //           battleId: _battleId!,
  //           battleChannel: "private-battle.$user1Id.$user2Id",
  //           user1Id: user1Id,
  //           user2Id: user2Id);
  //       readyBattleTagLoading.value = false;
  //       setSuccess(tag: readyBattleTag);
  //     }
  //   }, callFuncName: 'stopSearchingOpponent', tag: stopSearchingOpponentTag, inProgress: false);
  // }

  setBattleData(Map<String, dynamic> messageData) async {
    inviteStatus = FormzSubmissionStatus.initial;
    _stopTimer();
    _battleId = int.tryParse(messageData['battle_id']);
    listenToWebSocket();
    battleInviteUser = BattleUserModel.fromJson(messageData['user']);
  }

  int? invitedIserId;
  void postInviteBattle({required int opponentId}) async {
    try {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        invitedIserId = opponentId;
        inviteUpdateStatus.value = true;
        inviteStatus = FormzSubmissionStatus.inProgress;
        await battleRepository.invite(opponentId: opponentId);
        listenToWebSocket();
        connectionType = BattleCreateType.fromInvitation;
        invitedIserId = null;
        inviteUpdateStatus.value = false;
        inviteStatus = FormzSubmissionStatus.success;
      } else {
        inviteStatus = FormzSubmissionStatus.failure;
        callBackError(LocaleKeys.no_internet.tr());
        invitedIserId = null;
      }
    } catch (e) {
      if (e is VMException) {
        setError(VMException(e.message, callFuncName: 'postInviteTag', tag: postInviteTag));
      }
      invitedIserId = null;
      inviteUpdateStatus.value = false;
    }
  }

  void postInviteUpdateStatus(String status) {
    _resetTimer();
    // seconds.value = 20;
    statusTag = status;
    inviteUpdateStatus.value = true;
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await battleRepository.inviteUpdateStatus(battleId: _battleId!, status: status);
        connectionType == BattleCreateType.fromInvitation;
        statusTag = "";
        inviteUpdateStatus.value = false;

        if (Navigator.of(navigatorKey.currentContext!).canPop() && status == rejectedTag) {
          stopListening();
          battleRepository.dispose();
          Navigator.pop(navigatorKey.currentContext!);
        }
      } else {
        callBackError(LocaleKeys.no_internet.tr());
        statusTag = "";
        inviteUpdateStatus.value = false;
      }
    }, callFuncName: 'postInviteUpdateStatus', tag: "postInviteUpdateStatusTag", inProgress: false);
  }

  bool get isSubscribed => _subscription != null;

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() async {
    _timer?.cancel();
    _timer = null;
    stopListening();
    battleRepository.clientConnectedToWebsocket.removeListener(_listener);
    super.dispose();
  }

  void matchCancelled() {
    Navigator.popUntil(
      navigatorKey.currentContext!,
      (route) => route.isFirst ? true : false,
    );
    showDialog<bool>(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) => OutOfLivesDialog(
        title: 'no_action_taken'.tr(),
        subTitle: 'you_lost_1_heart'.tr(),
      ),
    );
  }
}
