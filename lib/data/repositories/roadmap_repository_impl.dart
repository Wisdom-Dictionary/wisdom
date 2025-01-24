import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';

import '../../config/constants/urls.dart';

class RoadmapRepositoryImpl extends RoadmapRepository {
  RoadmapRepositoryImpl(this.dbHelper, this.customClient);

  final DBHelper dbHelper;
  final CustomClient customClient;

  // getting levels from host
  @override
  Future<List<LevelModel>> getLevels() async {
    List<LevelModel> items = [];
    var response = await get(Urls.levels);
    if (response.statusCode == 200) {
      if (response.isSuccessful) {
        for (var item in jsonDecode(response.body)['data']) {
          items.add(LevelModel.fromJson(item));
        }
      }
      return items;
    } else {
      throw VMException(response.body,
          callFuncName: 'getAd', response: response);
    }
  }
}
