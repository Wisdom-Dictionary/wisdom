import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/roadmap/user_life_entity.dart';
import 'package:wisdom/domain/repositories/user_live_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';
import 'package:wisdom/presentation/routes/routes.dart';

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
      if (e is VMException) {
        if (e.response != null) {
          log("e.response!.statusCode - ${e.response!.statusCode}");
          if (e.response!.statusCode == 403) {
            showSignInDialog();
          }
        }
      } else {
        showSignInDialog();
      }
    }
  }

  showSignInDialog() async {
    await resetLocator();
    await navigateTo(Routes.mainPage, isRemoveStack: true);
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => const DialogBackground(
        child: SignInDialog(),
      ),
    );
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

  Future<T?> navigateTo<T extends Object?>(String route,
      {bool isRemoveStack = false, Object? arg, int? waitTime, BuildContext? ctx}) async {
    if (ctx != null || navigatorKey.currentContext != null) {
      if (waitTime != null) {
        await Future.delayed(Duration(seconds: waitTime));
      }
      if (isRemoveStack) {
        return Navigator.pushNamedAndRemoveUntil<T>(
            ctx ?? navigatorKey.currentContext!, route, (route) => false,
            arguments: arg);
      } else {
        return Navigator.pushNamed<T>(ctx ?? navigatorKey.currentContext!, route, arguments: arg);
      }
    }
    return Future.value(null);
  }
}
