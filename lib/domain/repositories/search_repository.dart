import 'package:wisdom/data/model/search_result_uz_model.dart';

import '../../data/model/search_result_model.dart';

abstract class SearchRepository {
  Future<List<SearchResultModel>> searchByWord(String searchText);

  Future<List<SearchResultUzModel>> searchByUzWord(String searchText);

  Future<void> cleanList(String mode);

  List<SearchResultModel> get searchResultList;

  List<SearchResultUzModel> get searchResultUzList;
}
