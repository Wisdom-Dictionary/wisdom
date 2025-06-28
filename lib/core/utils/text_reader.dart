import 'package:flutter_tts/flutter_tts.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';

class TextReader {
  late FlutterTts reader;

  static Future<TextReader> init() async {
    var instance = TextReader();
    var flutterTts = FlutterTts();
    await flutterTts.setLanguage('en-US');
    instance.reader = flutterTts;
    return instance;
  }

  Future readText(String text) async {
    final speed = locator<SharedPreferenceHelper>().getDouble(Constants.VOICE_SPEED, 0.3);
    await reader.setSpeechRate(speed);
    await reader.speak(text);
  }

  Future stop() async {
    await reader.stop();
  }
}
