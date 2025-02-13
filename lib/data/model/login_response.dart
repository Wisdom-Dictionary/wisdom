import 'package:wisdom/data/model/tariffs_model.dart';

class LoginResponse {
  bool? status;
  String? token;
  int? expiryTariff;
  List<TariffsModel>? tariffs;

  LoginResponse({
    this.status,
    this.token,
    this.expiryTariff,
    this.tariffs,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    List<TariffsModel>? tariffsList = [];
    if (json['tariffs'] != null) {
      json['tariffs'].forEach((v) {
        tariffsList.add(TariffsModel.fromJson(v));
      });
    }
    return LoginResponse(
      status: json["status"],
      token: json["token"],
      expiryTariff: json["expiry_tariff"],
      tariffs: tariffsList.isEmpty ? null : tariffsList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["token"] = token;
    data["expiry_tariff"] = expiryTariff;
    if (tariffs != null) {
      data["tariffs"] = tariffs?.map((v) => v.toJson()).toList();
    }
    return data;
  }


}
