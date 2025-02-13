import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/extensions/app_extension.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/presentation/pages/login/viewmodel/login_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/social_button.dart';

import '../../../../config/constants/assets.dart';
import '../../../widgets/app_button_widget.dart';

// ignore: must_be_immutable
class LoginPage extends ViewModelBuilderWidget<LoginViewModel> {
  LoginPage({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.blue,
                size: 20,
              ),
            ).paddingOnly(top: 50, left: 20),
          ),
          Column(
            children: [
              SvgPicture.asset(
                isDarkTheme
                    ? Assets.icons.logoWhiteText
                    : Assets.icons.logoBlueText,
                height: 52.h,
                fit: BoxFit.scaleDown,
              ),
              privacyPolicyLinkAndTermsOfService(),
            ],
          ),
          Column(
            children: [
              if(!Platform.isWindows)
              SocialButtonWidget(
                onTap: () async {
                  await viewModel.loginWithGoogle();
                },
                title: "Google",
                color: AppColors.lightBackground,
                textStyle: AppTextStyle.font12W600Normal.copyWith(
                  color: AppColors.darkForm,
                  fontSize: 12.sp,
                ),
                leftIcon: SvgPicture.asset(
                  Assets.icons.googleIc,
                  height: 32,
                  width: 32,
                  fit: BoxFit.scaleDown,
                ),
                margin: EdgeInsets.symmetric(vertical: 3.w),
              ),
              if (Platform.isIOS)
                SocialButtonWidget(
                  onTap: () async {
                    await viewModel.loginWithApple();
                  },
                  title: "Apple",
                  color: AppColors.lightBackground,
                  textStyle: AppTextStyle.font12W600Normal.copyWith(
                    color: AppColors.darkForm,
                    fontSize: 12.sp,
                  ),
                  leftIcon: SvgPicture.asset(
                    Assets.icons.appleIc,
                    height: 32,
                    width: 32,
                    fit: BoxFit.scaleDown,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 3.w),
                ),
              // SocialButtonWidget(
              //   onTap: () async {
              //     await viewModel.loginWithFacebook();
              //   },
              //   title: "Facebook",
              //   color: AppColors.lightBackground,
              //   textStyle: AppTextStyle.font12W600Normal.copyWith(color: AppColors.darkForm),
              //   leftIcon: SvgPicture.asset(
              //     Assets.icons.facebookIc,
              //     height: 32,
              //     width: 32,
              //     fit: BoxFit.cover,
              //   ),
              //   margin: EdgeInsets.symmetric(vertical: 3.w),
              // ),
              AppButtonWidget(
                onTap: () {
                  viewModel.navigateTo(Routes.loginWithPhonePage);
                },
                title: LocaleKeys.sign_in_with_phone.tr(),
                color: AppColors.lightBackground,
                textStyle: AppTextStyle.font12W600Normal.copyWith(
                  color: AppColors.darkForm,
                  fontSize: 12.sp,
                ),
                margin: EdgeInsets.symmetric(vertical: 3.w),
              ),
              // TextButton(
              //   style: TextButton.styleFrom(
              //     foregroundColor: AppColors.blue,
              //   ),
              //   onPressed: () {},
              //   child: Text('Trouble singing in?'),
              // ),
            ],
          ).paddingSymmetric(horizontal: 20, vertical: 20),
        ],
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: 'By tapping Create Account or Sign In, you agree to our ',
            style: AppTextStyle.font12W400Normal.copyWith(
              color: AppColors.paleGray,
              fontSize: 12.sp,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Terms.',
                style: AppTextStyle.font12W400Normal.copyWith(
                  color: AppColors.paleGray,
                  decoration: TextDecoration.underline,
                  fontSize: 12.sp,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse(Constants.TERMS_URL));
                  },
              ),
              TextSpan(
                text: ' Learn how we process your data in our ',
                style: AppTextStyle.font12W400Normal.copyWith(
                  color: AppColors.paleGray,
                  fontSize: 12.sp,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy.',
                    style: AppTextStyle.font12W400Normal.copyWith(
                      color: AppColors.paleGray,
                      decoration: TextDecoration.underline,
                      fontSize: 12.sp,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        launchUrl(Uri.parse(Constants.PRIVACY_URL));
                      },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) {
    return LoginViewModel(
      context: context,
      authRepository: locator.get(),
      preference: locator.get(),
      profileRepository: locator.get(),
      homeRepository: locator.get(),
      wordEntityRepository: locator.get(),
    );
  }
}

class CardContentWidget extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const CardContentWidget({
    required this.children,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: margin,
      padding: padding,
      decoration: isDarkTheme
          ? AppDecoration.bannerDarkDecor
          : AppDecoration.bannerDecor,
      child: Column(
        children: children,
      ),
    );
  }
}

class AppInputTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool enabled;
  final bool isIconVisible;
  final Color borderColor;
  final Color backColor;
  final Color cursorColor;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? hint;
  final double height;
  final double width;
  final EdgeInsets padding;
  final double borderRadius;
  final Widget? suffix;
  final Widget? prefix;
  final String initialText;
  final BoxConstraints? constraints;
  final Function(String value)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final TextInputFormatter? inputFormatter;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final int maxlines;
  final bool autoFocus;

  const AppInputTextField({
    super.key,
    this.controller,
    this.enabled = true,
    this.isIconVisible = false,
    this.autoFocus = false,
    this.borderColor = Colors.blue,
    this.backColor = Colors.black12,
    this.cursorColor = Colors.black,
    this.hintStyle,
    this.style,
    this.hint,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.height = 44,
    this.borderRadius = 8,
    this.width = double.infinity,
    this.onChanged,
    this.onTap,
    this.suffix,
    this.prefix,
    this.constraints,
    this.onSubmitted,
    this.maxlines = 1,
    this.inputFormatter,
    this.focusNode,
    this.initialText = '',
    this.textInputType,
    this.textInputAction,
  });

  @override
  State<AppInputTextField> createState() => _AppInputTextFieldState();
}

class _AppInputTextFieldState extends State<AppInputTextField> {
  // FocusNode focusNode = FocusNode();
  late TextEditingController controller;
  late FocusNode focusNode;
  bool hidePassword = false;

  @override
  void initState() {
    controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
    focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.requestFocus();
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        constraints: widget.constraints,
        padding: widget.padding,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: isDarkTheme
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          children: [
            widget.prefix ?? const SizedBox.shrink(),
            Expanded(
              child: TextField(
                onChanged: widget.onChanged,
                controller: controller,
                autofocus: widget.autoFocus,
                keyboardType: widget.textInputType,
                selectionHeightStyle: BoxHeightStyle.max,
                inputFormatters: widget.inputFormatter != null
                    ? [widget.inputFormatter!]
                    : [],
                // cursorWidth: 0.5,
                cursorHeight: 25,
                enabled: widget.enabled,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: widget.textInputAction,
                cursorColor: widget.cursorColor,
                focusNode: focusNode,
                style: AppTextStyle.font17W400Normal.copyWith(
                  color: AppColors.blue,
                  fontSize: 17.sp,
                ),
                maxLines: widget.maxlines,
                decoration: InputDecoration(
                  enabled: widget.enabled,
                  isDense: true,
                  hintText: widget.hint ?? "",
                  hintStyle: widget.hintStyle ??
                      AppTextStyle.font17W400Normal.copyWith(
                        color: AppColors.blue,
                        fontSize: 17.sp,
                      ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: widget.onTap,
              ),
            ),
            widget.suffix ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
