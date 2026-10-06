import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeChanget;
  const SettingsPage({super.key, required this.isDarkTheme, required this.onThemeChanget});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
 
  bool _isDarkTheme = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
        elevation: 0,
        centerTitle: true,
        
        title: Text(
          'Настройки',
          style: TextStyle(
            color: _isDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
             
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Тёмная тема',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Использовать тёмное\nоформление приложения',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    
                    Switch(
                      value: _isDarkTheme,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _isDarkTheme = value;
                        });
                        saveTheme();
                        widget.onThemeChanget(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveTheme()async{
    final preferences = await SharedPreferences.getInstance();//достали обьект настроек (файл)
    preferences.setBool('isDarkTheme', _isDarkTheme);
  }
}