import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/presentation/components/search_clean_button.dart';
import 'package:wisdom/presentation/components/search_history_item.dart';
import 'package:wisdom/presentation/components/search_word_item.dart';
import 'package:wisdom/presentation/pages/search/viewmodel/search_page_viewmodel.dart';
import 'package:wisdom/presentation/widgets/change_language_button.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar_search.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../widgets/loading_widget.dart';

// ignore: must_be_immutable
class SearchPage extends ViewModelBuilderWidget<SearchPageViewModel> {
  SearchPage({super.key});

  @override
  void onViewModelReady(SearchPageViewModel viewModel) {
    if (viewModel.localViewModel.searchingText.isEmpty ||
        (viewModel.localViewModel.lastSearchedText.isEmpty &&
            viewModel.localViewModel.goingBackFromDetail)) {
      viewModel.init();
    }
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, SearchPageViewModel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: () async {
        if (viewModel.localViewModel.searchFocusNode?.hasFocus == true) {
          viewModel.localViewModel.searchFocusNode?.unfocus();
        } else {
          viewModel.goBackToMain();
        }
        return false;
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: CustomAppBarSearch(
          leadingIcon: Assets.icons.menu,
          onTap: () {
            FocusScope.of(context).unfocus();
            locator.get<LocalViewModel>().changePageIndex(0);
          },
          isSearch: true,
          isLeading: true,
          isTitle: false,
          focus: true,
          title: "search_page".tr(),
          onChange: (text) => viewModel.searchByWord(text),
        ),
        body: Column(
          children: [
            //Clean button
            Visibility(
              visible: ((viewModel.recentList.isNotEmpty && viewModel.searchLangMode == 'en') ||
                      (viewModel.recentListUz.isNotEmpty && viewModel.searchLangMode == 'uz')) &&
                  viewModel.searchText.isEmpty,
              child: SearchCleanButton(
                onTap: () => viewModel.cleanHistory(),
              ),
            ),
            // Recent searched lists for english words
            Visibility(
              visible: viewModel.recentList.isNotEmpty &&
                  viewModel.searchText.isEmpty &&
                  viewModel.searchLangMode == 'en',
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 130),
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.recentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var itemRecent = viewModel.recentList[index];
                    return SearchHistoryItem(
                      firstText: itemRecent.word ?? "unknown",
                      secondText: itemRecent.wordClass ?? "",
                      star: itemRecent.star!,
                      onTap: () => viewModel.goToDetail(itemRecent),
                      thirdText: itemRecent.same,
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: ((viewModel.searchText.isNotEmpty) && viewModel.searchLangMode == 'en'),
              child: (viewModel.isSuccess(tag: viewModel.searchTag) &&
                      viewModel.searchText.isNotEmpty &&
                      viewModel.searchRepository.searchResultList.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 130),
                        physics: const BouncingScrollPhysics(),
                        itemCount: viewModel.searchRepository.searchResultList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = viewModel.searchRepository.searchResultList[index];
                          return SearchWordItem(
                            firstText: item.word ?? "unknown",
                            secondText: item.wordClasswordClass ?? "",
                            onTap: () => viewModel.goToDetail(item),
                            star: item.star.toString(),
                            thirdText: item.translation,
                          );
                        },
                      ),
                    )
                  : (viewModel.isSuccess(tag: viewModel.searchTag) &&
                          viewModel.searchText.isNotEmpty &&
                          viewModel.searchRepository.searchResultList.isEmpty)
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text(
                              "Not found such a word",
                              style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.error),
                            ),
                          ),
                        )
                      : SizedBox(height: 120.h, child: const LoadingWidget()),
            ),
            // Recent searched lists for Uzbek words
            Visibility(
              visible: viewModel.recentListUz.isNotEmpty &&
                  viewModel.searchText.isEmpty &&
                  viewModel.searchLangMode == 'uz',
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 130),
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.recentListUz.length,
                  itemBuilder: (BuildContext context, int index) {
                    var itemRecent = viewModel.recentListUz[index];
                    return SearchHistoryItem(
                      firstText: itemRecent.wordClass ?? "unknown",
                      star: itemRecent.star!,
                      secondText: itemRecent.word ?? "",
                      thirdText: itemRecent.same != null && itemRecent.same!.isNotEmpty
                          ? itemRecent.same.toString()
                          : "",
                      onTap: () => viewModel.goToDetail(itemRecent),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: ((viewModel.searchText.isNotEmpty) && viewModel.searchLangMode == 'uz'),
              child: (viewModel.isSuccess(tag: viewModel.searchTag) &&
                      viewModel.searchText.isNotEmpty &&
                      viewModel.searchRepository.searchResultUzList.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 130),
                        physics: const BouncingScrollPhysics(),
                        itemCount: viewModel.searchRepository.searchResultUzList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = viewModel.searchRepository.searchResultUzList[index];
                          return SearchWordItem(
                            firstText: item.word ?? "unknown",
                            secondText: item.wordClass ?? "",
                            star: item.star.toString(),
                            thirdText: item.same,
                            onTap: () => viewModel.goToDetail(item),
                          );
                        },
                      ),
                    )
                  : (viewModel.isSuccess(tag: viewModel.searchTag) &&
                          viewModel.searchText.isNotEmpty &&
                          viewModel.searchRepository.searchResultUzList.isEmpty)
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text(
                              "Not found such a word",
                              style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.error),
                            ),
                          ),
                        )
                      : SizedBox(height: 120.h, child: const LoadingWidget()),
            ),
          ],
        ),
        floatingActionButton: ChangeLanguageButton(viewModel),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // to maintain float actions size
        bottomNavigationBar: Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "as"),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "as"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SearchPageViewModel viewModelBuilder(BuildContext context) {
    return SearchPageViewModel(
        context: context,
        preferenceHelper: locator.get(),
        dbHelper: locator.get(),
        searchRepository: locator.get(),
        localViewModel: locator.get());
  }
}
