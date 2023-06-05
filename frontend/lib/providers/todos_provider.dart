import 'package:flutter/cupertino.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> todos = [];
  Todo? fetchedTodo;
  bool isLoading = true;

  TodoProvider() {
    //fetchTodos();
  }

  Future<Todo> addTodo(Todo todo) async {
    Todo createdTodo = await ApiService.addTodo(todo);
    todos.add(createdTodo);
    notifyListeners();
    return createdTodo;
  }

  Future<List<Todo>> fetchTodosByNoteId(String noteId) async {
    try {
      todos = await ApiService.fetchTodosByNoteId(noteId);
      return todos;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch todos');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Todo> fetchTodoByTodoId(String todoId) async {
    try {
      Todo fetchedTodo = await ApiService.fetchTodoByTodoId(todoId);
      isLoading = false;
      notifyListeners();
      return fetchedTodo;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to fetch todo');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    int index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      todos[index] = updatedTodo;
      if (updatedTodo.notes != null) {
        todos[index].notes = updatedTodo.notes;
      }
    }
    await ApiService.updateTodo(updatedTodo);
    notifyListeners();
  }
}
