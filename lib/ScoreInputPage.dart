import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

enum rank { S, A, B, C, D, E }

rank _fukushima_rank = rank.S;
rank _tachibana_rank = rank.S;
rank _fukushima_east_rank = rank.S;
rank _fukushima_south_rank = rank.S;
rank _fukushima_seikei_rank = rank.S;

class ScoreInputPage extends StatefulWidget {
  const ScoreInputPage({super.key});

  @override
  State<ScoreInputPage> createState() => _ScoreInputPage();
}

class _ScoreInputPage extends State<ScoreInputPage> {
  final TextEditingController _deviation_score = TextEditingController();
  final TextEditingController _Japanese_score = TextEditingController();
  final TextEditingController _math_score = TextEditingController();
  final TextEditingController _English_score = TextEditingController();
  final TextEditingController _science_score = TextEditingController();
  final TextEditingController _social_studies_score = TextEditingController();

  final _formState = GlobalKey<FormState>();
  final db_helper = DatabaseHelper.instance;
  final focusNode = FocusNode();

  String practice_exam_name = "error";
  String practice_exam_date = "";
  String practice_exam_date_show = "";
  String _selectedDate = "受験日：選択されていません。";
  String score_error = "0～50の間で入力してください。";

  double font_size = 16;
  double padding_top = 20;

  bool isSelectedDateError = false;

  DateTime selectedDate = DateTime.now();

  final score_regxp = RegExp(
    caseSensitive: false,
    '[0][0-9]',
  );

  final score_regxp2 = RegExp(
    caseSensitive: false,
    '[6-9][0]|[5-9][1-9]',
  );

