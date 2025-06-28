import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

TextSpan myUrl(String text, String url,
    {Color textColor = Colors.black54, bool underline = true, VoidCallback? onTap}) {
  return TextSpan(
    text: text,
    style: TextStyle(
        color: textColor,
        decoration: TextDecoration.underline,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500),
    recognizer: TapGestureRecognizer()
      ..onTap = onTap ??
          () async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {}
          },
  );
}
