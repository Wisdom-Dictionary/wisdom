import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/presentation/components/wordbank_item.dart';
import 'package:wisdom/presentation/widgets/empty_jar.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/wordbank_viewmodel.dart';

class WordBankPage extends ViewModelBuilderWidget<WordBankViewModel> {
  WordBankPage({super.key});

  @override
  void onViewModelReady(WordBankViewModel viewModel) {
    viewModel.getWordBankList();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, WordBankViewModel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: () => viewModel.goBackToMain(),
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: CustomAppBar(
          leadingIcon: Assets.icons.arrowLeft,
          onTap: () => viewModel.goBackToMain(),
          title: 'Word bank',
          focus: false,
        ),
        body: viewModel.isSuccess(tag: viewModel.getWordBankListTag) &&
                viewModel.wordEntityRepository.wordBankList.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(top: 16.h, bottom: 130.h),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.wordEntityRepository.wordBankList.length,
                itemBuilder: (context, index) {
                  var model = viewModel.wordEntityRepository.wordBankList[index];
                  return WordBankItem(
                    model: model,
                  );
                },
              )
            : viewModel.wordEntityRepository.wordBankList.isEmpty
                ? const EmptyJar()
                : const Center(
                    child: LoadingWidget(),
                  ),
        endDrawerEnableOpenDragGesture: true,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 65),
          decoration:
              BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(25.r)),
          height: 40.h,
          width: 125.w,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => viewModel.goToExercisePage(),
              borderRadius: BorderRadius.circular(25.r),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgPicture.asset(Assets.icons.exercise, height: 20.h, fit: BoxFit.scaleDown),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'start_exercise'.tr(),
                    style: AppTextStyle.font15W500Normal,
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  WordBankViewModel viewModelBuilder(BuildContext context) {
    return WordBankViewModel(
        context: context, wordEntityRepository: locator.get(), localViewModel: locator.get());
  }
}
