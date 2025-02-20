import 'package:wisdom/data/model/parents_model.dart';
import 'package:wisdom/data/model/phrases_with_all.dart';
import 'package:wisdom/data/model/table_model/collocation_table_model.dart';
import 'package:wisdom/data/model/table_model/culture_table_model.dart';
import 'package:wisdom/data/model/table_model/grammar_table_model.dart';
import 'package:wisdom/data/model/table_model/parent_phrases_table_model.dart';
import 'package:wisdom/data/model/table_model/parent_phrases_translate_table_model.dart';
import 'package:wisdom/data/model/table_model/parents_table_model.dart';
import 'package:wisdom/data/model/table_model/phrases_example_table_id.dart';
import 'package:wisdom/data/model/table_model/phrases_table_model.dart';
import 'package:wisdom/data/model/table_model/phrases_translate_table_model.dart';
import 'package:wisdom/data/model/table_model/words_uz_table_model.dart';
import 'package:wisdom/data/model/word_model.dart';

import '../../data/model/search_result_model.dart';
import '../../data/model/table_model/difference_table_model.dart';
import '../../data/model/table_model/metaphor_table_model.dart';
import '../../data/model/table_model/thesaurus_table_model.dart';
import '../../data/model/word_and_parents_and_phrases_model.dart';
import '../../data/model/word_and_phrases_model.dart';
import '../../data/model/word_entity_model.dart';

class WordMapper {
  List<WordModel> wordListToWordEntity(List<WordEntityModel> wordEntity) => wordEntity
      .map(
        (e) => WordModel(
            id: e.id,
            word: e.word,
            star: e.star.toString(),
            anthonims: e.anthonims,
            body: e.body,
            comment: e.comment,
            example: e.example,
            examples: e.examples,
            image: e.image,
            linkWord: e.linkWord,
            moreExamples: e.moreExamples,
            synonyms: e.synonyms,
            wordClassBody: e.wordClassBody,
            wordClassBodyMeaning: e.wordClassBodyMeaning,
            wordClassid: e.wordClass?.id,
            wordClasswordId: e.id,
            wordClasswordClass: e.wordClass?.wordClass),
      )
      .toList();

  List<WordsUzTableModel> wordListToWordUz(List<WordEntityModel> wordEntity) {
    List<WordsUzTableModel> result = [];
    for (var list in wordEntity) {
      if (list.wordsUz != null) {
        for (var e in list.wordsUz!) {
          result.add(WordsUzTableModel(id: e.id, wordId: list.id, word: e.word));
        }
      }
    }
    return result;
  }

  List<CollocationTableModel> wordListToCollocation(List<WordEntityModel> wordEntity) {
    List<CollocationTableModel> result = [];
    for (var list in wordEntity) {
      if (list.collocation != null) {
        for (var e in list.collocation!) {
          result.add(CollocationTableModel(id: e.id, wordId: list.id, body: e.body));
        }
      }
    }
    return result;
  }

  List<CultureTableModel> wordListToCulture(List<WordEntityModel> wordEntity) {
    List<CultureTableModel> result = [];
    for (var list in wordEntity) {
      if (list.culture != null) {
        for (var e in list.culture!) {
          result.add(CultureTableModel(id: e.id, body: e.body, wordId: list.id));
        }
      }
    }
    return result;
  }

  List<DifferenceTableModel> wordListToDifference(List<WordEntityModel> wordEntity) {
    List<DifferenceTableModel> result = [];
    for (var list in wordEntity) {
      if (list.difference != null) {
        for (var e in list.difference!) {
          result.add(DifferenceTableModel(id: e.id, word: e.word, body: e.body, wordId: list.id));
        }
      }
    }
    return result;
  }

  List<GrammarTableModel> wordListToGrammar(List<WordEntityModel> wordEntity) {
    List<GrammarTableModel> result = [];
    for (var list in wordEntity) {
      if (list.grammar != null) {
        for (var e in list.grammar!) {
          result.add(GrammarTableModel(id: e.id, body: e.body, wordId: list.id));
        }
      }
    }
    return result;
  }

