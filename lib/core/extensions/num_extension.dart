import 'package:easy_localization/easy_localization.dart';

extension DoubleExtension on num? {
  String get toMoneyFormat {
    if (this != null) {
      final formatCurrency = NumberFormat.currency(
        locale: "uz_UZ",
        symbol: '',
        decimalDigits: 0,
      );
      return formatCurrency.format(this);
    }
    return '';
  }
}
