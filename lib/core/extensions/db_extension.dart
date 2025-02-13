import 'package:wisdom/data/model/base_table_model.dart';

extension EntityExtension on List<BaseTableModel> {
  String  generateInsertOrReplaceQuery(String tableName) {
    final entities = this;
    if (entities.isEmpty) {
      return '';
    }
    var columns = first.toJson().keys.join(', ');
    var values = entities.map((entity) {
      var formattedValues = entity.toJson().values.map((value) {
        if (value is String) {
          return "'${value.replaceAll("'", "''")}'";
        } else {
          return '$value';
        }
      });
      return '(${formattedValues.join(', ')})';
    }).join(', ');
    return 'INSERT or replace INTO $tableName  ($columns) VALUES $values ;';
  }
}
