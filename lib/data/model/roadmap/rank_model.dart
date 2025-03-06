import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

// {
//     "id": 2,
//     "name": "Captain",
//     "icon": "https://wisdom.yangixonsaroy.uz/uploads/ranks/icon/2024/12/12/Q85MfLwoG1QS2pyBPf37Cubs5NfmLtUCPwOcSSxg.jpg",
//     "range_from": "1",
//     "range_to": "1000"
// }

class RankModel {
  int? id;
  String? name;
  String? icon;
  String? rangeFrom;
  String? rangeTo;

  RankModel({
    this.id,
    this.name,
    this.icon,
    this.rangeFrom,
    this.rangeTo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'icon': icon,
      'rangeFrom': rangeFrom,
      'rangeTo': rangeTo,
    };
  }

  factory RankModel.fromJson(Map<String, dynamic> map) {
    return RankModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
      rangeFrom: map['range_from'] != null ? map['range_from'] as String : null,
      rangeTo: map['range_to'] != null ? map['range_to'] as String : null,
    );
  }
}
