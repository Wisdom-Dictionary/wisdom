import 'dart:convert';
import 'dart:developer';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/user_life_entity.dart';
import 'package:wisdom/domain/repositories/user_live_repository.dart';

class UserLiveRepositoryImpl extends UserLiveRepository {
  UserLiveRepositoryImpl(this.customClient);

  final CustomClient customClient;

  UserLifeModel? _userLifesModel;

  @override
  Future<void> getLives() async {
    _userLifesModel = null;
    try {
      var response = await customClient.get(Urls.lives);
      if (response.isSuccessful) {
        log(response.body);
        final responseData = jsonDecode(response.body);
        _userLifesModel = UserLifeModel.fromMap(responseData);
      } else {
        throw VMException(response.body, callFuncName: 'getLives', response: response);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  UserLifeModel? get userLifesModel => _userLifesModel;

  @override
  Future<void> claimLives() async {
    var response = await customClient.post(Urls.claimlives);
    if (response.isSuccessful) {
      log(response.body);
      final responseData = jsonDecode(response.body);
      _userLifesModel = UserLifeModel.fromMap(responseData);
    } else {
      throw VMException(response.body, callFuncName: 'postClaimLives', response: response);
    }
  }
}
