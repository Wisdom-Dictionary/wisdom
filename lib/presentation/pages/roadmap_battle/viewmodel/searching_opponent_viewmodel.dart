import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/opponent_was_found_dialog.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

class SearchingOpponentViewmodel extends BaseViewModel {
  SearchingOpponentViewmodel({required super.context}) {
    _listenToWebSocket();
  }

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
  ValueNotifier<int> seconds = ValueNotifier<int>(0);
  ValueNotifier<bool> readyBattleTagLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> matchCancelledTag = ValueNotifier<bool>(false);

  BattleUserModel? user1, user2;
  int? _battleId, _readyUser1Id, _readyUser2Id;

  BattleUserModel? get opponentUser => user1!.id! == userDetailsModel.user!.id! ? user2 : user1;

  void _startTimer(Function() onChange) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onChange();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  _incrementTimer() {
    seconds.value++;
  }

  _decrementTimer() {
    if (seconds.value > 0) {
      seconds.value--;
    } else if (seconds.value == 0) {
      if (_readyUser1Id != null && _readyUser2Id != null) {
        _resetTimer();

        startBattle();
      }
    }
  }

  void _resetTimer() {
    _stopTimer();

    seconds.value = 0;
  }

  void _listenToWebSocket() {
    _resetTimer();
    _startTimer(_incrementTimer);
    battleRepository.searchingOpponents.listen(
        (message) async {
          final messageData = jsonDecode(message);

          statusMessage = message;

          if (messageData['event'] == 'user-matched') {
            userMatched(messageData);
            _stopTimer();
          } else if (messageData['event'] == 'battle-started') {
            battleStarted();
          } else if (messageData['event'] == 'ready-for-battle') {
            statusMessage = "Ready users for battle";
            final data = jsonDecode(messageData["data"]);
            if (_readyUser1Id == null) {
              _readyUser1Id = data["user_id"];
            } else {
              _readyUser2Id = data["user_id"];
            }
          } else if (messageData['event'] == 'user-search-failed') {
            statusMessage = "Search failed. No opponent found.";
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

  Future<dynamic> userMatched(Map<String, dynamic> messageData) {
    statusMessage = "Matched with opponent: ${messageData['data']}";

    _resetTimer();
    seconds.value = 3;

    final data = jsonDecode(messageData['data'] ?? '');

    _battleId = data['battleId'];
    user1 = BattleUserModel.fromMap(data['user1']);
    user2 = BattleUserModel.fromMap(data['user2']);

    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => OpponentWasFoundDialog(
        viewmodel: this,
      ),
    );
  }

  battleStarted() {
    //Search opponent page
    Navigator.popAndPushNamed(context!, Routes.battleExercisesPage);
  }

  void connectBattle() {
    battleRepository.connectBattle();
  }

  getUser() {
    setBusy(true, tag: getGetUserTag);
    safeBlock(
      () async {
        if (profileRepository.userCabinet == null) {
          userDetailsModel = await profileRepository.getUserCabinet();
        } else {
          userDetailsModel = profileRepository.userCabinet!;
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
        battleRepository.searchingOpponentsChannelClose();
        Navigator.pop(context!);
        setSuccess(tag: stopSearchingOpponentTag);
      } else {
        showDialog(
          context: context!,
          builder: (context) => const DialogBackground(
            child: NoInternetConnectionDialog(),
          ),
        );
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
        _startTimer(_decrementTimer);
        readyBattleTagLoading.value = false;
        setSuccess(tag: readyBattleTag);
      }
    }, callFuncName: 'stopSearchingOpponent', tag: stopSearchingOpponentTag, inProgress: false);
  }

  void startBattle() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        readyBattleTagLoading.value = true;
        setBusy(true, tag: readyBattleTag);
        final int user1Id = user1!.id!;
        final int user2Id = user2!.id!;
        await battleRepository.startBattle(
            battleId: _battleId!,
            battleChannel: "private-battle.$user1Id.$user2Id",
            user1Id: user1Id,
            user2Id: user2Id);
        readyBattleTagLoading.value = false;
        setSuccess(tag: readyBattleTag);
      }
    }, callFuncName: 'stopSearchingOpponent', tag: stopSearchingOpponentTag, inProgress: false);
  }
}
