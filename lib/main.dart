import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/home/home_cubit.dart';
import 'package:todo_list/home/home_page.dart';
import 'package:todo_list/home/onboarding_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  final isDarkTheme = preferences.getBool('isDarkTheme') ?? false;
  final isOnboardingSeen = preferences.getBool('isOnboardingSeen') ?? false;

  print('Dark Theme: $isDarkTheme');
  print('Onboarding Seen: $isOnboardingSeen');

  runApp(MyApp(
    isDarkTheme: isDarkTheme,
    isOnboardingSeen: isOnboardingSeen,
  ));
}

class MyApp extends StatefulWidget {
  final bool isDarkTheme;
  final bool isOnboardingSeen;

  const MyApp({
    super.key,
    required this.isDarkTheme,
    required this.isOnboardingSeen,
  });

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkTheme;
  final HomeCubit _cubit = HomeCubit();

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      
     
      home: widget.isOnboardingSeen
          ? BlocProvider(
              create: (_) => _cubit,
              child: MyHomePage(
                cubit: _cubit,
                isDarkTheme: _isDarkTheme,
                onThemeChanget: changeTheme,
              ),
            )
           : OnboardingPage(
              cubit: _cubit,
              isDarkTheme: _isDarkTheme,
              onThemeChanget: changeTheme,
            ),
    );
  }

  void changeTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
    });
  }
}