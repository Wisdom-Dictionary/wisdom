import 'package:jbaza/jbaza.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';

import '../../../../core/di/app_locator.dart';

class MyContactSearchViewModel extends BaseViewModel {
  MyContactSearchViewModel({required super.context});

  final myContactsRepository = locator<MyContactsRepository>();
  final localViewModel = locator<LocalViewModel>();

  final String getMyContactSearchTag = "getMyContactSearchTag";

  void searchMyContacts(String searchKeyWord) {
    if (searchKeyWord.isNotEmpty) {
      setBusy(true, tag: getMyContactSearchTag);
      safeBlock(() async {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          await myContactsRepository.postMyContactsSearch(searchKeyWord);
          setSuccess(tag: getMyContactSearchTag);
        }
      }, callFuncName: 'getMyContactSearch', tag: getMyContactSearchTag, inProgress: false);
    } else {
      myContactsRepository.searchResultListClear();
      notifyListeners();
    }
  }
}
