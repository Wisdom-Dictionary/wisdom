import 'package:easy_localization/easy_localization.dart';
import 'package:wisdom/data/enums/gender.dart';

class UserModel {
  final int? id;
  final String? phone;
  final String? name;
  final String? email;
  final String? providerName;
  final String? providerId;
  final String? image;
  final DateTime? birthDate;
  final Gender? gender;
  final DateTime? expiryDate;
  final int? tariffId;
  final int? notification;

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.birthDate,
    this.gender = Gender.none,
    this.notification,
    this.expiryDate,
    this.providerId,
    this.providerName,
    this.tariffId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'],
      email: json['email'],
      image: json['image'],
      phone: json['phone'] != null ? (json['phone'] as num).toInt().toString() : null,
      birthDate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      gender: json['gender'] != null
          ? Gender.values.firstWhere((element) => element.name == json['gender'])
          : null,
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date']) : null,
      providerId: json['provider_id'],
      providerName: json['provider_name'],
      tariffId: json['tariff_id'] as int?,
      notification: json['notification'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['phone'] = phone != null && phone!.isNotEmpty ? int.parse(phone!) : null;
    data['birthdate'] = birthDate?.toString();
    data['gender'] = gender?.name;
    data['expiry_date'] = expiryDate?.toString();
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['tariff_id'] = tariffId;
    data['notification'] = notification;
    return data;
  }

  String get birthDateString => birthDate != null ? DateFormat('y/MM/dd').format(birthDate!) : '';

  String get userFullName => name ?? '';

  @override
  bool operator ==(Object other) =>
      other is UserModel &&
      other.name == name &&
      other.email == email &&
      other.image == image &&
      other.phone == phone &&
      other.birthDate == birthDate &&
      other.gender == gender;

  @override
  int get hashCode => super.hashCode;

  UserModel copyWith({
    int? id,
    String? phone,
    String? name,
    String? email,
    String? providerName,
    String? providerId,
    String? image,
    DateTime? birthDate,
    Gender? gender,
    DateTime? expiryDate,
    int? tariffId,
    int? notification,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      providerName: providerName ?? this.providerName,
      providerId: providerId ?? this.providerId,
      image: image ?? this.image,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      expiryDate: expiryDate ?? this.expiryDate,
      tariffId: tariffId ?? this.tariffId,
      notification: notification ?? this.notification,
    );
  }
}
