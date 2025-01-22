import 'dart:convert';

/// id : 1
/// word_class : ""
/// type : ""
/// star : 0
/// same : ["",""]

SearchResultUzModel searchResultUzModelFromJson(String str) => SearchResultUzModel.fromJson(json.decode(str));

String searchResultUzModelToJson(SearchResultUzModel data) => json.encode(data.toJson());

class SearchResultUzModel {
  SearchResultUzModel({
    int? id,
    String? word,
    String? wordClass,
    String? type,
    String? star,
    String? same,
  }) {
    _id = id;
    _word = word;
    _wordClass = wordClass;
    _type = type;
    _star = star;
    _same = same;
  }

  SearchResultUzModel.fromJson(dynamic json) {
    _id = json['id'];
    _word = json['word'];
    _wordClass = json['word_class'];
    _type = json['type'];
    _star = json['star'];
    _same = json['same'];
  }

  int? _id;
  String? _word;
  String? _wordClass;
  String? _type;
  String? _star;
  String? _same;

  SearchResultUzModel copyWith({
    int? id,
    String? word,
    String? wordClass,
    String? type,
    String? star,
    String? same,
  }) =>
      SearchResultUzModel(
        id: id ?? _id,
        word: word ?? _word,
        wordClass: wordClass ?? _wordClass,
        type: type ?? _type,
        star: star ?? _star,
        same: same ?? _same,
      );

  int? get id => _id;

  String? get word => _word;

  String? get wordClass => _wordClass;

  String? get type => _type;

  String? get star => _star;

  set star(String? newStar) => _star = newStar;

  String? get same => _same;

  set same(String? newSame) => _same = newSame;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word'] = _word;
    map['word_class'] = _wordClass;
    map['type'] = _type;
    map['star'] = _star;
    map['same'] = _same;
    return map;
  }
}
