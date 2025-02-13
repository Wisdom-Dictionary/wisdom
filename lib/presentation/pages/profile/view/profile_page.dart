import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/extensions/app_extension.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/data/enums/gender.dart';
import 'package:wisdom/presentation/pages/login/view/login_page.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../widgets/custom_dialog.dart';
import '../../../widgets/my_url.dart';
import '../viewmodel/profile_page_viewmodel.dart';
import '../widgets/gender_selector_widget.dart';
import '../widgets/pro_version_button.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_image_widget.dart';
import '../widgets/user_action_buttons.dart';
import '../widgets/user_selector_data_widget.dart';

// ignore: must_be_immutable
class ProfilePage extends ViewModelBuilderWidget<ProfilePageViewModel> {
  ProfilePage({super.key});

  final purchaseObserver = PurchasesObserver();

  @override
  void onViewModelReady(ProfilePageViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getTariffs();
    viewModel.getUser();
    // resetLocator();
  }

  @override
  Widget builder(
    BuildContext context,
    ProfilePageViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        log('onPopInvoked');
        // viewModel.goBackToMenu();
      },
      child: Scaffold(
          backgroundColor: isDarkTheme
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          appBar: ProfileAppBar(
            actions: [
              buildMenu(viewModel),
            ],
            bottomWidget: viewModel.isSuccess(tag: viewModel.getGetUser)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileImageWidget(
                        imageUrl: viewModel.imageUrl,
                        onEdit: () {
                          showImagePicker(
                            context,
                            onSelected: (v) {
                              if (v != null) {
                                viewModel.onEditImage(v);
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.userModel.userFullName,
                            style: AppTextStyle.font15W500Normal,
                          ),
                          Text(
                            viewModel.editedUser.phone ?? '',
                            style: AppTextStyle.font15W500Normal,
                          ),
                        ],
                      )
                    ],
                  ).paddingOnly(bottom: 30, left: 50)
                : const SizedBox(),
          ),
          body: viewModel.isSuccess(tag: viewModel.getGetUser)
              ? SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30.h, left: 18.w, right: 18.w),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildUserData(viewModel, context),
                        UserActionButtons(
                          save: () async {
                            await viewModel.onSaveChanges();
                          },
                          cancel: () async {
                            viewModel.onCancelChanges();
                          },
                          isActive: viewModel.saveButtonsActive,
                        ),
                        const SizedBox(height: 100),
                        viewModel.isSuccess(tag: 'getTariffs')
                            ? buildProVersionButton(context, viewModel)
                                .paddingSymmetric(vertical: 10, horizontal: 20)
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RichText(
                                text: myUrl('Restore Purchase', '',
                                    textColor: AppColors.blue,
                                    underline: false,
                                    onTap: () => viewModel.restore()),
                              ),
                              RichText(
                                text: myUrl('Privacy', Constants.PRIVACY_URL,
                                    textColor: AppColors.blue,
                                    underline: false),
                              ),
                              RichText(
                                text: myUrl('Terms', Constants.TERMS_URL,
                                    textColor: AppColors.blue,
                                    underline: false),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator.adaptive())),
    );
  }

  Widget buildProVersionButton(
      BuildContext context, ProfilePageViewModel viewModel) {
    return ProVersionButton(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.gettingProPage);
      },
      isVisible: !purchaseObserver.isPro(),
      tariffsModel: viewModel.tariffsModel,
    );
  }

  Widget _buildUserData(ProfilePageViewModel viewModel, BuildContext context) {
    return CardContentWidget(
      children: [
        UserInputDataWidget(
          title: LocaleKeys.name.tr(),
          onChanged: (String value) {
            viewModel.onFirstNameChanged(value);
          },
          data: viewModel.editedUser.name,
          hintText: LocaleKeys.write_name.tr(),
        ),
        UserInputDataWidget(
          title: LocaleKeys.tariff_plan.tr(),
          onChanged: (String value) {},
          readOnly: true,
          data: purchaseObserver.isPro() ? "Pro" : "not_purchased".tr(),
        ),
        if (viewModel.currentTariff != null)
          UserInputDataWidget(
            title: LocaleKeys.tariff.tr(),
            onChanged: (String value) {},
            readOnly: true,
            data: viewModel.currentTariff?.name?.getLocaleName(context) ?? '',
            isVisible: purchaseObserver.isPro(),
          ),
        UserInputDataWidget(
          title: LocaleKeys.email.tr(),
          onChanged: (String value) {
            viewModel.onEmailChanged(value);
          },
          data: viewModel.editedUser.email,
          hintText: LocaleKeys.write_email.tr(),
        ),
        UserSelectorDataWidget(
          title: LocaleKeys.birthday.tr(),
          onChanged: (String value) {},
          readOnly: true,
          data: viewModel.editedUser.birthDateString,
          hintText: LocaleKeys.enter_birthday.tr(),
          onTap: () async {
            await _selectDate(context).then(
              (value) {
                if (value != null) {
                  viewModel.setBirthday(value);
                }
              },
            );
          },
        ),
        UserSelectorDataWidget(
          title: LocaleKeys.gender.tr(),
          readOnly: true,
          data: viewModel.editedUser.gender?.localeName,
          hintText: LocaleKeys.write_gender.tr(),
          onChanged: (String value) {},
          onTap: () async {
            await _selectGender(context).then((value) {
              if (value != null) {
                viewModel.setGender(value);
              }
            });
          },
        ),
      ],
    );
  }

  Widget buildMenu(ProfilePageViewModel viewModel) {
    return PopupMenuButton(
      offset: const Offset(-20, 30),
      itemBuilder: (context) => [
        PopupMenuItem(
          textStyle:
              AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
          child: Row(
            children: [
              const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.red,
              ),
              const SizedBox(width: 20),
              Text(
                LocaleKeys.exit.tr(),
                style: AppTextStyle.font15W500Normal.copyWith(
                  color: isDarkTheme ? AppColors.white : AppColors.blue,
                ),
              ),
            ],
          ),
          onTap: () async {
            await viewModel.logOut();
          },
        )
      ],
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.white,
      ),
      color: isDarkTheme ? AppColors.darkBackground : AppColors.white,
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            colorScheme: ColorScheme.dark(
              primary: isDarkTheme ? AppColors.blue : AppColors.blue,
              onPrimary: isDarkTheme ? Colors.white : Colors.blue,
              background:
                  isDarkTheme ? AppColors.darkBackground : AppColors.white,
              surface:
                  isDarkTheme ? AppColors.darkBackground : AppColors.darkForm,
              onSurface: Colors.blue,
              onBackground: Colors.blue,
            ),
            dialogBackgroundColor:
                isDarkTheme ? AppColors.darkBackground : AppColors.darkForm,
          ),
          child: child!,
        );
      },
    );
    return newSelectedDate;
  }

  Future<Gender?> _selectGender(BuildContext context) async {
    final selectedGender = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const GenderSelectorDialog();
      },
    );
    return selectedGender;
  }

  @override
  ProfilePageViewModel viewModelBuilder(BuildContext context) {
    return ProfilePageViewModel(
      context: context,
      profileRepository: locator.get(),
      localViewModel: locator.get(),
      sharedPreferenceHelper: locator.get(),
      wordEntityRepository: locator.get(),
      netWorkChecker: locator.get(),
    );
  }
}

