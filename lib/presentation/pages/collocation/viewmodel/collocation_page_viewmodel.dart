import 'package:jbaza/jbaza.dart';
import 'package:wisdom/data/model/catalog_model.dart';
import 'package:wisdom/data/model/timeline_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';

import '../../../../domain/repositories/category_repository.dart';

class CollocationPageViewModel extends BaseViewModel {
  CollocationPageViewModel(
      {required super.context,
      required this.localViewModel,
      required this.categoryRepository,
      required this.homeRepository});

  final LocalViewModel localViewModel;
  final CategoryRepository categoryRepository;
  final HomeRepository homeRepository;

  final String getCollocationTag = 'getCollocationTag';

  void getCollocationWordsList(String? searchText) {
    safeBlock(() async {
      if (searchText != null && searchText.trim().isNotEmpty) {
        await categoryRepository.getCollocationWordsList(searchText.trim());
      } else {
        await categoryRepository.getCollocationWordsList(null);
      }
      if (categoryRepository.collocationWordsList.isNotEmpty) {
        setSuccess(tag: getCollocationTag);
      } else {
        callBackError("text");
      }
    }, callFuncName: 'getCollocationWordsList', tag: getCollocationTag);
  }

  goMain() {
    localViewModel.changePageIndex(3);
  }

  void goToDetails(CatalogModel catalogModel) {
    homeRepository.timelineModel.collocation =
        Collocation(id: catalogModel.id, worden: Worden(word: catalogModel.word));
    localViewModel.isFromMain = false;
    localViewModel.changePageIndex(8);
  }
}
