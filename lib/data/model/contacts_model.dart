class AdContactsModel {
  final String? phone;
  final String? telegram;

  AdContactsModel({this.phone, this.telegram});

  factory AdContactsModel.fromJson(Map<String, dynamic> json) {
    return AdContactsModel(
      phone: json['phone'],
      telegram: json['telegram'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['telegram'] = telegram;
    return data;
  }

  Uri get telegramUri => Uri(scheme: 'https', host: 't.me', path: telegram!.replaceAll("@", ''));

  Uri get phoneUri => Uri(scheme: 'tel', path: phone!);
}
