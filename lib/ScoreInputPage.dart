import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HistoryPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '模試',
      home: const ScoreInputPage(),
    );
  }
}

class ScoreInputPage extends StatefulWidget {
  const ScoreInputPage({super.key});

  @override
  State<ScoreInputPage> createState() => _ScoreInputPage();
}

class _ScoreInputPage extends State<ScoreInputPage> {
  final TextEditingController _Japanese_score = TextEditingController();
  final TextEditingController _math_score = TextEditingController();
  final TextEditingController _English_score = TextEditingController();
  final TextEditingController _science_score = TextEditingController();
  final TextEditingController _social_studies_score = TextEditingController();

  final _formState = GlobalKey<FormState>();

  int _selectedIndex = 0;

  void dispose() {
    _Japanese_score.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const _pages = [
    ScoreInputPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('模試の記録'),
      ),
      body: Form(
        key: _formState,
        child: Container(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text('国語'),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                maxLength: 3,
                controller: _Japanese_score,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '得点が入力されていません。';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('数学'),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                maxLength: 3,
                controller: _math_score,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '得点が入力されていません。';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('英語'),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                maxLength: 3,
                controller: _English_score,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '得点が入力されていません。';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('理科'),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                maxLength: 3,
                controller: _science_score,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '得点が入力されていません。';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('社会'),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                maxLength: 3,
                controller: _social_studies_score,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '得点が入力されていません。';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: Text('登録'),
                onPressed: () {
                  if (!_formState.currentState!.validate()) {
                    return;
                  }

                  print(_Japanese_score.text);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '得点入力'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '今までの結果'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'グラフ'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
