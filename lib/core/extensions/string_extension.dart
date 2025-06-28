import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

extension StringExtension on String {
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) => "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }

  String get phoneFormatter =>
      MaskTextInputFormatter(mask: '+### (##) ### ## ##', initialText: this).getMaskedText();
}