  void dispose() {
    _Japanese_score.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 100),
      locale: const Locale('ja'),
    );

    if (picked != null) {
      setState(
        () {
          selectedDate = picked;

          String week = "";
          switch (selectedDate.weekday) {
            case 1:
              week = "(月)";
              break;
            case 2:
              week = "(火)";
              break;
            case 3:
              week = "(水)";
              break;
            case 4:
              week = "(木)";
              break;
            case 5:
              week = "(金)";
              break;
            case 6:
              week = "(土)";
              break;
            case 7:
              week = "(日)";
              break;
          }
          practice_exam_date_show = selectedDate.year.toString() +
              "年" +
              selectedDate.month.toString() +
              "月" +
              selectedDate.day.toString() +
              "日" +
              week;

          practice_exam_date = selectedDate.year.toString() +
              "/" +
              selectedDate.month.toString() +
              "/" +
              selectedDate.day.toString();

          _selectedDate = "受験日：" + practice_exam_date_show;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('得点入力'),
      ),
      body: Focus(
        focusNode: focusNode,
        child: GestureDetector(
          onTap: focusNode.requestFocus,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formState,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            label: Text('テスト名'),
                            border: OutlineInputBorder(),
                          ),
                          value: practice_exam_name,
                          items: const [
                            DropdownMenuItem(
                              value: 'error',
                              child: Text('受験した模試を選択してください。'),
                            ),
                            DropdownMenuItem(
                              value: '実力テスト',
                              child: Text('実力テスト'),
                            ),
                            DropdownMenuItem(
                              value: '新教研もぎテスト',
                              child: Text('新教研もぎテスト'),
                            ),
                            DropdownMenuItem(
                              value: '全国統一中学生テスト',
                              child: Text('全国統一中学生テスト'),
                            ),
                            DropdownMenuItem(
                              value: '合格ナビ模試',
                              child: Text('合格ナビ模試'),
                            ),
                            DropdownMenuItem(
                              value: 'その他',
                              child: Text('その他'),
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              practice_exam_name = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == "error") {
                              return '受験した模試が選択されていません。';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              _selectedDate,
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.date_range),
                                onPressed: () {
                                  _selectDate(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isSelectedDateError,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              '日付が選択されていません。',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD32F2F),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('偏差値'),
                            prefixIcon: Icon(Icons.psychology_alt),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          controller: _deviation_score,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '偏差値が入力されていません。';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('国語'),
                            prefixIcon: Icon(Icons.menu_book),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          controller: _Japanese_score,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '得点が入力されていません。';
                            } else if (score_regxp.hasMatch(value)) {
                              return score_error;
                            } else if (score_regxp2.hasMatch(value)) {
                              return score_error;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('数学'),
                            prefixIcon: Icon(Icons.onetwothree),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          controller: _math_score,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '得点が入力されていません。';
                            } else if (score_regxp.hasMatch(value)) {
                              return score_error;
                            } else if (score_regxp2.hasMatch(value)) {
                              return score_error;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('英語'),
                            prefixIcon: Icon(Icons.abc),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          controller: _English_score,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '得点が入力されていません。';
                            } else if (score_regxp.hasMatch(value)) {
                              return score_error;
                            } else if (score_regxp2.hasMatch(value)) {
                              return score_error;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('理科'),
                            prefixIcon: Icon(Icons.science),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          controller: _science_score,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '得点が入力されていません。';
                            } else if (score_regxp.hasMatch(value)) {
                              return score_error;
                            } else if (score_regxp2.hasMatch(value)) {
                              return score_error;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('社会'),
                            prefixIcon: Icon(Icons.map),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          controller: _social_studies_score,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '得点が入力されていません。';
                            } else if (score_regxp.hasMatch(value)) {
                              return score_error;
                            } else if (score_regxp2.hasMatch(value)) {
                              return score_error;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                                    Container(
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.S,
                                                  groupValue: _fukushima_rank,
                                                  onChanged: (value) {
                                                    _onFukushimarankSelected(
                                                        value);
                                                  }),
                                              Text('S'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.A,
                                                  groupValue: _fukushima_rank,
                                                  onChanged: (value) {
                                                    _onFukushimarankSelected(
                                                        value);
                                                  }),
                                              Text('A'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.B,
                                                  groupValue: _fukushima_rank,
                                                  onChanged: (value) {
                                                    _onFukushimarankSelected(
                                                        value);
                                                  }),
                                              Text('B'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.C,
                                                  groupValue: _fukushima_rank,
                                                  onChanged: (value) {
                                                    _onFukushimarankSelected(
                                                        value);
                                                  }),
                                              Text('C'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.D,
                                                  groupValue: _fukushima_rank,
                                                  onChanged: (value) {
                                                    _onFukushimarankSelected(
                                                        value);
                                                  }),
                                              Text('D'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.E,
                                                  groupValue: _fukushima_rank,
                                                  onChanged: (value) {
                                                    _onFukushimarankSelected(
                                                        value);
                                                  }),
                                              Text('E'),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                  DataCell(
                                    Container(
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.S,
                                                  groupValue: _tachibana_rank,
                                                  onChanged: (value) {
                                                    _onTachibanarankSelected(
                                                        value);
                                                  }),
                                              Text('S'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.A,
                                                  groupValue: _tachibana_rank,
                                                  onChanged: (value) {
                                                    _onTachibanarankSelected(
                                                        value);
                                                  }),
                                              Text('A'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.B,
                                                  groupValue: _tachibana_rank,
                                                  onChanged: (value) {
                                                    _onTachibanarankSelected(
                                                        value);
                                                  }),
                                              Text('B'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.C,
                                                  groupValue: _tachibana_rank,
                                                  onChanged: (value) {
                                                    _onTachibanarankSelected(
                                                        value);
                                                  }),
                                              Text('C'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.D,
                                                  groupValue: _tachibana_rank,
                                                  onChanged: (value) {
                                                    _onTachibanarankSelected(
                                                        value);
                                                  }),
                                              Text('D'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.E,
                                                  groupValue: _tachibana_rank,
                                                  onChanged: (value) {
                                                    _onTachibanarankSelected(
                                                        value);
                                                  }),
                                              Text('E'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                  DataCell(
                                    Container(
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.S,
                                                  groupValue:
                                                      _fukushima_east_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaEastrankSelected(
                                                        value);
                                                  }),
                                              Text('S'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.A,
                                                  groupValue:
                                                      _fukushima_east_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaEastrankSelected(
                                                        value);
                                                  }),
                                              Text('A'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.B,
                                                  groupValue:
                                                      _fukushima_east_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaEastrankSelected(
                                                        value);
                                                  }),
                                              Text('B'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.C,
                                                  groupValue:
                                                      _fukushima_east_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaEastrankSelected(
                                                        value);
                                                  }),
                                              Text('C'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.D,
                                                  groupValue:
                                                      _fukushima_east_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaEastrankSelected(
                                                        value);
                                                  }),
                                              Text('D'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.E,
                                                  groupValue:
                                                      _fukushima_east_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaEastrankSelected(
                                                        value);
                                                  }),
                                              Text('E'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                  DataCell(
                                    Container(
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.S,
                                                  groupValue:
                                                      _fukushima_south_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSouthrankSelected(
                                                        value);
                                                  }),
                                              Text('S'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.A,
                                                  groupValue:
                                                      _fukushima_south_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSouthrankSelected(
                                                        value);
                                                  }),
                                              Text('A'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.B,
                                                  groupValue:
                                                      _fukushima_south_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSouthrankSelected(
                                                        value);
                                                  }),
                                              Text('B'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.C,
                                                  groupValue:
                                                      _fukushima_south_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSouthrankSelected(
                                                        value);
                                                  }),
                                              Text('C'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.D,
                                                  groupValue:
                                                      _fukushima_south_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSouthrankSelected(
                                                        value);
                                                  }),
                                              Text('D'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.E,
                                                  groupValue:
                                                      _fukushima_south_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSouthrankSelected(
                                                        value);
                                                  }),
                                              Text('E'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                  DataCell(
                                    Container(
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.S,
                                                  groupValue:
                                                      _fukushima_seikei_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSeikeirankSelected(
                                                        value);
                                                  }),
                                              Text('S'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.A,
                                                  groupValue:
                                                      _fukushima_seikei_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSeikeirankSelected(
                                                        value);
                                                  }),
                                              Text('A'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.B,
                                                  groupValue:
                                                      _fukushima_seikei_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSeikeirankSelected(
                                                        value);
                                                  }),
                                              Text('B'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.C,
                                                  groupValue:
                                                      _fukushima_seikei_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSeikeirankSelected(
                                                        value);
                                                    print(value);
                                                  }),
                                              Text('C'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.D,
                                                  groupValue:
                                                      _fukushima_seikei_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSeikeirankSelected(
                                                        value);
                                                  }),
                                              Text('D'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: rank.E,
                                                  groupValue:
                                                      _fukushima_seikei_rank,
                                                  onChanged: (value) {
                                                    _onFukushimaSeikeirankSelected(
                                                        value);
                                                  }),
                                              Text('E'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '※横にスクロールできます',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, padding_top, 0, 0),
                        child: ElevatedButton(
                          child: Text(
                            '登録する',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () {
                            if (_selectedDate == '受験日：選択されていません。' &&
                                (!_formState.currentState!.validate())) {
                              setState(() {
                                isSelectedDateError = true;
                              });

                              return;
                            } else {
                              setState(() {
                                isSelectedDateError = false;
                              });
                            }

                            if (_selectedDate == '受験日：選択されていません。') {
                              setState(() {
                                isSelectedDateError = true;
                              });

                              return;
                            } else {
                              setState(() {
                                isSelectedDateError = false;
                              });
                            }

                            if (!_formState.currentState!.validate()) {
                              return;
                            }

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('入力したデータを登録しますか？'),
                                  content: Text('入力したデータが登録されます。'),
                                  actions: [
                                    TextButton(
                                      child: Text('いいえ'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('はい'),
                                      onPressed: () {
                                        _insert();
                                        DataClear();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 50))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String fukushima_rank() {
    String _rank = "";

    switch (_fukushima_rank) {
      case rank.S:
        _rank = "S";
        break;
      case rank.A:
        _rank = "A";
        break;
      case rank.B:
        _rank = "B";
        break;
      case rank.C:
        _rank = "C";
        break;
      case rank.D:
        _rank = "D";
        break;
      case rank.E:
        _rank = "E";
        break;
    }
    return _rank;
  }

  String tachibana_rank() {
    String _rank = "";

    switch (_tachibana_rank) {
      case rank.S:
        _rank = "S";
        break;
      case rank.A:
        _rank = "A";
        break;
      case rank.B:
        _rank = "B";
        break;
      case rank.C:
        _rank = "C";
        break;
      case rank.D:
        _rank = "D";
        break;
      case rank.E:
        _rank = "E";
        break;
    }
    return _rank;
  }

  String fukushima_east_rank() {
    String _rank = "";

    switch (_fukushima_east_rank) {
      case rank.S:
        _rank = "S";
        break;
      case rank.A:
        _rank = "A";
        break;
      case rank.B:
        _rank = "B";
        break;
      case rank.C:
        _rank = "C";
        break;
      case rank.D:
        _rank = "D";
        break;
      case rank.E:
        _rank = "E";
        break;
    }
    return _rank;
  }

  String fukushima_south_rank() {
    String _rank = "";

    switch (_fukushima_south_rank) {
      case rank.S:
        _rank = "S";
        break;
      case rank.A:
        _rank = "A";
        break;
      case rank.B:
        _rank = "B";
        break;
      case rank.C:
        _rank = "C";
        break;
      case rank.D:
        _rank = "D";
        break;
      case rank.E:
        _rank = "E";
        break;
    }
    return _rank;
  }

  String fukushima_seikei_rank() {
    String _rank = "";

    switch (_fukushima_seikei_rank) {
      case rank.S:
        _rank = "S";
        break;
      case rank.A:
        _rank = "A";
        break;
      case rank.B:
        _rank = "B";
        break;
      case rank.C:
        _rank = "C";
        break;
      case rank.D:
        _rank = "D";
        break;
      case rank.E:
        _rank = "E";
        break;
    }
    return _rank;
  }

  void _onFukushimarankSelected(value) {
    setState(() {
      _fukushima_rank = value;
    });
  }

  void _onTachibanarankSelected(value) {
    setState(() {
      _tachibana_rank = value;
    });
  }

  void _onFukushimaEastrankSelected(value) {
    setState(() {
      _fukushima_east_rank = value;
    });
  }

  void _onFukushimaSouthrankSelected(value) {
    setState(() {
      _fukushima_south_rank = value;
    });
  }

  void _onFukushimaSeikeirankSelected(value) {
    setState(() {
      _fukushima_seikei_rank = value;
    });
  }

  void _insert() async {
    int deviation_score = int.parse(_deviation_score.text);
    int Japanese_score = int.parse(_Japanese_score.text);
    int math_score = int.parse(_math_score.text);
    int English_score = int.parse(_English_score.text);
    int science_score = int.parse(_science_score.text);
    int social_studies_score = int.parse(_social_studies_score.text);
    int sum_score = Japanese_score +
        math_score +
        English_score +
        science_score +
        social_studies_score;

    await db_helper.insert(
      practice_exam_name,
      practice_exam_date,
      practice_exam_date_show,
      deviation_score,
      Japanese_score,
      math_score,
      English_score,
      science_score,
      social_studies_score,
      sum_score,
      fukushima_rank(),
      tachibana_rank(),
      fukushima_east_rank(),
      fukushima_south_rank(),
      fukushima_seikei_rank(),
    );
  }

  void DataClear() {
    _deviation_score.clear();
    _Japanese_score.clear();
    _math_score.clear();
    _English_score.clear();
    _science_score.clear();
    _social_studies_score.clear();

    setState(() {
      practice_exam_name = 'error';
      _selectedDate = "受験日：選択されていません。";
      _fukushima_rank = rank.S;
      _tachibana_rank = rank.S;
      _fukushima_east_rank = rank.S;
      _fukushima_south_rank = rank.S;
      _fukushima_seikei_rank = rank.S;
    });
  }
}
