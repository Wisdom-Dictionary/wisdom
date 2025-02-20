import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/utils/word_mapper.dart';
import 'package:wisdom/data/model/search_result_model.dart';
import 'package:wisdom/domain/repositories/search_repository.dart';

import '../model/search_result_uz_model.dart';

class SearchRepositoryImpl extends SearchRepository {
  SearchRepositoryImpl(this.dbHelper, this.mapper);

  final DBHelper dbHelper;
  final WordMapper mapper;

  List<SearchResultModel> _searchResult = [];
  List<SearchResultUzModel> _searchUzResult = [];

  @override
  Future<List<SearchResultModel>> searchByWord(String searchText) async {
    var searchByWordEntity = await dbHelper.searchByWord(searchText);
    var searchByWordList =
        mapper.wordEntityListToSearchResultList(searchByWordEntity!, 'word', searchText);

    var searchByPhrasesEntity = await dbHelper.searchByPhrases(searchText);
    var searchByPhrasesList =
        mapper.wordEntityListToSearchPhraseList(searchByPhrasesEntity!, 'phrases', searchText);

    var searchByPhrases1Entity = await dbHelper.searchByWordParent1(searchText);
    var searchByPhrases1List = await mapper.wordEntityListToSearchPhraseParentList(
        searchByPhrases1Entity!, 'phrases', searchText);

    _searchResult.clear();
    _searchResult.addAll(searchByWordList);
    _searchResult.addAll(searchByPhrasesList);
    _searchResult.addAll(searchByPhrases1List);
    await sortEng();
    return _searchResult;
  }

  Future<void> sortEng() async {
    _searchResult.sort((a, b) => (a.word!).toLowerCase().compareTo(b.word!.toLowerCase()));
    _searchResult.sort((a, b) => (int.parse(b.star ?? "0")).compareTo(int.parse(a.star ?? "0")));
  }

  @override
  Future<List<SearchResultUzModel>> searchByUzWord(String searchText) async {
    var searchByWordUzEntity = await dbHelper.searchByWordUz1(searchText);
    // var searchByWordUzList = mapper.mapWordDtoListToSearchUz(searchByWordUzEntity, searchText, 'word');

    // var searchWordUzParent1 = await dbHelper.searchByWordParent2(searchText);
    // var searchWordUzParent1List = mapper.mapWordDtoListToSearchParentUz(searchWordUzParent1, searchText, "word");
    //
    // var searchPhraseWordUzEntity1 = await dbHelper.searchByPhrasesUz1(searchText);
    // var searchPhraseWordUzEntity1List =
    //     mapper.mapWordDtoListToSearchPhrasesUz(searchPhraseWordUzEntity1, searchText, "phrases");
    //
    // var searchPhraseParentUz = await dbHelper.searchByWordParent3(searchText);
    // var searchPhraseParentUzList =
    //     mapper.mapWordDtoListToSearchUzParentPhrase(searchPhraseParentUz, searchText, "phrases");
    //
    // var searchPhraseDtoParentPhraseTranslate1 =
    //     await dbHelper.searchWordAndParentsAndPhrasesParentPhrasesAndTranslate(searchText);
    // var searchPhraseDtoParentPhraseTranslate1List = mapper.mapWordDtoListToSearchUzParentPhraseTranslate(
    //     searchPhraseDtoParentPhraseTranslate1, searchText, "phrases");

    _searchUzResult.clear();
    _searchUzResult.addAll(searchByWordUzEntity ?? []);

    await setWords(searchText);
    await sort();
    return _searchUzResult;
  }

  Future<void> sort() async {
    _searchUzResult.sort((a, b) => (a.word ?? "").compareTo((b.word ?? "")));
    _searchUzResult.sort((a, b) => (int.parse(b.star ?? "0")).compareTo(int.parse(a.star ?? "0")));
  }

  Future setWords(String searchText) async {
    for (var element in _searchUzResult) {
      var star = element.word == searchText ? int.parse(element.star!) + 10 : element.star;
      List<String?> same = element.same!.split(',');
      element.star = star.toString();
      element.same = same.toSet().toString().replaceAll("{", "").replaceAll("}", "");
    }
  }

  @override
  Future<void> cleanList(String mode) async {
    if (mode == "en") {
      _searchResult.clear();
    } else {
      _searchUzResult.clear();
    }
  }

  @override
  List<SearchResultModel> get searchResultList => _searchResult;

  @override
  List<SearchResultUzModel> get searchResultUzList => _searchUzResult;
}
