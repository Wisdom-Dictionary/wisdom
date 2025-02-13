import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:jbaza/jbaza.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';
import 'package:wisdom/core/utils/common.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/main.dart';
import 'package:wisdom/presentation/pages/home/view/get_pro_bottomsheet.dart';
import 'package:wisdom/presentation/pages/home/viewmodel/home_viewmodel.dart';

import '../../../../config/constants/constants.dart';
import 'drawer_screen.dart';
import 'home_screen.dart';

// ignore: must_be_immutable
class HomePage extends ViewModelBuilderWidget<HomeViewModel> {
  HomePage({super.key});

  final drawerController = ZoomDrawerController();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    super.onViewModelReady(viewModel);

    /// I have uncommented this line to start checking for new words.
    viewModel.checkForUpdate();
    viewModel.getRandomDailyWords();
    viewModel.getWordBank();
    viewModel.checkStatus();
    viewModel.localViewModel.checkNetworkConnection();
    locator.get<AdService>().initialize();
    viewModel.addDeviceToFirebase();
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureSelectNotificationSubject(viewModel);
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return ZoomDrawer(
      menuScreen: const DrawerScreen(),
      mainScreen: ShowCaseWidget(
        builder: (context) => HomeScreen(),
        blurValue: 3,
        onFinish: () {
          viewModel.isShow.value = false;
          viewModel.sharedPref.putBoolean(Constants.APP_STATE, false);
          viewModel.checkForUpdate();
        },
      ),
      borderRadius: 30.r,
      showShadow: false,
      mainScreenTapClose: true,
      mainScreenScale: 0.2,
      angle: 0,
      menuBackgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      slideWidth: MediaQuery.of(context).size.width * 0.75,
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) {
    getProBottomSheetController.stream.listen(
      (event) async {
        log.w('getProBottomSheetController $event');
        if (!context.mounted) return;
        showGetProBottomSheet(context);
      },
    );
    return HomeViewModel(context: context);
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void _configureSelectNotificationSubject(HomeViewModel viewModel) {
    selectNotificationStream.stream.listen((String? payload) async {
      locator.get<LocalViewModel>().changePageIndex(1);
    });
  }
}
