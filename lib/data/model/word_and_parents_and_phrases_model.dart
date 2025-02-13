import 'dart:convert';
/// id : 1
/// word_classid : 1
/// star : 1
/// word_classword_id : 1
/// word_classword_class : ""
/// p_word : ""
/// body : ""
/// word : ""

WordAndParentsAndPhrasesModel wordAndParentsAndPhrasesModelFromJson(String str) => WordAndParentsAndPhrasesModel.fromJson(json.decode(str));
String wordAndParentsAndPhrasesModelToJson(WordAndParentsAndPhrasesModel data) => json.encode(data.toJson());
class WordAndParentsAndPhrasesModel {
  WordAndParentsAndPhrasesModel({
      int? id, 
      int? wordClassid,
    String? star,
      int? wordClasswordId, 
      String? wordClasswordClass, 
      String? pWord, 
      String? body, 
      String? word,}){
    _id = id;
    _wordClassid = wordClassid;
    _star = star;
    _wordClasswordId = wordClasswordId;
    _wordClasswordClass = wordClasswordClass;
    _pWord = pWord;
    _body = body;
    _word = word;
}

  WordAndParentsAndPhrasesModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordClassid = json['word_classid'];
    _star = json['star'];
    _wordClasswordId = json['word_classword_id'];
    _wordClasswordClass = json['word_classword_class'];
    _pWord = json['p_word'];
    _body = json['body'];
    _word = json['word'];
  }
  int? _id;
  int? _wordClassid;
  String? _star;
  int? _wordClasswordId;
  String? _wordClasswordClass;
  String? _pWord;
  String? _body;
  String? _word;
WordAndParentsAndPhrasesModel copyWith({  int? id,
  int? wordClassid,
  String? star,
  int? wordClasswordId,
  String? wordClasswordClass,
  String? pWord,
  String? body,
  String? word,
}) => WordAndParentsAndPhrasesModel(  id: id ?? _id,
  wordClassid: wordClassid ?? _wordClassid,
  star: star ?? _star,
  wordClasswordId: wordClasswordId ?? _wordClasswordId,
  wordClasswordClass: wordClasswordClass ?? _wordClasswordClass,
  pWord: pWord ?? _pWord,
  body: body ?? _body,
  word: word ?? _word,
);
  int? get id => _id;
  int? get wordClassid => _wordClassid;
  String? get star => _star;
  int? get wordClasswordId => _wordClasswordId;
  String? get wordClasswordClass => _wordClasswordClass;
  String? get pWord => _pWord;
  String? get body => _body;
  String? get word => _word;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_classid'] = _wordClassid;
    map['star'] = _star;
    map['word_classword_id'] = _wordClasswordId;
    map['word_classword_class'] = _wordClasswordClass;
    map['p_word'] = _pWord;
    map['body'] = _body;
    map['word'] = _word;
    return map;
  }

}
