// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';

class AuthParams {
  final String auth;
  final String channelData;

  AuthParams({
    required this.auth,
    required this.channelData,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'auth': auth,
      'userId': channelData,
    };
  }

  factory AuthParams.fromMap(Map<String, dynamic> map) {
    return AuthParams(
      auth: map['auth'] as String,
      channelData: map['channel_data'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthParams.fromJson(String source) =>
      AuthParams.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BattleRepositoryImpl extends BattleRepository {
  BattleRepositoryImpl(this.customClient, this.sharedPreferenceHelper);

  final CustomClient customClient;
  final SharedPreferenceHelper sharedPreferenceHelper;
  WebSocketChannel? channel;
  String? socketId;
  AuthParams? params;
  LevelModel? selectedLevelItem;

  int? _battleId, _startTime, _endTime;
  String? _battleChannel;

  StreamController<String> _streamController = StreamController.broadcast();

  final ValueNotifier<List<TestQuestionModel>> _battleQuestionsList =
      ValueNotifier<List<TestQuestionModel>>([]);
  List<TestQuestionModel> _battleQuestionsResultList = [];

  @override
  void connectBattle(Function(Map<String, dynamic>) channelsFunction) async {
    if (_streamController.isClosed) {
      _streamController = StreamController.broadcast();
    }
    log("🔌 WebSocket bog‘lanmoqda...");
    channel = WebSocketChannel.connect(
        Uri.parse("wss://websocket.yangixonsaroy.uz/app/e2d8827c7a35c9043726"));
    channel!.stream.listen(
      (message) async {
        log("📩 Yangi xabar: $message"); // WebSocket dan kelgan xabarni chiqarish

        final Map<String, dynamic> messageData = jsonDecode(message);

        if (messageData["event"] == "pusher:connection_established") {
          channelsFunction(messageData);
          // final endDateBattle =
          //     sharedPreferenceHelper.getInt(Constants.KEY_USER_BATTLE_END_TIME, 0);
          // if (endDateBattle == 0) {
          //   subscribeSearchingChannels(messageData);
          // } else {
          //   subscribeContinueBattleChannels(messageData);
          // }
        } else if (messageData['event'] == 'battle-started') {
          final Map<String, dynamic> data = jsonDecode(messageData['data']);
          _battleId = data["data"]["battle_id"];
          _battleChannel = messageData["channel"];
          _startTime = data["start_time"];
          _endTime = data["end_time"];

          List<TestQuestionModel> list = [];

          for (var item in (data['questions'] as List)) {
            list.add(TestQuestionModel.fromMap(item));
          }
          _battleQuestionsList.value = list;
          sharedPreferenceHelper.putInt(Constants.KEY_USER_BATTLE_END_TIME, _endTime!);
          sharedPreferenceHelper.putInt(Constants.KEY_USER_BATTLE_ID, _battleId!);
          // _streamController.add(message);
          // return;
        }

        _streamController.add(message);
      },
      onError: (error) {
        log("❌ WebSocket xatosi: $error");
      },
      onDone: () {
        log("🔴 WebSocket yopildi");
      },
      cancelOnError: true,
    );

    intervalSendPing();
  }

  Timer intervalSendPing() {
    // Har 30 soniyada ma'lumot yuborish
    return Timer.periodic(const Duration(seconds: 30), (timer) {
      if (channel != null) {
        channel!.sink.add('Ping from client');
        print('Ping sent');
      }
    });
  }

  @override
  Future<void> subscribeSearchingChannels(Map<String, dynamic> messageData) async {
    final Map<String, dynamic> socketData = jsonDecode(messageData["data"]);
    socketId = socketData["socket_id"];
    const presenceChannelName = "presence-searching-opponent";
    // Subscribe to Presence Channel
    await subscribeToChannel(channelName: presenceChannelName);

    final channelData = jsonDecode(params!.channelData);

    final privateChannelName = "private-user.${channelData["user_id"]}";
    // Subscribe to Private Channel

    await subscribeToChannel(channelName: privateChannelName);

    await startSearchingOpponents();
  }

  @override
  Future<void> subscribeContinueBattleChannels(Map<String, dynamic> messageData) async {
    final Map<String, dynamic> socketData = jsonDecode(messageData["data"]);
    socketId = socketData["socket_id"];
    await subscribeToChannel(channelName: _battleChannel!);

    final channelData = jsonDecode(params!.channelData);

    final privateChannelName = "private-user.${channelData["user_id"]}";
    // Subscribe to Private Channel

    await subscribeToChannel(channelName: privateChannelName);
  }

  @override
  Future<void> subscribeInvitationBattleChannels(Map<String, dynamic> messageData) async {
    final Map<String, dynamic> socketData = jsonDecode(messageData["data"]);
    socketId = socketData["socket_id"];
    final userData = sharedPreferenceHelper.getString(Constants.KEY_USER, "");
    UserModel user = UserModel.fromJson(jsonDecode(userData));
    log("user.id - ${user.id}");
    await subscribeToChannel(channelName: "private-user.${user.id!}");
  }

  Stream<String> get messageStream => _streamController.stream;

  void dispose() {
    channel!.sink.close();
  }

  @override
  Future<void> readyBattle({required int battleId, required String battleChannel}) async {
    await subscribeToChannel(channelName: battleChannel);

    final requestBody = {
      'battle_id': battleId,
      'battle_channel': battleChannel,
    };
    var response = await customClient.post(Urls.ready,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    log("readyBattle - ${response.body}");
    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'postBattleReady', response: response);
    }
  }

  @override
  Future<void> cancelBattle() async {
    final requestBody = {
      'battle_id': _battleId,
      'battle_channel': _battleChannel,
    };
    var response = await customClient.post(Urls.cancelBattle,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'postCancelBattle', response: response);
    }
  }

  @override
  Future<void> checkBattleQuestions(List<AnswerEntity> answers, int spentTime) async {
    final requestBody = {
      'battle_channel': _battleChannel,
      'battle_id': _battleId!,
      'spent_time': spentTime,
      'answers': answers
          .map(
            (e) => e.toMap(),
          )
          .toList()
    };
    var response = await customClient.post(Urls.checkBattleQuestions,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    log("checkBattleQuestions - ${response.body}");
    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'postWordQuestionsCheck', response: response);
    }
  }

  @override
  Future<void> postFullBattleResult() async {
    _battleQuestionsResultList = [];
    final requestBody = {
      'battle_id': _battleId,
    };
    var response = await customClient.post(Urls.getFullBattleResult,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);

      for (var item in (responseData['questions'] as List)) {
        _battleQuestionsResultList.add(TestQuestionModel.fromMap(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestionsResult', response: response);
    }
  }

  @override
  Future<void> startBattle({
    required int battleId,
    required String battleChannel,
    required int user1Id,
    required int user2Id,
  }) async {
    final requestBody = {
      "battle_id": battleId,
      "battle_channel": battleChannel,
      "user1_id": user1Id,
      "user2_id": user2Id
    };
    var response = await customClient.post(Urls.startBattle,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful || response.statusCode == 409) {
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> stopSearchingOpponents() async {
    var response = await customClient.post(
      Urls.stopSearchingOpponents,
    );
    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> subscribeToChannel({required String channelName}) async {
    AuthParams authParams = await reverbAuth(channelName);

    final message = {
      "event": "pusher:subscribe",
      "data": {
        "channel": channelName,
        "auth": authParams.auth,
        "channel_data": authParams.channelData,
      }
    };
    channel!.sink.add(jsonEncode(message));
    log(jsonEncode(message));
  }

  @override
  Stream<String> get searchingOpponents => _streamController.stream;

  @override
  void searchingOpponentsChannelClose() {
    channel!.sink.close();
    // _streamController.close();
  }

  @override
  Future<AuthParams> reverbAuth(String channelName) async {
    final requestBody = {
      "socket_id": socketId,
      "channel_name": channelName,
    };
    var response = await customClient.post(Urls.reverbAuth,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (response.isSuccessful) {
      final responseData = AuthParams.fromJson(response.body);
      params = responseData;
      return responseData;
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<bool> startSearchingOpponents() async {
    var response = await customClient.get(
      Urls.startSearchingOpponents(selectedLevelItem!.id!),
    );

    if (response.isSuccessful) {
      return true;
    } else {
      throw VMException(response.body, callFuncName: 'startSearchingOpponents', response: response);
    }
  }

  @override
  ValueNotifier<List<TestQuestionModel>> get battleQuestionsList => _battleQuestionsList;

  @override
  int? get endDate => _endTime;

  @override
  int? get startDate => _startTime;

  @override
  List<TestQuestionModel> get battleQuestionsResultList => _battleQuestionsResultList;

  @override
  Future<void> rematchRequest({required int opponentId}) async {
    final requestBody = {
      "opponent_id": opponentId,
    };
    var response = await customClient.post(Urls.rematchRequest,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> rematchUpdateStatus({required int battleId, required String status}) async {
    final requestBody = {
      "battle_id": battleId,
      "status": status,
    };
    var response = await customClient.post(Urls.rematchUpdateStatus,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> getBattleData() async {
    var response = await customClient.post(
      Urls.getBattleData,
    );

    if (response.isSuccessful) {
      final data = jsonDecode(response.body);

      _battleId = data["data"]["battle_id"];
      _battleChannel = data["data"]["battleChannel"];
      _startTime = data["start_time"];
      _endTime = data["end_time"];

      List<TestQuestionModel> _list = [];

      for (var item in (data['questions'] as List)) {
        _list.add(TestQuestionModel.fromMap(item));
      }
      _battleQuestionsList.value = _list;
      connectBattle(subscribeContinueBattleChannels);

      sharedPreferenceHelper.putInt(Constants.KEY_USER_BATTLE_END_TIME, _endTime!);
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  void setSelectedLevelItem(LevelModel levelItem) {
    selectedLevelItem = levelItem;
  }

  @override
  WebSocketChannel get webSocket => channel!;

  @override
  Future<void> invite({required int opponentId}) async {
    final requestBody = {
      "opponent_id": opponentId,
    };
    var response = await customClient.post(Urls.inviteBattle,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
// {"battle_id":314,"battle_channel":"battle.106237.106241"}
    log("response.isSuccessful- ${response.isSuccessful}\nresponse.statusCode- ${response.statusCode}\nresponse.body- ${response.body}");
    if (response.isSuccessful) {
      connectBattle(subscribeInvitationBattleChannels);
    } else {
      final responseBody = jsonDecode(response.body);
      BuildContext? context = navigatorKey.currentState?.overlay?.context;
      if (context != null) {
        showTopSnackBar(
          Overlay.of(context, rootOverlay: true),
          CustomSnackBar.success(
            message: responseBody["message"] ?? "Default message",
          ),
        );
      }
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  Future<void> inviteUpdateStatus({required int battleId, required String status}) async {
    // if (status == 'accepted') {
    //   connectBattle(subscribeInvitationBattleChannels);
    // }
    final requestBody = {
      "battle_id": battleId,
      "status": status,
    };
    var response = await customClient.post(Urls.inviteUpdateStatus,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (response.isSuccessful) {
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }
}
