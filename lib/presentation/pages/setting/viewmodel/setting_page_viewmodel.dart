import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/core/services/notification_service.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:workmanager/workmanager.dart';

import '../../../routes/routes.dart';

class SettingPageViewModel extends BaseViewModel {
  SettingPageViewModel({
    required super.context,
    required this.preferenceHelper,
    required this.localViewModel,
    required this.sharedPreferenceHelper,
  });

  RemindOption currentRemind = RemindOption.manual;
  ThemeOption currentTheme = ThemeOption.day;
  LanguageOption currentLang = LanguageOption.uzbek;
  final SharedPreferenceHelper preferenceHelper;
  final LocalViewModel localViewModel;
  final SharedPreferenceHelper sharedPreferenceHelper;
  int currentHourValue = 1;
  int currentMinuteValue = 0;
  int currentRepeatHourValue = 1;
  double fontSizeValue = 12;

  changeFontSize(double value) {
    fontSizeValue = value;
    preferenceHelper.putDouble(preferenceHelper.fontSize, value);
    notifyListeners();
  }

  void init() {
    safeBlock(() async {
      fontSizeValue = preferenceHelper.getDouble(preferenceHelper.fontSize, 16);
      currentHourValue = sharedPreferenceHelper.getInt("hour", 0);
      currentMinuteValue = sharedPreferenceHelper.getInt("minute", 0);
      currentRepeatHourValue = sharedPreferenceHelper.getInt("periodicHour", 0);
      if (sharedPreferenceHelper.getInt("mode", 0) == 0) {
        currentRemind = RemindOption.manual;
      } else {
        currentRemind = RemindOption.auto;
      }
      setSuccess();
    }, callFuncName: 'init', inProgress: false);
  }

  void goToByPro() {
    var token = sharedPreferenceHelper.getString(Constants.KEY_TOKEN, '');
    if (token == '') {
      navigateTo(Routes.gettingProPage);
    } else {
      navigateTo(Routes.profilePage);
    }
  }

  Future<void> scheduleDailyNotification(TimeOfDay timeOfDay) async {
    if(!(await AppNotificationService.to.requestPermissions())){
      return;
    }
    await AppNotificationService.to.scheduleDailyNotification(
      body: "Body",
      title: "Title",
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
    );
    sharedPreferenceHelper.putInt("hour", timeOfDay.hour);
    sharedPreferenceHelper.putInt("minute", timeOfDay.minute);
    sharedPreferenceHelper.putInt("periodicHour", 0);
    currentRepeatHourValue = 0;
    setSuccess();
    if (currentRemind == RemindOption.manual) {
      sharedPreferenceHelper.putInt("mode", 0);
    } else {
      sharedPreferenceHelper.putInt("mode", 1);
    }
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.success(
        message: "reminder_save".tr(),
      ),
    );
  }

  Future<void> scheduleHourlyNotification(int hourInterval) async {
    try {
      if (!(await AppNotificationService.to.requestNotificationPermission())) {
        return;
      }
      await AppNotificationService.to.scheduleHourlyNotification(
        hour: hourInterval,
      );
      sharedPreferenceHelper.putInt("periodicHour", hourInterval);
      sharedPreferenceHelper.putInt("hour", 0);
      sharedPreferenceHelper.putInt("minute", 0);
      currentHourValue = 0;
      currentMinuteValue = 0;
      setSuccess();
      if (currentRemind == RemindOption.manual) {
        sharedPreferenceHelper.putInt("mode", 0);
      } else {
        sharedPreferenceHelper.putInt("mode", 1);
      }
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.success(
          message: "reminder_save".tr(),
        ),
      );
      // await Workmanager()
      //     .registerPeriodicTask(
      //   "1",
      //   fetchBackground,
      //   frequency: Duration(minutes: hourInterval),
      //   constraints: Constraints(
      //     networkType: NetworkType.connected,
      //   ),
      // )
      //     .then((value) {
      // });
      // log("left");
    } catch (e) {
      log("top");
      log(e.toString());
    }
  }
}

const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        {
          print('${task} ${inputData}');
         await AppNotificationService.to.showNotification(
            const RemoteMessage(
              notification: RemoteNotification(
                title: "Wisdom dictionary",
                body: "It is time to review new words",
              ),
            ),
            '/setting',
          );
        }
        break;
    }
    return Future.value(true);
  });
}
