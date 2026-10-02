import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/database/app_database.dart';
import 'package:todo_list/database/todo.dart';
import 'package:todo_list/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppDatabase db = AppDatabase();

  HomeCubit():super(HomeState(todoList: [], status: .isLoading));

  List<Todo> getTodoList(){
    final todoList = db.getTodoList();

    if (todoList.isEmpty){
      emit(state.copyWith(status: .empty));
    
    }else {
      emit(state.copyWith(status: .success));
    }

    return todoList;
  }
}
