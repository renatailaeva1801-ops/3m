import 'package:todo_list/database/todo.dart';

class AppDatabase {
  List<Todo> _todolist = [
Todo(id: 1, title: 'купить книгу', craatedAt: '28.02.2026', isdone: true),
Todo(id: 2, title: 'купить новфй телефон', craatedAt: '14.03.2026', isdone: false),
Todo(id: 3, title: 'записаться в зал', craatedAt: '25.05.2026', isdone: false)
  ];

  List<Todo> getTodoList(){
    return _todolist;
  }
}