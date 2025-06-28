import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/utils/text_reader.dart';
import 'package:wisdom/data/model/parent_phrases_example_model.dart';
import 'package:wisdom/data/model/parent_phrases_translate_model.dart';
import 'package:wisdom/data/model/phrases_example_model.dart';
import 'package:wisdom/data/model/phrases_translate_model.dart';
import 'package:wisdom/data/model/phrases_with_all.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/data/model/words_uz_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/entities/word_bank_folder_entity.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/constants.dart';
import '../../../../config/constants/urls.dart';
import '../../../../core/services/purchase_observer.dart';
import '../../../../core/utils/word_mapper.dart';
import '../../../routes/routes.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/loading_widget.dart';

class WordDetailPageViewModel extends BaseViewModel {
  WordDetailPageViewModel({
    required super.context,
    required this.localViewModel,
    required this.wordEntityRepository,
    required this.preferenceHelper,
    required this.wordMapper,
  });

  final LocalViewModel localViewModel;
  final WordEntityRepository wordEntityRepository;
  final SharedPreferenceHelper preferenceHelper;
  final WordMapper wordMapper;
  final String initTag = 'initTag';
  final TextEditingController folderTextController = TextEditingController();

  Future? dialog;
  List<ParentsWithAll> parentsWithAllList = [];
  bool synonymsIsExpanded = false;
  bool phrasesIsExpanded = false;
  double? fontSize;
  bool getFirstPhrase = true;

  GlobalKey scrollKey = GlobalKey();

  // taking searched word model from local viewmodel and collect all details of it from db
  init() {
    safeBlock(
      () async {
        fontSize = preferenceHelper.getDouble(preferenceHelper.fontSize, 16);
        await wordEntityRepository.getRequiredWord(localViewModel.wordDetailModel.id ?? 0);
        if (wordEntityRepository.requiredWordWithAllModel.word != null) {
          await splitingToParentWithAllModel();
          setSuccess(tag: initTag);
        }
      },
      callFuncName: 'getGrammar',
      tag: initTag,
    );
  }

