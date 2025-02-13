import 'dart:convert';
/// id : 1
/// word_class : ""
/// star : ""
/// word : ""
/// related_word : ""

WordAndParentsAndWordsUzModel wordAndParentsAndWordsUzModelFromJson(String str) => WordAndParentsAndWordsUzModel.fromJson(json.decode(str));
String wordAndParentsAndWordsUzModelToJson(WordAndParentsAndWordsUzModel data) => json.encode(data.toJson());
class WordAndParentsAndWordsUzModel {
  WordAndParentsAndWordsUzModel({
      int? id, 
      String? wordClass, 
      String? star, 
      String? word, 
      String? relatedWord,}){
    _id = id;
    _wordClass = wordClass;
    _star = star;
    _word = word;
    _relatedWord = relatedWord;
}

  WordAndParentsAndWordsUzModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordClass = json['word_class'];
    _star = json['star'];
    _word = json['word'];
    _relatedWord = json['related_word'];
  }
  int? _id;
  String? _wordClass;
  String? _star;
  String? _word;
  String? _relatedWord;
WordAndParentsAndWordsUzModel copyWith({  int? id,
  String? wordClass,
  String? star,
  String? word,
  String? relatedWord,
}) => WordAndParentsAndWordsUzModel(  id: id ?? _id,
  wordClass: wordClass ?? _wordClass,
  star: star ?? _star,
  word: word ?? _word,
  relatedWord: relatedWord ?? _relatedWord,
);
  int? get id => _id;
  String? get wordClass => _wordClass;
  String? get star => _star;
  String? get word => _word;
  String? get relatedWord => _relatedWord;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_class'] = _wordClass;
    map['star'] = _star;
    map['word'] = _word;
    map['related_word'] = _relatedWord;
    return map;
  }

}
