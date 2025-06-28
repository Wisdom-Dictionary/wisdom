class ExerciseModel {
  ExerciseModel({
    required this.tableId,
    required this.id,
    required this.word,
    required this.wordClass,
    required this.wordClassBody,
    required this.translation,
    required this.example,
  });

  final int? tableId;
  final int? id;
  final String word;
  final String? wordClass;
  final String? wordClassBody;
  final String translation;
  final String? example;

  @override
  bool operator ==(Object other) {
    return (other is ExerciseModel) &&
        other.tableId == tableId &&
        other.id == id &&
        other.word == word &&
        other.wordClass == wordClass &&
        other.wordClassBody == wordClassBody &&
        other.translation == translation &&
        other.example == example;
  }
}

class ExerciseFinalModel {
  ExerciseFinalModel({
    required this.tableId,
    required this.id,
    required this.word,
    required this.translation,
    required this.result,
  });

  @override
  bool operator ==(Object other) {
    return (other is ExerciseFinalModel) &&
        other.tableId == tableId &&
        other.id == id &&
        other.word == word &&
        other.translation == translation &&
        other.result == result;
  }

  @override
  int get hashCode =>
      id.hashCode ^ word.hashCode ^ translation.hashCode ^ result.hashCode ^ tableId.hashCode;

  final int? tableId;
  final int? id;
  final String word;
  final String translation;
  final bool result;
}