  List<MetaphorTableModel> wordListToMetaphor(List<WordEntityModel> wordEntity) {
    List<MetaphorTableModel> result = [];
    for (var list in wordEntity) {
      if (list.metaphor != null) {
        for (var e in list.metaphor!) {
          result.add(MetaphorTableModel(id: e.id, body: e.body, wordId: list.id));
        }
      }
    }
    return result;
  }

  List<ThesaurusTableModel> wordListToThesaurus(List<WordEntityModel> wordEntity) {
    List<ThesaurusTableModel> result = [];
    for (var list in wordEntity) {
      if (list.thesaurus != null) {
        for (var e in list.thesaurus!) {
          result.add(ThesaurusTableModel(id: e.id, body: e.body, wordId: list.id));
        }
      }
    }
    return result;
  }

  List<PhrasesTableModel> wordListToPhrases(List<WordEntityModel> wordEntity) {
    List<PhrasesTableModel> result = [];
    for (var list in wordEntity) {
      if (list.phrases != null) {
        for (var e in list.phrases!) {
          result.add(
            PhrasesTableModel(
                pId: e.id,
                pWordId: list.id,
                pWord: e.word,
                pStar: e.star,
                pSynonyms: e.synonyms,
                pWordClassComment: e.wordClassComment,
                pParentPhrase: e.parentPhrase),
          );
        }
      }
    }
    return result;
  }

  List<PhrasesTranslateTableModel> wordListToPhrasesTranslate(List<WordEntityModel> wordEntity) {
    List<PhrasesTranslateTableModel> result = [];
    for (var list in wordEntity) {
      if (list.phrases != null) {
        for (var phrase in list.phrases!) {
          if (phrase.translate != null) {
            for (var e in phrase.translate!) {
              result.add(PhrasesTranslateTableModel(id: 0, word: e.word, phraseId: e.phraseId));
            }
          }
        }
      }
    }
    return result;
  }

  List<PhrasesExampleTableId> wordListToPhrasesExample(List<WordEntityModel> wordEntity) {
    List<PhrasesExampleTableId> result = [];
    for (var list in wordEntity) {
      if (list.phrases != null) {
        for (var phrase in list.phrases!) {
          if (phrase.examples != null) {
            for (var e in phrase.examples!) {
              result.add(PhrasesExampleTableId(id: 0, value: e.value, phrasesId: phrase.id));
            }
          }
        }
      }
    }
    return result;
  }

  List<ParentPhrasesTableModel> wordListToParentPhrases(List<WordEntityModel> wordEntity) {
    List<ParentPhrasesTableModel> result = [];
    for (var list in wordEntity) {
      if (list.phrases != null) {
        for (var phrase in list.phrases!) {
          if (phrase.parentPhrases != null) {
            for (var e in phrase.parentPhrases!) {
              result.add(ParentPhrasesTableModel(
                  id: e.id,
                  phraseId: phrase.id,
                  word: e.word,
                  star: e.star,
                  synonyms: e.synonyms,
                  parentPhrase: e.parentPhrase.toString(),
                  wordClassComment: e.wordClassComment));
            }
          }
        }
      }
    }
    return result;
  }

