import 'dart:convert';
/// id : 1
/// word : ""
/// word_class : ""
/// type : ""
/// same : ""
/// star : ""

RecentModel recentModelFromJson(String str) => RecentModel.fromJson(json.decode(str));
String recentModelToJson(RecentModel data) => json.encode(data.toJson());

class RecentModel {
  RecentModel({
    int? id,
    String? word,
    String? wordClass,
    String? type,
    String? same,
    String? star,
  }) {
    _id = id;
    _word = word;
    _wordClass = wordClass;
    _type = type;
    _same = same;
    _star = star;
  }

  RecentModel.fromJson(dynamic json) {
    _id = json['id'];
    _word = json['word'];
    _wordClass = json['word_class'];
    _type = json['type'];
    _same = json['same'];
    _star = json['star'];
  }
  int? _id;
  String? _word;
  String? _wordClass;
  String? _type;
  String? _same;
  String? _star;
  RecentModel copyWith({
    int? id,
    String? word,
    String? wordClass,
    String? type,
    String? same,
    String? star,
  }) =>
      RecentModel(
        id: id ?? _id,
        word: word ?? _word,
        wordClass: wordClass ?? _wordClass,
        type: type ?? _type,
        same: same ?? _same,
        star: star ?? _star,
      );
  int? get id => _id;
  String? get word => _word;
  String? get wordClass => _wordClass;
  String? get type => _type;
  String? get same => _same;
  String? get star => _star;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word'] = _word;
    map['word_class'] = _wordClass;
    map['type'] = _type;
    map['same'] = _same;
    map['star'] = _star;
    return map;
  }
}
