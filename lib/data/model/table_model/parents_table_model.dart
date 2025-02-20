import 'dart:convert';

import 'package:wisdom/data/model/base_table_model.dart';

/// id : 1
/// word_id : 1
/// word : ""
/// star : ""
/// body : ""
/// synonyms : ""
/// anthonims : ""
/// comment : ""
/// example : ""
/// link_word : ""
/// examples : ""
/// more_examples : ""
/// word_classid : 1
/// word_classword_id : 1
/// word_classword_class : ""
/// word_class_body : ""
/// word_class_body_meaning : ""
/// image : ""

ParentsTableModel parentsTableModelFromJson(String str) =>
    ParentsTableModel.fromJson(json.decode(str));
String parentsTableModelToJson(ParentsTableModel data) => json.encode(data.toJson());

class ParentsTableModel extends BaseTableModel {
  ParentsTableModel({
    int? id,
    int? wordId,
    String? word,
    String? star,
    String? body,
    String? synonyms,
    String? anthonims,
    String? comment,
    String? example,
    String? linkWord,
    String? examples,
    String? moreExamples,
    int? wordClassid,
    int? wordClasswordId,
    String? wordClasswordClass,
    String? wordClassBody,
    String? wordClassBodyMeaning,
    String? image,
  }) {
    _id = id;
    _wordId = wordId;
    _word = word;
    _star = star;
    _body = body;
    _synonyms = synonyms;
    _anthonims = anthonims;
    _comment = comment;
    _example = example;
    _linkWord = linkWord;
    _examples = examples;
    _moreExamples = moreExamples;
    _wordClassid = wordClassid;
    _wordClasswordId = wordClasswordId;
    _wordClasswordClass = wordClasswordClass;
    _wordClassBody = wordClassBody;
    _wordClassBodyMeaning = wordClassBodyMeaning;
    _image = image;
  }

  ParentsTableModel.fromJson(dynamic json) {
    _id = json['id'];
    _wordId = json['word_id'];
    _word = json['word'];
    _star = json['star'];
    _body = json['body'];
    _synonyms = json['synonyms'];
    _anthonims = json['anthonims'];
    _comment = json['comment'];
    _example = json['example'];
    _linkWord = json['link_word'];
    _examples = json['examples'];
    _moreExamples = json['more_examples'];
    _wordClassid = json['word_classid'];
    _wordClasswordId = json['word_classword_id'];
    _wordClasswordClass = json['word_classword_class'];
    _wordClassBody = json['word_class_body'];
    _wordClassBodyMeaning = json['word_class_body_meaning'];
    _image = json['image'];
  }
  int? _id;
  int? _wordId;
  String? _word;
  String? _star;
  String? _body;
  String? _synonyms;
  String? _anthonims;
  String? _comment;
  String? _example;
  String? _linkWord;
  String? _examples;
  String? _moreExamples;
  int? _wordClassid;
  int? _wordClasswordId;
  String? _wordClasswordClass;
  String? _wordClassBody;
  String? _wordClassBodyMeaning;
  String? _image;
  ParentsTableModel copyWith({
    int? id,
    int? wordId,
    String? word,
    String? star,
    String? body,
    String? synonyms,
    String? anthonims,
    String? comment,
    String? example,
    String? linkWord,
    String? examples,
    String? moreExamples,
    int? wordClassid,
    int? wordClasswordId,
    String? wordClasswordClass,
    String? wordClassBody,
    String? wordClassBodyMeaning,
    String? image,
  }) =>
      ParentsTableModel(
        id: id ?? _id,
        wordId: wordId ?? _wordId,
        word: word ?? _word,
        star: star ?? _star,
        body: body ?? _body,
        synonyms: synonyms ?? _synonyms,
        anthonims: anthonims ?? _anthonims,
        comment: comment ?? _comment,
        example: example ?? _example,
        linkWord: linkWord ?? _linkWord,
        examples: examples ?? _examples,
        moreExamples: moreExamples ?? _moreExamples,
        wordClassid: wordClassid ?? _wordClassid,
        wordClasswordId: wordClasswordId ?? _wordClasswordId,
        wordClasswordClass: wordClasswordClass ?? _wordClasswordClass,
        wordClassBody: wordClassBody ?? _wordClassBody,
        wordClassBodyMeaning: wordClassBodyMeaning ?? _wordClassBodyMeaning,
        image: image ?? _image,
      );
  int? get id => _id;
  int? get wordId => _wordId;
  String? get word => _word;
  String? get star => _star;
  String? get body => _body;
  String? get synonyms => _synonyms;
  String? get anthonims => _anthonims;
  String? get comment => _comment;
  String? get example => _example;
  String? get linkWord => _linkWord;
  String? get examples => _examples;
  String? get moreExamples => _moreExamples;
  int? get wordClassid => _wordClassid;
  int? get wordClasswordId => _wordClasswordId;
  String? get wordClasswordClass => _wordClasswordClass;
  String? get wordClassBody => _wordClassBody;
  String? get wordClassBodyMeaning => _wordClassBodyMeaning;
  String? get image => _image;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['word_id'] = _wordId;
    map['word'] = _word;
    map['star'] = _star;
    map['body'] = _body;
    map['synonyms'] = _synonyms;
    map['anthonims'] = _anthonims;
    map['comment'] = _comment;
    map['example'] = _example;
    map['link_word'] = _linkWord;
    map['examples'] = _examples;
    map['more_examples'] = _moreExamples;
    map['word_classid'] = _wordClassid;
    map['word_classword_id'] = _wordClasswordId;
    map['word_classword_class'] = _wordClasswordClass;
    map['word_class_body'] = _wordClassBody;
    map['word_class_body_meaning'] = _wordClassBodyMeaning;
    map['image'] = _image;
    return map;
  }
}
