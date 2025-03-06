// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:jbaza/jbaza.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
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
  BattleRepositoryImpl(this.dbHelper, this.customClient);

  final DBHelper dbHelper;
  final CustomClient customClient;
  WebSocketChannel? channel;
  String? socketId;
  AuthParams? params;

  int? _battleId, _startTime, _endTime;
  String? _battleChannel;

  final StreamController<String> _streamController = StreamController.broadcast();

  List<TestQuestionModel> _battleQuestionsList = [];
  List<TestQuestionModel> _battleQuestionsResultList = [];

  @override
  void connectBattle() async {
    print("🔌 WebSocket bog‘lanmoqda...");
    channel = WebSocketChannel.connect(
        Uri.parse("wss://websocket.yangixonsaroy.uz/app/e2d8827c7a35c9043726"));
    channel!.stream.listen(
      (message) async {
        print("📩 Yangi xabar: $message"); // WebSocket dan kelgan xabarni chiqarish

        final Map<String, dynamic> messageData = jsonDecode(message);

        if (messageData["event"] == "pusher:connection_established") {
          subscribeSearchingChannels(messageData);
        } else if (messageData['event'] == 'battle-started') {
          final Map<String, dynamic> data = jsonDecode(messageData['data']);
          _battleId = data["data"]["battle_id"];
          _battleChannel = messageData["channel"];
          _startTime = data["start_time"];
          _endTime = data["end_time"];

          _battleQuestionsList = [];

          for (var item in (data['questions'] as List)) {
            _battleQuestionsList.add(TestQuestionModel.fromMap(item));
          }
          _streamController.add(message);
          return;
        }

        _streamController.add(message);
      },
      onError: (error) {
        print("❌ WebSocket xatosi: $error");
      },
      onDone: () {
        print("🔴 WebSocket yopildi");
      },
      cancelOnError: true,
    );

    intervalSendPing();
  }

  Timer intervalSendPing() {
    // Har 5 soniyada ma'lumot yuborish
    return Timer.periodic(const Duration(seconds: 30), (timer) {
      channel!.sink.add('Ping from client');
      print('Ping sent');
    });
  }

  Future<void> subscribeSearchingChannels(Map<String, dynamic> messageData) async {
    final Map<String, dynamic> socketData = jsonDecode(messageData["data"]);
    socketId = socketData["socket_id"];
    const presenceChannelName = "presence-searching-opponent";
    // Subscribe to Presence Channel
    await subscribeToChannel(channelName: presenceChannelName);

    final channleData = jsonDecode(params!.channelData);

    final privateChannelName = "private-user.${channleData["user_id"]}";
    // Subscribe to Private Channel

    await subscribeToChannel(channelName: privateChannelName);

    await startSearchingOpponents();
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
    print("readyBattle - ${response.body}");
    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'postBattleReady', response: response);
    }
  }

  @override
  Future<void> cancelBattle() async {
    //battle_channel
    var response = await customClient.post(Urls.cancelBattle);
    if (!response.isSuccessful) {
      throw VMException(response.body, callFuncName: 'postCancelBattle', response: response);
    }
  }

  @override
  Future<void> checkBattleQuestions(List<AnswerEntity> answers, int spentTime) async {
    final requestBody = {
      'battle_channel': "private-$_battleChannel!",
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
    print("checkBattleQuestions - ${response.toString()}");
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
    print("startBattle - ${response.body}");
    if (response.isSuccessful || response.statusCode == 409) {
      final responseData = jsonDecode(response.body);
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
    _streamController.close();
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
      Urls.startSearchingOpponents(41),
    );

    if (response.isSuccessful) {
      return true;
    } else {
      throw VMException(response.body, callFuncName: 'getTestQuestions', response: response);
    }
  }

  @override
  List<TestQuestionModel> get battleQuestionsList => _battleQuestionsList;

  @override
  int? get endDate => _endTime;

  @override
  int? get startDate => _startTime;

  @override
  List<TestQuestionModel> get battleQuestionsResultList => _battleQuestionsResultList;
}
