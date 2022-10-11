import 'package:sqflite/sqflite.dart';
import 'package:todo_app/todo.dart';
import 'package:path/path.dart';

final String ColumnId = 'id';
final String ColumnName = 'name';
final String ColumnDate = 'Date';
final String ColumnIsChecked = 'isChecked';
final String ColumntableTodo = 'table_todo';

class Helper {
  late Database db;
  static final Helper instance = Helper._internal();

  factory Helper() {
    return instance;
  }

  Helper._internal();

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'todo.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table $ColumntableTodo (
  $ColumnId integer primary key autoincrement,
  $ColumnName text not null,
  $ColumnDate integer not null,
  $ColumnIsChecked integer not null)
''');
    });
  }

  Future<Todo> insertTodo(Todo todo) async {
    todo.id = await db.insert(ColumntableTodo, todo.tomap());
    return todo;
  }

  Future<int> deleteTodo(int id) async {
    return await db
        .delete(ColumntableTodo, where: '$ColumnId=?', whereArgs: [id]);
  }

  Future<List<Todo>> getAllTodo() async {
    List<Map<String, dynamic>> TodoMaps = await db.query(ColumntableTodo);
    if (TodoMaps.length == 0) {
      return [];
    } else {
      List<Todo> todos = [];
      TodoMaps.forEach((element) {
        todos.add(Todo.fromMap(element));
      });
      return todos;
    }
  }

  Future<int> updateTodo(Todo todo) async {
    return await db.update(ColumntableTodo, todo.tomap(),
        where: '$ColumnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
