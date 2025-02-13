import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/core/services/dio_client.dart';
import 'package:wisdom/data/model/subscribe_check_model.dart';
import 'package:wisdom/data/model/timeline_model.dart';

import '../../config/constants/urls.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  HomeRepositoryImpl(this.dbHelper, this.customClient, this._dioClient);

  final DBHelper dbHelper;
  final CustomClient customClient;
  final DioClient _dioClient;
  TimelineModel _timeLineModel = TimelineModel();
  Ad _ad = Ad();

  @override
  Future<TimelineModel> getRandomWords() async {
    var getDifference = await dbHelper.getDifference();
    var timeLineDifference = Difference(id: getDifference!.dId, word: getDifference.dWord);

    var getThesaurus = await dbHelper.getThesaurus();
    var timeLineThesaurus = Collocation(
        id: getThesaurus!.tId ?? 0,
        worden: Worden(id: getThesaurus.tId ?? 0, word: getThesaurus.word));

    var getGrammar = await dbHelper.getGrammar();
    var timeLineGrammar = Collocation(
        id: getGrammar!.gId ?? 0,
        worden: Worden(id: getGrammar.id, word: getGrammar.word.toString()));

    var getImage = await dbHelper.getImage();
    var timeLineImage =
        ImageT(id: getImage!.id ?? 0, image: getImage.image.toString(), word: getImage.word);

    var getCollection = await dbHelper.getCollocation();
    var timeLineCollection = Collocation(
        id: getCollection!.cId ?? 0,
        worden: Worden(id: getCollection.id, word: getCollection.word.toString()));

    var getMetaphor = await dbHelper.getMetaphor();
    var timeLineMetaphor = Collocation(
        id: getMetaphor!.mId ?? 0,
        worden: Worden(id: getMetaphor.mId, word: getMetaphor.word.toString()));

    var word = await dbHelper.getWord();

    var wordEnWord = WordsEn(id: word!.id, word: word.word.toString());

    var timeLineWord = Word(count: word.id, wordsEnId: word.id, wordsEn: wordEnWord);

    var getSpeaking = await dbHelper.getSpeaking();

    var timeLineSpeaking = Speaking(id: getSpeaking!.id, word: getSpeaking.word);

    var ad;
    // if (await locator<NetWorkChecker>().isNetworkAvailable()) {
    //   var response = getLenta();
    //   if (response != null && response.ad != null) {
    //     ad = Ad(id: response.ad?.id, image: response.ad?.image!, link: response.ad?.link);
    //   }
    // }

    _timeLineModel = TimelineModel(
        word: timeLineWord,
        ad: ad,
        image: timeLineImage,
        difference: timeLineDifference,
        grammar: timeLineGrammar,
        thesaurus: timeLineThesaurus,
        collocation: timeLineCollection,
        metaphor: timeLineMetaphor,
        speaking: timeLineSpeaking,
        status: true,
        error: 0);

    return _timeLineModel;
  }

  // getting local ad from host
  @override
  Future<Ad?> getAd() async {
    var response = await get(Urls.getLenta);
    if (response.statusCode == 200) {
      var model = TimelineModel.fromJson(jsonDecode(response.body));
      if (model.ad != null) {
        response = await get(Uri.parse(model.ad!.link!));
        if (response.statusCode == 200) {
          _ad = Ad(id: model.ad?.id, image: model.ad?.image!, link: model.ad?.link);
        }
        return _ad;
      } else {
        return null;
      }
    } else {
      throw VMException(response.body, callFuncName: 'getAd', response: response);
    }
  }

  @override
  Future<SubscribeCheckModel?> checkSubscription() async {
    var response = await _dioClient.get(
      Urls.subscribeCheck.path,
    );
    if (response.isSuccessful) {
      var subscribeModel = SubscribeCheckModel.fromJson(jsonDecode(response.data));
      return subscribeModel;
    } else {
      throw VMException(
        response.data,
        callFuncName: 'checkSubscription',
      );
    }
  }

  @override
  TimelineModel get timelineModel => _timeLineModel;

  @override
  set timeLineModel(TimelineModel model) {
    _timeLineModel = model;
  }
}
