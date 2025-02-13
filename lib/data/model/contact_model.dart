import 'package:url_launcher/url_launcher.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/extensions/string_extension.dart';

class ContactModel {
  final int id;
  final String? target;
  final String? type;
  final String? value;
  final String? label;
  final String? icon;

  const ContactModel({
    required this.id,
    this.target,
    this.type,
    this.value,
    this.label,
    this.icon,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int,
      target: json['target'],
      type: json['type'],
      value: json['value'],
      label: json['label'],
      icon: json['icon'],
    );
  }

  String get iconUrl => icon != null ? "${Urls.baseUrl}$icon" : "";

  String get typeName => type != null ? type!.capitalizeByWord() : "";

  Uri get telegramUri => Uri(scheme: 'https', host: 't.me', path: value!.replaceAll("@", ''));

  Uri get phoneUri => Uri(scheme: 'tel', path: value!);

  Uri get link {
    return switch (type) {
      'phone' => phoneUri,
      _ => Uri.parse(value!),
    };
  }

  Future launch() async {
    if (value == null) {
      return;
    }
    await launchUrl(link);
  }
}
//* {
//             "id": 1,
//             "target": "ad",
//             "type": "phone",
//             "value": "+998901234567",
//             "label": "+998 90 123-45-67",
//             "icon": "/img/icons/line.svg"
//         },
// *//