  void firstAutoScroll() async {
    if (getFirstPhrase == true) {
      getFirstPhrase = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Scrollable.ensureVisible(scrollKey.currentContext!,
            duration: const Duration(milliseconds: 300));
      });
    }
  }

  void textToSpeech() async {
    if (wordEntityRepository.requiredWordWithAllModel.word != null &&
        wordEntityRepository.requiredWordWithAllModel.word!.word != null) {
      // FlutterTts tts = FlutterTts();
      // await tts.setSharedInstance(true); // For IOS
      // tts.setLanguage('en-US');
      // tts.speak(wordEntityRepository.requiredWordWithAllModel.word!.word!,);
      locator.get<TextReader>().readText(wordEntityRepository.requiredWordWithAllModel.word!.word!);
    }
  }

  Future<void> splitingToParentWithAllModel() async {
    parentsWithAllList
        .add(wordMapper.wordWithAllToParentsWithAll(wordEntityRepository.requiredWordWithAllModel));
    if (wordEntityRepository.requiredWordWithAllModel.parentsWithAll != null &&
        wordEntityRepository.requiredWordWithAllModel.parentsWithAll!.isNotEmpty) {
      parentsWithAllList.addAll(wordEntityRepository.requiredWordWithAllModel.parentsWithAll!);
    }
  }

  addToWordBankFromParent(ParentsWithAll model, String num, GlobalKey key) async {
    log('addToWordBankFromParent');
    if (!(await localViewModel.canAddWordBank(context!))) {
      return;
    }
    safeBlock(() async {
      await showFolderDialog(
        (folderModel) async {
          int number = int.parse(num.isEmpty ? "0" : num);
          var wordBank = WordBankModel(
              id: model.parents!.id,
              parentId: localViewModel.wordDetailModel.id,
              word: model.parents!.word,
              example: model.parents!.example,
              translation: conductToString(model.wordsUz),
              createdAt: DateTime.now().toString(),
              number: number,
              wordClass:
                  wordEntityRepository.requiredWordWithAllModel.word!.wordClasswordClass ?? "",
              wordClassBody: wordEntityRepository.requiredWordWithAllModel.word!.wordClassBody,
              type: "word",
              folderId: folderModel.id);
          int dbCount = await wordEntityRepository.allWordBanksCount;
          if (dbCount > 29 && !PurchasesObserver().isPro()) {
            await showCountOutOfBound();
            return;
          } else {
            if (wordEntityRepository.wordBankList
                .where(
                    (element) => element.id == wordBank.id && element.folderId == wordBank.folderId)
                .isEmpty) {
              await funAddToWordBank(wordBank, key);
              localViewModel.boundException = false;
            } else {
              showTopSnackBar(
                Overlay.of(context!),
                CustomSnackBar.info(
                  message: "move_info".tr(),
                ),
              );
            }
          }
        },
      );
    }, callFuncName: 'addToWordBankFromParent', inProgress: false);
  }

  addToWordBankFromPhrase(PhrasesWithAll model, String num, GlobalKey key) async {
    log('addToWordBankFromPhrase');
    if (!(await localViewModel.canAddWordBank(context!))) {
      return;
    }
    safeBlock(() async {
      showFolderDialog(
        (folderModel) async {
          int number = int.parse(num.isEmpty ? "0" : num);
          var wordBank = WordBankModel(
              id: model.phrases!.pId,
              word: model.phrases!.pWord,
              parentId: localViewModel.wordDetailModel.id,
              example: model.phrasesExample![0].value,
              translation: conductToStringPhrasesTranslate(model.phrasesTranslate!),
              createdAt: DateTime.now().toString(),
              type: "phrases",
              wordClass: "",
              wordClassBody: "",
              number: number,
              folderId: folderModel.id);
          int dbCount = await wordEntityRepository.getWordBankCount();
          if (dbCount > 29 && !PurchasesObserver().isPro() && !localViewModel.boundException) {
            showCountOutOfBound();
            return;
          } else {
            if (wordEntityRepository.wordBankList
                .where(
                    (element) => element.id == wordBank.id && element.folderId == wordBank.folderId)
                .isEmpty) {
              await funAddToWordBank(wordBank, key);
              localViewModel.boundException = false;
            } else {
              showTopSnackBar(
                Overlay.of(context!),
                CustomSnackBar.info(
                  message: "move_info".tr(),
                ),
              );
            }
          }
        },
      );
    }, callFuncName: 'addToWordBankFromPhrase', inProgress: false);
  }

  addToWordBankFromParentPhrase(ParentPhrasesWithAll model, String num, GlobalKey key) async {
    log('addToWordBankFromParentPhrase');
    if (!(await localViewModel.canAddWordBank(context!))) {
      return;
    }
    safeBlock(() async {
      showFolderDialog(
        (folderModel) async {
          int number = int.parse(num.isEmpty ? "0" : num);
          var wordBank = WordBankModel(
              id: model.parentPhrases!.id,
              word: model.parentPhrases!.word ?? "",
              parentId: localViewModel.wordDetailModel.id,
              example: model.phrasesExample![0].value,
              translation: conductToStringParentPhrasesTranslate(model.parentPhrasesTranslate!),
              createdAt: DateTime.now().toString(),
              type: "phrases",
              wordClass: "",
              wordClassBody: "",
              number: number,
              folderId: folderModel.id);
          int dbCount = await wordEntityRepository.getWordBankCount();
          if (dbCount > 29 && PurchasesObserver().isPro() && !localViewModel.boundException) {
            showCountOutOfBound();
            return;
          } else {
            if (wordEntityRepository.wordBankList
                .where(
                    (element) => element.id == wordBank.id && element.folderId == wordBank.folderId)
                .isEmpty) {
              await funAddToWordBank(wordBank, key);
              localViewModel.boundException = false;
            } else {
              showTopSnackBar(
                Overlay.of(context!),
                CustomSnackBar.info(
                  message: "move_info".tr(),
                ),
              );
            }
          }
        },
      );
    }, callFuncName: 'addToWordBankFromParentPhrase', inProgress: false);
  }

  addAllWords(GlobalKey globalKey) async {
    log('addAllWords');
    if (!(await localViewModel.canAddWordBank(context!))) {
      return;
    }
    safeBlock(() async {
      if (parentsWithAllList.isNotEmpty) {
        showFolderDialog(
          (folderModel) async {
            var count = 0;
            for (var element in parentsWithAllList) {
              int dbCount = await wordEntityRepository.getWordBankCount();
              if (dbCount > 29 && !PurchasesObserver().isPro()) {
                showCountOutOfBound();
                break;
              } else {
                count++;
                var wordBank = WordBankModel(
                    id: element.parents!.id,
                    parentId: localViewModel.wordDetailModel.id,
                    word: element.parents!.word,
                    example: element.parents!.example,
                    translation: conductToString(element.wordsUz),
                    createdAt: DateTime.now().toString(),
                    number: count,
                    wordClass:
                        wordEntityRepository.requiredWordWithAllModel.word!.wordClasswordClass ??
                            "",
                    wordClassBody:
                        wordEntityRepository.requiredWordWithAllModel.word!.wordClassBody,
                    type: "word",
                    folderId: folderModel.id);
                if (wordEntityRepository.wordBankList
                    .where((element) =>
                        element.id == wordBank.id && element.folderId == wordBank.folderId)
                    .isEmpty) {
                  await funAddToWordBank(wordBank, globalKey);
                  localViewModel.boundException = false;
                } else {
                  showTopSnackBar(
                    Overlay.of(context!),
                    CustomSnackBar.info(
                      message: "move_info".tr(),
                    ),
                  );
                }
              }
            }
          },
        );
      }
    }, callFuncName: 'addAllWords', inProgress: false);
  }

  funAddToWordBank(WordBankModel bankModel, GlobalKey? key) async {
    safeBlock(() async {
      await wordEntityRepository.saveWordBank(bankModel);
      if (key != null) {
        localViewModel.runAddToCartAnimation(key);
      }
      await localViewModel.changeBadgeCount(1);
    }, callFuncName: 'funAddToWordBank', inProgress: false);
  }

  showFolderDialog(Function(WordBankFolderEntity model) body) {
    return showCustomDialog(
      icon: Assets.icons.saveWord,
      iconColor: AppColors.blue,
      iconBackgroundColor: AppColors.borderWhite,
      context: context!,
      title: 'folder_dialog'.tr(),
      contentWidget: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          changer.addListener(() {
            setState(() {});
          });
          return SizedBox(
            width: 300.h,
            height: 300.h,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: wordEntityRepository.wordBankFoldersList.length,
                itemBuilder: (context, index) {
                  var item = wordEntityRepository.wordBankFoldersList[index];
                  if (item.id != 2) {
                    return Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.borderWhite))),
                      child: ListTile(
                        title: Text(item.folderName.tr(),
                            style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue)),
                        onTap: () async {
                          await body(item);
                          notifyListeners();
                          pop();
                        },
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
          );
        },
      ),
      negative: "new_word_bank_type".tr(),
      onNegativeTap: () async {
        if (!PurchasesObserver().isPro() && wordEntityRepository.wordBankFoldersList.length >= 3) {
          showFolderCountOutOfBound();
        } else {
          await addNewFolder();
        }
      },
    );
  }

  ValueNotifier<int> changer = ValueNotifier<int>(1);

  Future addNewFolder() async {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.addFolder,
      iconColor: AppColors.blue,
      iconBackgroundColor: AppColors.borderWhite,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: TextField(
          controller: folderTextController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "folder_name_hint".tr(),
            hintStyle: AppTextStyle.font15W600Normal
                .copyWith(color: isDarkTheme ? AppColors.gray : AppColors.blue),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkTheme ? AppColors.white : AppColors.blue,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkTheme ? AppColors.white : AppColors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkTheme ? AppColors.white : AppColors.blue,
              ),
            ),
          ),
          style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue),
        ),
      ),
      positive: "add".tr(),
      onPositiveTap: () async {
        if (!(await localViewModel.canAddWordBank(context!))) {
          return;
        }
        if (folderTextController.text.isNotEmpty) {
          await wordEntityRepository.addNewWordBankFolder(folderTextController.text);
          changer.value++;
          pop();
        }
      },
      negative: "cancel".tr(),
      onNegativeTap: () async {
        pop();
      },
    );
  }

  showFolderCountOutOfBound() {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.addFolder,
      iconColor: AppColors.accentLight,
      iconBackgroundColor: AppColors.error,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'new_folder_bound_info'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "buy_pro".tr(),
      onPositiveTap: () {
        navigateTo(Routes.gettingProPage);
      },
    );
  }

  showCountOutOfBound() async {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.saveWord,
      iconColor: AppColors.accentLight,
      iconBackgroundColor: AppColors.error,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'word_bank_add_info'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "buy_pro".tr(),
      onPositiveTap: () {
        navigateTo(Routes.gettingProPage);
      },
      negative: "watch_ad".tr(),
      onNegativeTap: () async {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          localViewModel.showInterstitialAd();
          localViewModel.boundException = true;
          pop();
        } else {
          callBackError('no_internet'.tr());
        }
      },
    );
  }

  String conductToString(List<WordsUzModel>? wordList) {
    if (wordList != null && wordList.isNotEmpty) {
      var concatenate = StringBuffer();
      for (var item in wordList) {
        if (wordList.last != item) {
          concatenate.write("${item.word}, ");
        } else {
          concatenate.write("${item.word}");
        }
      }
      return concatenate.toString();
    } else {
      return "";
    }
  }

  TextSpan conductAndHighlightUzWords(List<WordsUzModel>? wordList,
      List<PhrasesTranslateModel>? translate, List<ParentPhrasesTranslateModel>? phraseTranslate) {
    String sourceText = "";
    if (wordList != null) {
      sourceText = conductToString(wordList);
    } else if (translate != null) {
      sourceText = conductToStringPhrasesTranslate(translate);
    } else {
      sourceText = conductToStringParentPhrasesTranslate(phraseTranslate);
    }

    if (localViewModel.isSearchByUz &&
        localViewModel.wordDetailModel.word != null &&
        localViewModel.wordDetailModel.word!.isNotEmpty) {
      String targetHighlight = localViewModel.wordDetailModel.wordClass ?? "";
      List<TextSpan> spans = [];
      int start = 0;
      int indexOfHighlight;
      do {
        indexOfHighlight = sourceText.indexOf(targetHighlight, start);
        if (indexOfHighlight < 0) {
          // no highlight
          spans.add(_normalSpan(sourceText.substring(start)));
          break;
        }
        if (indexOfHighlight > start) {
          // normal text before highlight
          spans.add(_normalSpan(sourceText.substring(start, indexOfHighlight)));
        }
        start = indexOfHighlight + targetHighlight.length;
        spans.add(_highlightSpan(sourceText.substring(indexOfHighlight, start)));
      } while (true);

      return TextSpan(children: spans);
    } else {
      return TextSpan(children: [_normalSpan(sourceText)]);
    }
  }

  TextSpan _highlightSpan(String content) {
    return TextSpan(
        text: content,
        style: AppTextStyle.font15W600Normal.copyWith(
            color: isDarkTheme ? AppColors.darkForm : AppColors.darkGray,
            fontSize: fontSize! - 2,
            backgroundColor: Colors.yellow));
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(
        text: content,
        style: AppTextStyle.font15W600Normal.copyWith(
            color: isDarkTheme ? AppColors.white : AppColors.darkGray,
            fontSize: fontSize! - 2,
            backgroundColor: Colors.transparent));
  }

  String conductToStringPhrasesTranslate(List<PhrasesTranslateModel>? translateList) {
    if (translateList != null && translateList.isNotEmpty) {
      var concatenate = StringBuffer();
      for (var item in translateList) {
        if (translateList.last != item) {
          concatenate.write("${item.word}, ");
        } else {
          concatenate.write("${item.word}");
        }
      }
      return concatenate.toString();
    } else {
      return "";
    }
  }

  String conductToStringParentPhrasesTranslate(List<ParentPhrasesTranslateModel>? translateList) {
    if (translateList != null && translateList.isNotEmpty) {
      var concatenate = StringBuffer();
      for (var item in translateList) {
        if (translateList.last != item) {
          concatenate.write("${item.word}, ");
        } else {
          concatenate.write("${item.word}");
        }
      }
      return concatenate.toString();
    } else {
      return "";
    }
  }

  String conductToStringPhrasesExamples(List<PhrasesExampleModel>? examplesList) {
    if (examplesList != null && examplesList.isNotEmpty) {
      var concatenate = StringBuffer();
      for (var item in examplesList) {
        if (item == examplesList.last) {
          concatenate.write("${item.value}");
        } else {
          concatenate.write("${item.value}\n");
        }
      }
      return concatenate.toString();
    } else {
      return "";
    }
  }

  String conductToStringParentPhrasesExamples(List<ParentPhrasesExampleModel>? examplesList) {
    if (examplesList != null && examplesList.isNotEmpty) {
      var concatenate = StringBuffer();
      for (var item in examplesList) {
        if (item == examplesList.last) {
          concatenate.write("${item.value}");
        } else {
          concatenate.write("${item.value}\n");
        }
      }
      return concatenate.toString();
    } else {
      return "";
    }
  }

  String findRank(String star) {
    switch (star) {
      case "3":
        return Assets.icons.starFull;
      case "2":
        return Assets.icons.starHalf;
      case "1":
        return Assets.icons.starLow;
      default:
        return "";
    }
  }

  Future<bool> goBackToSearch() async {
    if (localViewModel.isFromMain) {
      localViewModel.isFromMain = false;
      localViewModel.changePageIndex(0);
    } else if (localViewModel.detailToFromBank) {
      localViewModel.detailToFromBank = false;
      localViewModel.changePageIndex(1);
    } else {
      localViewModel.goingBackFromDetail = true;
      localViewModel.changePageIndex(2);
    }
    return false;
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy()) {
      dialog = showLoadingDialog(context!);
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
    }
  }

  bool isWordEqual(String word) {
    // && !localViewModel.isSearchByUz I removed because of word bank item entering. it highlight both uzbek and english word
    if (word == (localViewModel.wordDetailModel.word ?? "")) {
      return true;
    }
    return false;
  }

  bool isWordContained(String word) {
    if (word.contains(localViewModel.wordDetailModel.wordClass ?? "_@@")) {
      return true;
    }
    return false;
  }

  isWordUzEqual(String wordUz) {
    if (wordUz == (localViewModel.wordDetailModel.wordClass ?? "")) {
      return true;
    }
    return false;
  }

  bool isPhraseTranslateContainsWord(List<PhrasesTranslateModel> list) {
    for (var item in list) {
      if (isWordUzEqual(item.word ?? "")) {
        return true;
      } else {
        continue;
      }
    }
    return false;
  }

  bool isParentPhraseTranslateContainsWord(List<ParentPhrasesTranslateModel> list) {
    for (var item in list) {
      if (isWordUzEqual(item.word ?? "")) {
        return true;
      } else {
        continue;
      }
    }
    return false;
  }

  bool hasToBeExpanded(List<PhrasesWithAll>? phrasesWithAll) {
    if (localViewModel.wordDetailModel.type == "phrase" ||
        localViewModel.wordDetailModel.type == "phrases" ||
        localViewModel.isSearchByUz) {
      if (phrasesWithAll != null && phrasesWithAll.isNotEmpty) {
        for (var model in phrasesWithAll) {
          if (isWordEqual(model.phrases!.pWord ?? "")) {
            return true;
          }
          if (isPhraseTranslateContainsWord(model.phrasesTranslate ?? [])) {
            return true;
          }
          if (model.parentPhrasesWithAll != null && model.parentPhrasesWithAll!.isNotEmpty) {
            for (var item in model.parentPhrasesWithAll!) {
              if (isParentPhraseTranslateContainsWord(item.parentPhrasesTranslate ?? [])) {
                return true;
              }
            }
          }
        }
      }
      return false;
    }
    return false;
  }

  showPhotoView() {
    showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Image.network(
            Urls.baseUrl + wordEntityRepository.requiredWordWithAllModel.word!.image!,
            fit: BoxFit.scaleDown,
          ),
        );
      },
    );
  }
}
