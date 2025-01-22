import 'package:http/http.dart';

import '../../config/constants/assets.dart';

extension HttpIsSuccess on Response {
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}

extension FindRank on String {
  String get findRank {
    switch (this) {
      case "3":
        return Assets.icons.starFull;
      case "2":
        return Assets.icons.starHalf;
      case "1":
        return Assets.icons.starLow;
      case "13":
        return Assets.icons.starFull;
      case "12":
        return Assets.icons.starHalf;
      case "11":
        return Assets.icons.starLow;
      default:
        return "";
    }
  }
}

