import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/presentation/pages/google_translator/viewmodel/google_translator_page_viewmodel.dart';

import 'change_language_button.dart';

class ChangeLanguageButtonTranslate extends StatefulWidget {
  const ChangeLanguageButtonTranslate(this.viewModel, {super.key});

  final GoogleTranslatorPageViewModel viewModel;

  @override
  State<ChangeLanguageButtonTranslate> createState() => _ChangeLanguageButtonTranslateState();
}

class _ChangeLanguageButtonTranslateState extends State<ChangeLanguageButtonTranslate> {
  bool isRotate = true;
  double rotate = 0;

  @override
  Widget build(BuildContext context) {
    bool isEn = !widget.viewModel.topUzbek;
    return Padding(
      padding: EdgeInsets.only(bottom: 0.h, right: 10.w),
      child: AnimationButton(
        onEnd: () {
          if (isRotate) {
            widget.viewModel.exchangeLanguages();
          }
          isRotate = false;
          rotate = 0;
        },
        isEn: isEn,
        rotate: rotate,
        onTap: () {
          setState(() {
            isRotate = true;
            rotate = .25;
          });
        },
        isRotate: isRotate,
      ),
    );
  }
}
