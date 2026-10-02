
import 'package:flutter/material.dart';
import 'package:todo_list/home/home_cubit.dart';
import 'package:todo_list/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  HomeCubit _cubit = HomeCubit();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => _cubit,
        child: MyHomePage(cubit: _cubit),
      ),
    );
  }
}