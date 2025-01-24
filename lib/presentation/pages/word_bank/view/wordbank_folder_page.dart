import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/presentation/components/custom_oval_button.dart';
import 'package:wisdom/presentation/components/wordbank_folder_item.dart';
import 'package:wisdom/presentation/widgets/empty_jar.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_decoration.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/wordbank_folder_viewmodel.dart';

class WordBankFolderPage extends ViewModelBuilderWidget<WordBankFolderViewModel> {
  WordBankFolderPage({super.key});

  @override
  void onViewModelReady(WordBankFolderViewModel viewModel) {
    viewModel.getWordBankFolders();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, WordBankFolderViewModel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: () => viewModel.goBackToMain(),
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: CustomAppBar(
          leadingIcon: Assets.icons.menu,
          onTap: () => ZoomDrawer.of(context)!.toggle(),
          title: 'Word bank',
          focus: false,
        ),
        body: viewModel.isSuccess(tag: viewModel.getWordBankFoldersListTag) &&
                viewModel.wordEntityRepository.wordBankFoldersList.isNotEmpty
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.wordEntityRepository.wordBankFoldersList.length,
                      itemBuilder: (context, index) {
                        var model = viewModel.wordEntityRepository.wordBankFoldersList[index];
                        var count = viewModel.wordEntityRepository.wordBankListForCount
                            .where((element) => element.folderId == model.id)
                            .length;
                        return WordBankFolderItem(
                          model: model,
                          wordCount: model.id == 1
                              ? viewModel.wordEntityRepository.wordBankListForCount.length
                              : count,
                        );
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomOvalButton(
                          label: 'new_word_bank_type'.tr(),
                          onTap: () => viewModel.addNewFolder(),
                          textStyle: AppTextStyle.font15W500Normal,
                          prefixIcon: true,
                          imgAssets: Assets.icons.addFolder,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: viewModel.localViewModel.isNetworkAvailable,
                      builder: (BuildContext context, value, Widget? child) {
                        return viewModel.localViewModel.banner != null && value as bool
                            ? Container(
                                margin: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                                decoration: isDarkTheme
                                    ? AppDecoration.bannerDarkDecor
                                    : AppDecoration.bannerDecor,
                                height: viewModel.localViewModel.banner!.size.height * 1.0,
                                child: AdWidget(
                                  ad: viewModel.localViewModel.banner!..load(),
                                ))
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              )
            : viewModel.wordEntityRepository.wordBankFoldersList.isEmpty
                ? const EmptyJar()
                : const Center(
                    child: LoadingWidget(),
                  ),
        endDrawerEnableOpenDragGesture: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.addNewWord(),
          backgroundColor: AppColors.blue,
          child: SvgPicture.asset(
            Assets.icons.plus,
            color: AppColors.white,
          ),
        ),
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
  WordBankFolderViewModel viewModelBuilder(BuildContext context) {
    return WordBankFolderViewModel(
        context: context, wordEntityRepository: locator.get(), localViewModel: locator.get());
  }
}