  List<ParentPhrasesTranslateTableModel> wordListToParentPhrasesTranslate(
      List<WordEntityModel> wordEntity) {
    List<ParentPhrasesTranslateTableModel> result = [];
    for (var list in wordEntity) {
      if (list.phrases != null) {
        for (var phrase in list.phrases!) {
          if (phrase.parentPhrases != null) {
            for (var parentPhrase in phrase.parentPhrases!) {
              if (parentPhrase.translate != null) {
                for (var e in parentPhrase.translate!) {
                  result.add(ParentPhrasesTranslateTableModel(
                      id: 0, phraseId: list.id, word: e.word, parentPhraseId: parentPhrase.id));
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  List<PhrasesExampleTableId> wordListToParentPhraseExample(List<WordEntityModel> wordEntity) {
    List<PhrasesExampleTableId> result = [];
    for (var list in wordEntity) {
      if (list.phrases != null) {
        for (var phrase in list.phrases!) {
          if (phrase.parentPhrases != null) {
            for (var parentPhrase in phrase.parentPhrases!) {
              if (parentPhrase.examples != null) {
                for (var e in parentPhrase.examples!) {
                  result.add(
                      PhrasesExampleTableId(id: 0, value: e.value, phrasesId: parentPhrase.id));
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  List<ParentsTableModel> wordListToParents(List<WordEntityModel> wordEntity) {
    List<ParentsTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var e in list.parents!) {
          result.add(ParentsTableModel(
              id: e.id,
              wordId: list.id,
              word: e.word,
              star: e.star.toString(),
              body: e.body,
              synonyms: e.synonyms,
              example: e.example,
              examples: e.examples,
              comment: e.comment,
              linkWord: e.linkWord,
              anthonims: e.anthonims,
              wordClassBody: e.wordClassBody,
              wordClassBodyMeaning: e.wordClassBodyMeaning,
              image: e.image,
              moreExamples: e.moreExamples,
              wordClassid: e.wordClass?.id,
              wordClasswordClass: e.wordClass?.wordClass,
              wordClasswordId: e.id));
        }
      }
    }
    return result;
  }

  List<WordsUzTableModel> wordListToWordUzParent(List<WordEntityModel> wordEntity) {
    List<WordsUzTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.wordsUz != null) {
            for (var e in parent.wordsUz!) {
              result.add(WordsUzTableModel(id: e.id, word: e.word, wordId: parent.id));
            }
          }
        }
      }
    }
    return result;
  }

  List<CollocationTableModel> wordListToCollocationParent(List<WordEntityModel> wordEntity) {
    List<CollocationTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.collocation != null) {
            for (var e in parent.collocation!) {
              result.add(CollocationTableModel(id: e.id, wordId: parent.id, body: e.body));
            }
          }
        }
      }
    }
    return result;
  }

  List<CultureTableModel> wordListToCultureParent(List<WordEntityModel> wordEntity) {
    List<CultureTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.culture != null) {
            for (var e in parent.culture!) {
              result.add(CultureTableModel(id: e.id, wordId: parent.id, body: e.body));
            }
          }
        }
      }
    }
    return result;
  }

  List<DifferenceTableModel> wordListToDifferenceParent(List<WordEntityModel> wordEntity) {
    List<DifferenceTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.difference != null) {
            for (var e in parent.difference!) {
              result.add(
                  DifferenceTableModel(id: e.id, wordId: parent.id, body: e.body, word: e.word));
            }
          }
        }
      }
    }
    return result;
  }

  List<GrammarTableModel> wordListToGrammarParent(List<WordEntityModel> wordEntity) {
    List<GrammarTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.grammar != null) {
            for (var e in parent.grammar!) {
              result.add(GrammarTableModel(id: e.id, wordId: parent.id, body: e.body));
            }
          }
        }
      }
    }
    return result;
  }

  List<MetaphorTableModel> wordListToMetaphorParent(List<WordEntityModel> wordEntity) {
    List<MetaphorTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.metaphor != null) {
            for (var e in parent.metaphor!) {
              result.add(MetaphorTableModel(id: e.id, wordId: parent.id, body: e.body));
            }
          }
        }
      }
    }
    return result;
  }

  List<ThesaurusTableModel> wordListToThesaurusParent(List<WordEntityModel> wordEntity) {
    List<ThesaurusTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.thesaurus != null) {
            for (var e in parent.thesaurus!) {
              result.add(ThesaurusTableModel(id: e.id, wordId: parent.id, body: e.body));
            }
          }
        }
      }
    }
    return result;
  }

  List<PhrasesTableModel> wordListToPhrasesParent(List<WordEntityModel> wordEntity) {
    List<PhrasesTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.phrases != null) {
            for (var e in parent.phrases!) {
              result.add(
                PhrasesTableModel(
                    pId: e.id,
                    pWordId: parent.id,
                    pWord: e.word,
                    pStar: e.star,
                    pSynonyms: e.synonyms,
                    pWordClassComment: e.wordClassComment,
                    pParentPhrase: e.parentPhrase),
              );
            }
          }
        }
      }
    }
    return result;
  }

  List<PhrasesTranslateTableModel> wordListToPhrasesTranslateParent(
      List<WordEntityModel> wordEntity) {
    List<PhrasesTranslateTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.phrases != null) {
            for (var phrase in parent.phrases!) {
              if (phrase.translate != null) {
                for (var e in phrase.translate!) {
                  result.add(
                    PhrasesTranslateTableModel(id: 0, word: e.word, phraseId: phrase.id),
                  );
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  List<PhrasesExampleTableId> wordListToPhraseExampleParent(List<WordEntityModel> wordEntity) {
    List<PhrasesExampleTableId> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.phrases != null) {
            for (var phrase in parent.phrases!) {
              if (phrase.examples != null) {
                for (var e in phrase.examples!) {
                  result.add(
                    PhrasesExampleTableId(id: 0, value: e.value, phrasesId: phrase.id),
                  );
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  List<ParentPhrasesTableModel> wordListToParentPhrasesParent(List<WordEntityModel> wordEntity) {
    List<ParentPhrasesTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.phrases != null) {
            for (var phrase in parent.phrases!) {
              if (phrase.parentPhrases != null) {
                for (var e in phrase.parentPhrases!) {
                  result.add(
                    ParentPhrasesTableModel(
                        id: e.id,
                        phraseId: phrase.id,
                        word: e.word,
                        star: e.star,
                        synonyms: e.synonyms,
                        parentPhrase: e.parentPhrase.toString(),
                        wordClassComment: e.wordClassComment),
                  );
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  List<ParentPhrasesTranslateTableModel> wordListToParentPhrasesTranslateParent(
      List<WordEntityModel> wordEntity) {
    List<ParentPhrasesTranslateTableModel> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.phrases != null) {
            for (var phrase in parent.phrases!) {
              if (phrase.parentPhrases != null) {
                for (var parentPhrase in phrase.parentPhrases!) {
                  if (parentPhrase.translate != null) {
                    for (var e in parentPhrase.translate!) {
                      result.add(
                        ParentPhrasesTranslateTableModel(
                            id: 0,
                            phraseId: e.phraseId,
                            word: e.word,
                            parentPhraseId: parentPhrase.id),
                      );
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  List<PhrasesExampleTableId> wordListToPhrasesExampleParent(List<WordEntityModel> wordEntity) {
    List<PhrasesExampleTableId> result = [];
    for (var list in wordEntity) {
      if (list.parents != null) {
        for (var parent in list.parents!) {
          if (parent.phrases != null) {
            for (var phrase in parent.phrases!) {
              if (phrase.parentPhrases != null) {
                for (var parentPhrase in phrase.parentPhrases!) {
                  if (parentPhrase.examples != null) {
                    for (var e in parentPhrase.examples!) {
                      result.add(
                        PhrasesExampleTableId(id: 0, phrasesId: parentPhrase.id, value: e.value),
                      );
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  ParentsWithAll wordWithAllToParentsWithAll(WordWithAll wordWithAll) => ParentsWithAll(
        ParentsModel(
            id: wordWithAll.word!.id,
            wordId: wordWithAll.word!.id,
            word: wordWithAll.word!.word!,
            star: wordWithAll.word!.star,
            synonyms: wordWithAll.word!.synonyms,
            anthonims: wordWithAll.word!.anthonims,
            body: wordWithAll.word!.body,
            comment: wordWithAll.word!.comment,
            examples: wordWithAll.word!.examples,
            moreExamples: wordWithAll.word!.moreExamples,
            image: wordWithAll.word!.image,
            linkWord: wordWithAll.word!.linkWord,
            wordClassid: wordWithAll.word!.wordClassid,
            wordClasswordId: wordWithAll.word!.wordClasswordId,
            wordClasswordClass: wordWithAll.word!.wordClasswordClass,
            example: wordWithAll.word!.example,
            wordClassBody: wordWithAll.word!.wordClassBody,
            wordClassBodyMeaning: wordWithAll.word!.wordClassBodyMeaning),
        wordWithAll.wordsUz,
        wordWithAll.collocation,
        wordWithAll.culture,
        wordWithAll.difference,
        wordWithAll.grammar,
        wordWithAll.metaphor,
        wordWithAll.thesaurus,
        wordWithAll.phrasesWithAll,
      );

  List<SearchResultModel> wordEntityListToSearchResultList(
          List<WordModel> model, String type, String searchText) =>
      List<SearchResultModel>.from(
        model.map((e) {
          var star = e.word == searchText ? int.parse(e.star!) + 10 : int.parse(e.star!);
          return SearchResultModel(
              id: e.id,
              word: e.word,
              wordClassid: e.wordClassid,
              translation: e.body,
              star: star.toString(),
              wordClasswordId: e.wordClasswordId,
              wordClasswordClass: e.wordClasswordClass,
              type: type);
        }),
      );

  List<SearchResultModel> wordEntityListToSearchPhraseList(
          List<WordAndPhrasesModel> model, String type, String search) =>
      List<SearchResultModel>.from(
        model.map(
          (e) {
            var phraseWord = "";
            if (e.pWord!.toLowerCase().startsWith(search.toLowerCase())) {
              phraseWord = e.pWord.toString();
            }
            var star = e.pWord == search ? int.tryParse(e.star ?? "0")! + 10 : e.star!;
            return SearchResultModel(
                id: e.id!,
                word: phraseWord,
                wordClassid: e.wordClassid,
                translation: e.body ?? "",
                star: star.toString(),
                wordClasswordId: e.wordClasswordId,
                wordClasswordClass: e.wordClasswordClass,
                type: type);
          },
        ),
      );

  Future<List<SearchResultModel>> wordEntityListToSearchPhraseParentList(
      List<WordAndParentsAndPhrasesModel> list, String type, String search) {
    var arrayForSearch = <SearchResultModel>[];
    var prevResult = <String>[];
    for (var wordDto in list) {
      mapWordDtoToSearchResultFroParentPhrase(wordDto, type, search, prevResult).forEach((element) {
        if (element.word!.isNotEmpty) {
          arrayForSearch.add(element);
          prevResult.add(element.word!);
          mapWordDtoToSearchResultFroParentPhraseList(wordDto, type, search, prevResult)
              .forEach((second) {
            prevResult.add(second.word!);
            arrayForSearch.add(second);
          });
        }
      });
    }
    return Future.value(arrayForSearch);
  }

  List<SearchResultModel> mapWordDtoToSearchResultFroParentPhrase(
      WordAndParentsAndPhrasesModel parentsAndPhrasesModel,
      String type,
      String search,
      List<String> exclude) {
    var phraseWord = "";
    List<SearchResultModel> searchResultList = [];
    if (parentsAndPhrasesModel.pWord!.startsWith(search) &&
        (!exclude.contains(parentsAndPhrasesModel.pWord.toString()))) {
      phraseWord = parentsAndPhrasesModel.pWord.toString();
      var star = parentsAndPhrasesModel.pWord == search
          ? int.tryParse(parentsAndPhrasesModel.star ?? "0")! + 10
          : parentsAndPhrasesModel.star!;
      searchResultList.add(SearchResultModel(
        id: parentsAndPhrasesModel.id,
        word: phraseWord,
        star: star.toString(),
        translation: parentsAndPhrasesModel.word ?? "",
        wordClassid: parentsAndPhrasesModel.wordClassid,
        wordClasswordId: parentsAndPhrasesModel.wordClasswordId,
        wordClasswordClass: parentsAndPhrasesModel.wordClasswordClass,
        type: type,
      ));
    }
    return searchResultList;
  }

  List<SearchResultModel> mapWordDtoToSearchResultFroParentPhraseList(
      WordAndParentsAndPhrasesModel parentsAndPhrasesModel,
      String type,
      String search,
      List<String> exclude) {
    List<SearchResultModel> searchResultList = [];
    if (parentsAndPhrasesModel.pWord!.startsWith(search) &&
        !exclude.contains(parentsAndPhrasesModel.pWord)) {
      // var star = parentsAndPhrasesModel.pWord == search ? parentsAndPhrasesModel.star! + 10 : parentsAndPhrasesModel.star!;
      searchResultList.add(
        SearchResultModel(
            id: parentsAndPhrasesModel.id,
            word: parentsAndPhrasesModel.pWord.toString(),
            star: parentsAndPhrasesModel.star!,
            translation: parentsAndPhrasesModel.word ?? "",
            wordClassid: parentsAndPhrasesModel.wordClassid,
            wordClasswordId: parentsAndPhrasesModel.wordClasswordId,
            wordClasswordClass: parentsAndPhrasesModel.wordClasswordClass,
            type: type),
      );
    }
    return searchResultList;
  }

// Word
// List<SearchResultUzModel> mapWordDtoListToSearchUz(
//     List<WordAndWordsUzModel>? searchByWordUzEntity, String searchText, String type) {
//   List<SearchResultUzModel> searchResultUzList = [];
//   List<SearchResultUzModel> execute = [];
//
//   for (var element in searchByWordUzEntity!) {
//     mapWordDtoToSearchResultUz(element, type, searchText, execute).forEach((element) {
//       searchResultUzList.add(element);
//       execute.add(element);
//     });
//   }
//
//   return searchResultUzList;
// }

// List<SearchResultUzModel> mapWordDtoToSearchResultUz(
//     WordAndWordsUzModel model, String type, String searchText, List<SearchResultUzModel> executor) {
//   List<SearchResultUzModel> searchResultList = [];
//
//   if (model.word!.toLowerCase().startsWith(searchText.toLowerCase())) {
//     var star = model.word == searchText ? int.parse(model.star!) + 10 : 0;
//     var result =
//         SearchResultUzModel(id: model.id, word: model.word ?? "", type: type, wordClass: model.wordClass, star: star);
//     if (!executor.contains(result)) searchResultList.add(result);
//   }
//   return searchResultList;
// }
//
// List<SearchResultUzModel> mapWordDtoListToSearchParentUz(
//     List<WordAndParentsAndWordsUzModel>? searchByWordUzEntity, String searchText, String type) {
//   List<SearchResultUzModel> searchResultUzList = [];
//   List<SearchResultUzModel> execute = [];
//
//   for (var element in searchByWordUzEntity!) {
//     mapWordDtoToSearchResultParentUz(element, type, searchText, execute).forEach((element) {
//       searchResultUzList.add(element);
//       execute.add(element);
//     });
//   }
//
//   return searchResultUzList;
// }
//
// List<SearchResultUzModel> mapWordDtoToSearchResultParentUz(
//     WordAndParentsAndWordsUzModel model, String type, String searchText, List<SearchResultUzModel> executor) {
//   List<SearchResultUzModel> searchResultList = [];
//
//   if (model.word!.toLowerCase().startsWith(searchText.toLowerCase())) {
//     var star = model.word == searchText ? int.parse(model.star!) + 10 : 0;
//     var result =
//         SearchResultUzModel(id: model.id, word: model.word ?? "", type: type, wordClass: model.wordClass, star: star);
//     if (!executor.contains(result)) searchResultList.add(result);
//   }
//   return searchResultList;
// }
//
// List<SearchResultUzModel> mapWordDtoListToSearchPhrasesUz(
//     List<WordAndPhrasesAndTranslateModel>? translateModel, String searchText, String type) {
//   List<SearchResultUzModel> searchResultUzList = [];
//
//   for (var element in translateModel!) {
//     mapWordDtoToSearchUzResultForPhrase(element, type, searchText).forEach((element) {
//       searchResultUzList.add(element);
//     });
//   }
//
//   return searchResultUzList;
// }
//
// List<SearchResultUzModel> mapWordDtoToSearchUzResultForPhrase(
//     WordAndPhrasesAndTranslateModel model, String type, String searchText) {
//   List<SearchResultUzModel> searchResultList = [];
//
//   if (model.word!.toLowerCase().startsWith(searchText.toLowerCase())) {
//     var star = model.word == searchText ? model.pStar! + 10 : 0;
//     var result =
//         SearchResultUzModel(id: model.id, word: model.word ?? "", type: type, wordClass: model.wordClass, star: star);
//     searchResultList.add(result);
//   }
//   return searchResultList;
// }
//
// List<SearchResultUzModel> mapWordDtoListToSearchUzParentPhrase(
//     List<WordAndParentsAndPhrasesAndTranslateModel>? translateModel, String searchText, String type) {
//   List<SearchResultUzModel> searchResultUzList = [];
//   List<SearchResultUzModel> execute = [];
//
//   for (var element in translateModel!) {
//     mapWordDtoToSearchResultParentTranslate(element, type, searchText, execute).forEach((element) {
//       searchResultUzList.add(element);
//       execute.add(element);
//     });
//   }
//   return searchResultUzList;
// }
//
// List<SearchResultUzModel> mapWordDtoToSearchResultParentTranslate(WordAndParentsAndPhrasesAndTranslateModel model,
//     String type, String searchText, List<SearchResultUzModel> execute) {
//   List<SearchResultUzModel> searchResultList = [];
//
//   if (model.word!.toLowerCase().startsWith(searchText.toLowerCase())) {
//     var star = model.word == searchText ? model.pStar! + 10 : 0;
//     var result =
//         SearchResultUzModel(id: model.id, word: model.word ?? "", type: type, wordClass: model.wordClass, star: star);
//     if (!execute.contains(result)) searchResultList.add(result);
//   }
//   return searchResultList;
// }
//
// List<SearchResultUzModel> mapWordDtoListToSearchUzParentPhraseTranslate(
//     List<WordAndParentsAndPhrasesParentPhrasesAndTranslateModel>? translateModel, String searchText, String type) {
//   List<SearchResultUzModel> searchResultUzList = [];
//   List<String> execute = [];
//
//   for (var element in translateModel!) {
//     mapWordDtoToSearchResultParentPhraseTranslate(element, type, searchText, execute).forEach((element) {
//       searchResultUzList.add(element);
//     });
//   }
//   return searchResultUzList;
// }
//
// List<SearchResultUzModel> mapWordDtoToSearchResultParentPhraseTranslate(
//     WordAndParentsAndPhrasesParentPhrasesAndTranslateModel model,
//     String type,
//     String searchText,
//     List<String> execute) {
//   List<SearchResultUzModel> searchResultList = [];
//
//   if (model.word!.toLowerCase().startsWith(searchText.toLowerCase()) && (!execute.contains(model.word ?? ""))) {
//     var star = model.word == searchText ? model.star! + 10 : 0;
//     var result =
//         SearchResultUzModel(id: model.id, word: model.word ?? "", type: type, wordClass: model.wordClass, star: star);
//     searchResultList.add(result);
//   }
//   return searchResultList;
// }
}
