import 'dart:async';

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/repositories/battle_repository_impl.dart';

abstract class BattleRepository {
  Stream<String> get searchingOpponents;

  WebSocketChannel get webSocket;

  ValueNotifier<FormzSubmissionStatus> get clientConnectedToWebsocket;

  Future<void> invite({required int opponentId});

  Future<void> subscribeToChannel({required String channelName});

  Future<void> startSearchingOpponents();

  Future<void> stopSearchingOpponents();

  void setSelectedLevelItem(LevelModel levelItem);

  Future<AuthParams> reverbAuth(String channelName);

  Future<void> startBattle({
    required int battleId,
    required String battleChannel,
    required int user1Id,
    required int user2Id,
  });

  Future<void> checkBattleQuestions(List<AnswerEntity> answers, int spentTime);

  Future<void> readyBattle({required int battleId, required String battleChannel});

  Future<void> getBattleData();

  Future<void> rematchRequest({required int opponentId});

  Future<void> rematchUpdateStatus({required int battleId, required String status});

  Future<void> inviteUpdateStatus({required int battleId, required String status});

  ValueNotifier<List<TestQuestionModel>> get battleQuestionsList;

  List<TestQuestionModel> get battleQuestionsResultList;

  int? get startDate;

  int? get endDate;

  Future<void> cancelBattle();

  Future<void> postFullBattleResult();

  void searchingOpponentsChannelClose();

  void connectBattle(Function(Map<String, dynamic>) channelsFunction);

  void reconnectSearchingOpponent();

  Future<void> subscribeSearchingChannels(Map<String, dynamic> messageData);

  Future<void> subscribeContinueBattleChannels(Map<String, dynamic> messageData);

  Future<void> subscribeInvitationBattleChannels(Map<String, dynamic> messageData);

  void dispose();
}