class UserInputDataWidget extends StatefulWidget {
  final String title;
  final String? data;
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool readOnly;
  final TextStyle? titleTextStyle;
  final TextStyle? dataTextStyle;
  final bool isVisible;
  final Function? onTap;

  const UserInputDataWidget({
    super.key,
    required this.title,
    this.data,
    required this.onChanged,
    this.hintText = '',
    this.readOnly = false,
    this.titleTextStyle,
    this.dataTextStyle,
    this.isVisible = true,
    this.onTap,
  });

  @override
  State<UserInputDataWidget> createState() => _UserInputDataWidgetState();
}

class _UserInputDataWidgetState extends State<UserInputDataWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.data ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Container(
        height: 40.dg,
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: (isDarkTheme
                  ? AppColors.darkBackground
                  : AppColors.lightBackground)
              .withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              widget.title,
              style: widget.titleTextStyle ??
                  AppTextStyle.font12W400Normal.copyWith(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                    fontSize: 12.sp,
                  ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                onTap: () {
                  widget.onTap?.call();
                },
                controller: controller,
                readOnly: widget.readOnly,
                onChanged: widget.onChanged,
                textAlign: TextAlign.end,
                style: widget.dataTextStyle ??
                    AppTextStyle.font12W600Normal.copyWith(
                      color: AppColors.blue,
                      fontSize: 12.sp,
                    ),
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  hintStyle: AppTextStyle.font12W400Normal.copyWith(
                    color: AppColors.lightGray,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
