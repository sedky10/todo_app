import 'helper.dart';

class Todo {
  int? id;
  late int date;
  late String name;
  late bool isChecked;

  Todo({
    this.id,
    required this.name,
    required this.date,
    required this.isChecked,
  });

  Todo.fromMap(Map<String, dynamic> map) {
    if (map[ColumnId] != null) {
      this.id = map[ColumnId];
    }
    this.date = map[ColumnDate];
    this.name = map[ColumnName];
    this.isChecked = map[ColumnIsChecked] == 0 ? false : true;
  }

  Map<String, dynamic> tomap() {
    Map<String, dynamic> map = {};
    if (this.id != null) {
      map[ColumnId] = this.id;
    }
    map[ColumnDate] = this.date;
    map[ColumnName] = this.name;
    map[ColumnIsChecked] = this.isChecked ? 1 : 0;
    return map;
  }
}
