import 'dart:convert';
/// id : 1
/// word_classid : 1
/// star : 1
/// word_classword_id : 1
/// word_classword_class : ""
/// p_word : ""
/// body : ""

WordAndPhrasesModel wordAndPhrasesModelFromJson(String str) =>
    WordAndPhrasesModel.fromJson(json.decode(str));
String wordAndPhrasesModelToJson(WordAndPhrasesModel data) => json.encode(data.toJson());

class WordAndPhrasesModel {
  WordAndPhrasesModel({
    int? id,
    int? wordClassid,
    String? star,
    int? wordClasswordId,
    String? wordClasswordClass,
    String? pWord,
    String? body,
  }) {
    _id = id;
    _wordClassid = wordClassid;
    _star = star;
    _wordClasswordId = wordClasswordId;
    _wordClasswordClass = wordClasswordClass;
    _pWord = pWord;
    _body = body;
  }

  WordAndPhrasesModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordClassid = json['word_classid'];
    _star = json['star'];
    _wordClasswordId = json['word_classword_id'];
    _wordClasswordClass = json['word_classword_class'];
    _pWord = json['p_word'];
    _body = json['body'];
  }
  int? _id;
  int? _wordClassid;
  String? _star;
  int? _wordClasswordId;
  String? _wordClasswordClass;
  String? _pWord;
  String? _body;
  WordAndPhrasesModel copyWith({
    int? id,
    int? wordClassid,
    String? star,
    int? wordClasswordId,
    String? wordClasswordClass,
    String? pWord,
    String? body,
  }) =>
      WordAndPhrasesModel(
        id: id ?? _id,
        wordClassid: wordClassid ?? _wordClassid,
        star: star ?? _star,
        wordClasswordId: wordClasswordId ?? _wordClasswordId,
        wordClasswordClass: wordClasswordClass ?? _wordClasswordClass,
        pWord: pWord ?? _pWord,
        body: body ?? _body,
      );
  int? get id => _id;
  int? get wordClassid => _wordClassid;
  String? get star => _star;
  int? get wordClasswordId => _wordClasswordId;
  String? get wordClasswordClass => _wordClasswordClass;
  String? get pWord => _pWord;
  String? get body => _body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_classid'] = _wordClassid;
    map['star'] = _star;
    map['word_classword_id'] = _wordClasswordId;
    map['word_classword_class'] = _wordClasswordClass;
    map['p_word'] = _pWord;
    map['body'] = _body;
    return map;
  }
}
