import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/utils/text_reader.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';

import '../../../../domain/repositories/category_repository.dart';

class SpeakingDetailPageViewModel extends BaseViewModel {
  SpeakingDetailPageViewModel(
      {required super.context,
      required this.homeRepository,
      required this.categoryRepository,
      required this.localViewModel});

  final HomeRepository homeRepository;
  final LocalViewModel localViewModel;
  final CategoryRepository categoryRepository;
  final String getSpeakingListTag = 'getSpeakingDetails';
  TextReader textReader = locator.get();

  String? getSpeaking() {
    return homeRepository.timelineModel.speaking!.word;
  }

  Future getSpeakingWordList(String? searchText) async {
    safeBlock(() async {
      if (homeRepository.timelineModel.speaking != null) {
        if (searchText != null && searchText.trim().isNotEmpty) {
          await categoryRepository.getSpeakingWordsList(
              homeRepository.timelineModel.speaking!.id.toString(),
              null,
              searchText.trim(),
              true);
        } else {
          await categoryRepository.getSpeakingWordsList(
              homeRepository.timelineModel.speaking!.id.toString(),
              null,
              null,
              true);
        }
        if (categoryRepository.speakingWordsList.isNotEmpty) {
          setSuccess(tag: getSpeakingListTag);
        } else {
          callBackError("text");
        }
      }
    }, callFuncName: 'getSpeakingDetails', tag: getSpeakingListTag);
  }

  goBack() {
    // if (localViewModel.isFromMain) {
    localViewModel.changePageIndex(0);
    // }
  }

  tts(String? word) async {
    // FlutterTts tts = FlutterTts();
    // await tts.setSharedInstance(true); // For IOS
    // tts.setLanguage('en-US');
    // tts.speak(word ?? "");
    await textReader.readText(word ?? '');
  }
}
