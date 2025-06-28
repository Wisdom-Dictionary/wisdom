import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';

import 'config/constants/constants.dart';
import 'core/services/theme_preferences.dart';
import 'presentation/routes/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static Future<void> restartApp(BuildContext context) async {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var widgetKey = GlobalKey();
  Key key = UniqueKey();

  void restartApp() {
    if (mounted) {
      setState(() {
        key = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          log("MainProvider change");
          Provider.of<MainProvider>(context, listen: false).loadTheme();
          return Consumer<MainProvider>(
            builder: (BuildContext context, provider, Widget? child) {
              return MaterialApp(
                title: 'Wisdom Dictionary',
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  useMaterial3: false,
                ),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
                onGenerateRoute: (setting) => Routes.generateRoutes(setting),
                initialRoute: _getInitialRoute(),
              );
            },
          );
        },
      ),
    );
  }

  String? _getInitialRoute() {
    if (Platform.isWindows || Platform.isMacOS) {
      if (locator.get<SharedPreferenceHelper>().getString(Constants.KEY_TOKEN, '').isEmpty) {
        return Routes.loginPage;
      }
    }
    return null;
  }
}

class MainProvider extends ChangeNotifier {
  ThemePreferences preferences = ThemePreferences();
  var isDark = true;

  loadTheme() async {
    isDark = await preferences.getTheme();
    isDarkTheme = isDark;
    notifyListeners();
  }

  changeToDarkTheme() async {
    if (!isDark) {
      await preferences.setTheme(true);
      isDark = true;
      isDarkTheme = isDark;
      notifyListeners();
    }
  }

  changeToLightTheme() async {
    if (isDark) {
      await preferences.setTheme(false);
      isDark = false;
      isDarkTheme = isDark;
      notifyListeners();
    }
  }
}
