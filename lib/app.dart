import 'package:flutter/material.dart';
import 'package:practice_exam_record/GraphPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ScoreInputPage.dart';
import 'HistoryPage.dart';
import 'GraphPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '模試',
      debugShowCheckedModeBanner: false,
      home: const Navigation(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja'),
      ],
      // locale: const Locale('ja'),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const _pages = [
    ScoreInputPage(),
    HistoryPage(),
    GraphPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: '得点入力'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '今までの記録'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '推移'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
