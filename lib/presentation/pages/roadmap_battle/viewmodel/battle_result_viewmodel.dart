import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/data/model/battle/battle_result_model.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';

import '../../../../core/di/app_locator.dart';

class BattleResultViewmodel extends BaseViewModel {
  BattleResultViewmodel({required super.context}) {
    _listenToWebSocket();
  }

  final battleRepository = locator<BattleRepository>();
  final profileRepository = locator<ProfileRepository>();

  final localViewModel = locator<LocalViewModel>();

  final String postWordExercisesResultTag = "postWordExercisesResultTag";

  ValueNotifier<int> seconds = ValueNotifier<int>(0);

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
      battleDuration;
  bool? draw;

  bool user1IsCurrentUser = false;

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

  goBack() async {
    Navigator.pop(context!);
  }

  void _listenToWebSocket() {
    battleRepository.searchingOpponents.listen((message) async {
      final messageData = jsonDecode(message);

      if (messageData['event'] == 'battle-finished') {
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
        notifyListeners(); // UI-ni yangilash
      }
    }, cancelOnError: true, onDone: () {}, onError: (error) {});
  }

  void postTestQuestionsResult() {
    setBusy(true, tag: postWordExercisesResultTag);
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await battleRepository.postFullBattleResult();
        setSuccess(tag: postWordExercisesResultTag);
      } else {
        showDialog(
          context: context!,
          builder: (context) => const DialogBackground(
            child: NoInternetConnectionDialog(),
          ),
        );
        setBusy(false, tag: postWordExercisesResultTag);
      }
    }, callFuncName: 'postWordExercisesResult', tag: postWordExercisesResultTag, inProgress: false);
  }
}
