import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:lottie/lottie.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/presentation/components/translate_circle_button.dart';
import 'package:wisdom/presentation/pages/google_translator/viewmodel/google_translator_page_viewmodel.dart';
import 'package:wisdom/presentation/widgets/change_language_button_translate.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';

// ignore: must_be_immutable
class GoogleTranslatorPage extends ViewModelBuilderWidget<GoogleTranslatorPageViewModel> {
  GoogleTranslatorPage({super.key});

  late TextEditingController topController = TextEditingController();
  late TextEditingController bottomController = TextEditingController();
  bool isCancel = false;

  @override
  void onViewModelReady(GoogleTranslatorPageViewModel viewModel) {
    super.onViewModelReady(viewModel);
    topController.addListener(() {
      if (topController.text.isNotEmpty) {
        isCancel = true;
      } else {
        isCancel = false;
      }
      viewModel.notifyListeners();
    });
  }

  @override
  void onDestroy(GoogleTranslatorPageViewModel model) {
    super.onDestroy(model);
  }

  @override
  Widget builder(BuildContext context, GoogleTranslatorPageViewModel viewModel, Widget? child) {
    GlobalKey globalKey = GlobalKey();
    return WillPopScope(
      onWillPop: () => viewModel.goMain(),
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: CustomAppBar(
          title: "translator".tr(),
          onTap: () => viewModel.goMain(),
          leadingIcon: Assets.icons.arrowLeft,
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        color: isDarkTheme ? AppColors.darkForm : AppColors.white,
                      ),
                      height: 158.h,
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 23),
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: topController,
                              style: AppTextStyle.font15W500Normal.copyWith(
                                  color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: viewModel.topUzbek ? "uzbek".tr() : "english".tr(),
                                hintStyle: AppTextStyle.font15W500Normal
                                    .copyWith(color: AppColors.lightBlue),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TranslateCircleButton(
                                    onTap: () async {
                                      if (isCancel) {
                                        topController.clear();
                                        bottomController.clear();
                                        viewModel.notifyListeners();
                                      } else {
                                        FlutterClipboard.paste().then((value) {
                                          topController.text = value;
                                          viewModel.notifyListeners();
                                        });
                                      }
                                    },
                                    iconAssets:
                                        isCancel ? Assets.icons.crossClose : Assets.icons.copy),
                                SizedBox(
                                  width: 18.w,
                                ),
                                TranslateCircleButton(
                                    onTap: () async {
                                      viewModel.startListening();
                                      topController.text = await viewModel.voiceToText();
                                      viewModel.stopListening();
                                    },
                                    iconAssets: Assets.icons.microphone),
                                SizedBox(
                                  width: 18.w,
                                ),
                                TranslateCircleButton(
                                    onTap: () {
                                      viewModel.readText(topController.text);
                                    },
                                    iconAssets: Assets.icons.sound),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      decoration: AppDecoration.bannerDecor.copyWith(color: AppColors.blue),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            viewModel.translate(topController.text, bottomController);
                          },
                          borderRadius: BorderRadius.circular(18.5),
                          child: SizedBox(
                            height: 37.h,
                            width: 91.w,
                            child: Center(child: SvgPicture.asset(Assets.icons.send)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        color: isDarkTheme ? AppColors.darkForm : AppColors.white,
                      ),
                      height: 158.h,
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 23),
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: bottomController,
                              style: AppTextStyle.font15W500Normal.copyWith(
                                  color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: viewModel.topUzbek ? "english".tr() : "uzbek".tr(),
                                enabled: false,
                                hintStyle: AppTextStyle.font15W500Normal
                                    .copyWith(color: AppColors.lightBlue),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TranslateCircleButton(
                                    onTap: () {
                                      FlutterClipboard.copy(bottomController.text);
                                    },
                                    iconAssets: Assets.icons.copy),
                                SizedBox(
                                  width: 18.w,
                                ),
                                TranslateCircleButton(
                                    onTap: () {
                                      viewModel.readText(bottomController.text);
                                    },
                                    iconAssets: Assets.icons.sound),
                                SizedBox(
                                  width: 18.w,
                                ),
                                Container(
                                  key: globalKey,
                                  child: TranslateCircleButton(
                                    onTap: () async {
                                      if (topController.text.isNotEmpty &&
                                          bottomController.text.isNotEmpty) {
                                        if (await locator
                                            .get<LocalViewModel>()
                                            .canAddWordBank(context)) {
                                          viewModel.funAddToWordBank(
                                            viewModel.topUzbek
                                                ? bottomController.text
                                                : topController.text,
                                            viewModel.topUzbek
                                                ? topController.text
                                                : bottomController.text,
                                            globalKey,
                                          );
                                        }
                                      }
                                    },
                                    iconAssets: Assets.icons.saveWord,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (viewModel.isListening) const ListeningWidget()
            ],
          ),
        ),
        floatingActionButton: ChangeLanguageButtonTranslate(viewModel),
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
  GoogleTranslatorPageViewModel viewModelBuilder(BuildContext context) {
    return GoogleTranslatorPageViewModel(
        context: context, localViewModel: locator.get(), wordEntityRepository: locator.get());
  }
}

class ListeningWidget extends StatelessWidget {
  const ListeningWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.h,
        height: 300.h,
        margin: EdgeInsets.only(top: 100.h),
        child: Lottie.asset("assets/lottie/listening.json"),
      ),
    );
  }
}
