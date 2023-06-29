import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'DetailPage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
  final db_helper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _data = [];

  void initState() {
    super.initState();
    _getDataFromDatabase(); // データベースからデータを取得
  }

  Future<void> _getDataFromDatabase() async {
    final List<Map<String, dynamic>> data = await db_helper.select();
    setState(() {
      _data = data; // データをリストに設定
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今までの記録（' + _data.length.toString() + '）'),
      ),
      body: _data.length >= 1
          ? Container(
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(_data[index]['practice_exam_name']),
                      subtitle: Text(
                          '受験日：' + _data[index]['practice_exam_date_show']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(ID: _data[index]['ID']),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('本当にこのデータを削除しますか？'),
                                content: Text('選択したデータが削除されます。'),
                                actions: [
                                  TextButton(
                                    child: Text('いいえ'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('はい'),
                                    onPressed: () {
                                      _delete(_data[index]['ID']);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  'データがありません。',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
    );
  }

  void _delete(int ID) async {
    await db_helper.delete(ID);
    _getDataFromDatabase();
  }
}
