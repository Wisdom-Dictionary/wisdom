import 'dart:convert';

/// id : 1
/// word : ""
/// translation : ""
/// star : 1,
/// word_classid : 1
/// word_classword_id : 1
/// word_classword_class : ""
/// type : ""

SearchResultModel searchResultModelFromJson(String str) =>
    SearchResultModel.fromJson(json.decode(str));
String searchResultModelToJson(SearchResultModel data) => json.encode(data.toJson());

class SearchResultModel {
  SearchResultModel({
    int? id,
    String? word,
    String? translation,
    String? star,
    int? wordClassid,
    int? wordClasswordId,
    String? wordClasswordClass,
    String? type,
  }) {
    _id = id;
    _word = word;
    _translation = translation;
    _star = star;
    _wordClassid = wordClassid;
    _wordClasswordId = wordClasswordId;
    _wordClasswordClass = wordClasswordClass;
    _type = type;
  }

  SearchResultModel.fromJson(dynamic json) {
    _id = json['id'];
    _word = json['word'];
    _translation = json['translation'];
    _star = json['star'];
    _wordClassid = json['word_classid'];
    _wordClasswordId = json['word_classword_id'];
    _wordClasswordClass = json['word_classword_class'];
    _type = json['type'];
  }
  int? _id;
  String? _word;
  String? _translation;
  String? _star;
  int? _wordClassid;
  int? _wordClasswordId;
  String? _wordClasswordClass;
  String? _type;
  SearchResultModel copyWith({
    int? id,
    String? word,
    String? translation,
    String? star,
    int? wordClassid,
    int? wordClasswordId,
    String? wordClasswordClass,
    String? type,
  }) =>
      SearchResultModel(
        id: id ?? _id,
        word: word ?? _word,
        translation: translation ?? _translation,
        star: star ?? _star,
        wordClassid: wordClassid ?? _wordClassid,
        wordClasswordId: wordClasswordId ?? _wordClasswordId,
        wordClasswordClass: wordClasswordClass ?? _wordClasswordClass,
        type: type ?? _type,
      );
  int? get id => _id;
  String? get word => _word;
  String? get translation => _translation;
  String? get star => _star;
  int? get wordClassid => _wordClassid;
  int? get wordClasswordId => _wordClasswordId;
  String? get wordClasswordClass => _wordClasswordClass;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word'] = _word;
    map['translation'] = _translation;
    map['star'] = _star;
    map['word_classid'] = _wordClassid;
    map['word_classword_id'] = _wordClasswordId;
    map['word_classword_class'] = _wordClasswordClass;
    map['type'] = _type;
    return map;
  }
}
