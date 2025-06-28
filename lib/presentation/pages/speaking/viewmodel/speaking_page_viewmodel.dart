import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/utils/text_reader.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';

import '../../../../data/model/catalog_model.dart';
import '../../../../domain/repositories/category_repository.dart';

class SpeakingPageViewModel extends BaseViewModel {
  SpeakingPageViewModel(
      {required super.context,
      required this.homeRepository,
      required this.categoryRepository,
      required this.localViewModel});

  final HomeRepository homeRepository;
  final CategoryRepository categoryRepository;
  final LocalViewModel localViewModel;

  final String getSpeakingTag = 'getSpeaking';

  Future getSpeakingWordsList(String? searchText) async {
    safeBlock(() async {
      if (localViewModel.isSubSub) {
        if (searchText != null && searchText.trim().isNotEmpty) {
          await categoryRepository.getSpeakingWordsList(
              localViewModel.speakingCatalogModel.id.toString(), null, searchText.trim(), true);
        } else {
          await categoryRepository.getSpeakingWordsList(
              localViewModel.speakingCatalogModel.id.toString(), null, null, true);
        }
      } else if (localViewModel.isTitle) {
        localViewModel.subId = localViewModel.speakingCatalogModel.id ?? 0;
        if (searchText != null && searchText.trim().isNotEmpty) {
          await categoryRepository.getSpeakingWordsList(
              localViewModel.speakingCatalogModel.id.toString(), searchText.trim(), null, false);
        } else {
          await categoryRepository.getSpeakingWordsList(
              localViewModel.speakingCatalogModel.id.toString(), null, null, false);
        }
      } else {
        if (searchText != null && searchText.trim().isNotEmpty) {
          await categoryRepository.getSpeakingWordsList(null, searchText.trim(), null, false);
        } else {
          await categoryRepository.getSpeakingWordsList(null, null, null, false);
        }
      }
      if (categoryRepository.speakingWordsList.isNotEmpty) {
        setSuccess(tag: getSpeakingTag);
      } else {
        callBackError("text");
      }
    }, callFuncName: 'getSpeakingWordsList', tag: getSpeakingTag);
  }

  goMain() {
    if (localViewModel.isSubSub) {
      localViewModel.speakingCatalogModel.id = localViewModel.subId;
      localViewModel.isSubSub = false;
      getSpeakingWordsList(null); // opening this page again but with another value
      localViewModel.notifyListeners();
    } else if (localViewModel.isTitle) {
      localViewModel.isTitle = false;
      getSpeakingWordsList(null); // opening this page again but with another value
      localViewModel.notifyListeners();
    } else {
      localViewModel.changePageIndex(3);
    }
  }

  goToNext(CatalogModel catalogModel) async {
    localViewModel.speakingCatalogModel = catalogModel;
    if (!localViewModel.isTitle) {
      localViewModel.isTitle = true;
      getSpeakingWordsList(null); // opening this page again but with another value
      localViewModel.notifyListeners();
    } else if (!localViewModel.isSubSub) {
      localViewModel.isSubSub = true;
      getSpeakingWordsList(null); // opening this page again but with another value
      localViewModel.notifyListeners();
    } else {
      // FlutterTts tts = FlutterTts();
      // await tts.setSharedInstance(true); // For IOS
      // tts.setLanguage('en-US');
      // tts.speak(catalogModel.word ?? "");
      locator.get<TextReader>().readText(catalogModel.word ?? "");
    }
  }
}
