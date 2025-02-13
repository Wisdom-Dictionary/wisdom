import 'dart:io';

import 'package:wisdom/core/services/ad/google_ad_service.dart';
import 'package:wisdom/core/services/ad/yandex_ad_service.dart';

import 'ad_service.dart';

class AdServiceFactory {
  static AdService create() {
    // if (Platform.isWindows || Platform.isMacOS) return null;
    if (Platform.isAndroid) {
      return YandexAdService();
    } else if (Platform.isIOS) {
      return GoogleAdService();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
