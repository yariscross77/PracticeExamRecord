import 'package:flutter/material.dart';
import 'database_helper.dart';

class DetailPage extends StatefulWidget {
  final int ID;

  const DetailPage({Key? key, required this.ID}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  final db_helper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _data = [];
  late int _ID;

  String practice_exam_name = '';
  String practice_exam_date = '';
  String practice_exam_date_show = '';
  int deviation_score = 0;
  int Japanese_score = 0;
  int math_score = 0;
  int English_score = 0;
  int science_score = 0;
  int social_studies_score = 0;
  int sum_score = 0;
  double font_size = 16;

  void initState() {
    super.initState();
    _ID = widget.ID;
    _getDataFromDatabase();
    // print('受け渡し' + _ID.toString());
  }

  Future<void> _getDataFromDatabase() async {
    final List<Map<String, dynamic>> data = await db_helper.select_detail(_ID);
    setState(() {
      _data = data; // データをリストに設定

      practice_exam_name = _data[0]['practice_exam_name'];
      practice_exam_date = _data[0]['practice_exam_date'];
      practice_exam_date_show = _data[0]['practice_exam_date_show'];
      deviation_score = _data[0]['deviation_score'];
      Japanese_score = _data[0]['Japanese_score'];
      math_score = _data[0]['math_score'];
      English_score = _data[0]['English_score'];
      science_score = _data[0]['science_score'];
      social_studies_score = _data[0]['social_studies_score'];
      sum_score = _data[0]['sum_score'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      practice_exam_name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '受験日：' + practice_exam_date_show,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 15)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            '偏差値',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '合計点',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '国語',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '数学',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '英語',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '理科',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '社会',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(
                              Text(
                                deviation_score.toString(),
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                sum_score.toString(),
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                Japanese_score.toString(),
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                math_score.toString(),
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                English_score.toString(),
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                science_score.toString(),
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                social_studies_score.toString(),
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '※横にスクロールできます',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),

                  /*
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowHeight: 0,
                    columns: [
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('偏差値')),
                          DataCell(Text('70')),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('合計点')),
                          DataCell(Text(_data[0]['sum_score'].toString())),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('国語')),
                          DataCell(Text(_data[0]['Japanese_score'].toString())),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('数学')),
                          DataCell(Text(_data[0]['math_score'].toString())),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('英語')),
                          DataCell(Text(_data[0]['English_score'].toString())),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('理科')),
                          DataCell(Text(_data[0]['science_score'].toString())),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('社会')),
                          DataCell(Text(
                              _data[0]['social_studies_score'].toString())),
                        ],
                      ),
                    ],
                  ),
                ),*/
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            '志望校',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '科',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ランク',
                            style: TextStyle(fontSize: font_size),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(
                              Text(
                                '福島',
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                '普通',
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                            DataCell(
                              Text(
                                'S',
                                style: TextStyle(fontSize: font_size),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              '橘',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              '普通',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              'S',
                              style: TextStyle(fontSize: font_size),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              '福島東',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              '普通',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              'S',
                              style: TextStyle(fontSize: font_size),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              '福島南',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              '国際文化',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              'S',
                              style: TextStyle(fontSize: font_size),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              '福島成蹊',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              '普通',
                              style: TextStyle(fontSize: font_size),
                            )),
                            DataCell(Text(
                              'S',
                              style: TextStyle(fontSize: font_size),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
