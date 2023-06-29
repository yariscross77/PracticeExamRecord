import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'ScoreModel.dart';
import 'database_helper.dart';

String select_subject = 'sum_score';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPage();
}

class _GraphPage extends State<GraphPage> {
  List<Map<String, dynamic>> _data = [];
  List<String> _format_date = [];
  late List<ScoreModel> score_data = [];
  late TooltipBehavior _tooltip;

  final db_helper = DatabaseHelper.instance;

  void initState() {
    super.initState();
    _getDataFromDatabase();

    _tooltip = TooltipBehavior(enable: true);
  }

  Future<void> _getDataFromDatabase() async {
    final List<Map<String, dynamic>> data = await db_helper.select();

    setState(
      () {
        _data = data; // データをリストに設定

        DrawGraph(); // 合計点のグラフを最初に表示する
      },
    );
  }

  void DrawGraph() {
    String str_date = "";
    String format_date = "";
    DateTime dt_date;

    for (int i = 0; i < _data.length; i++) {
      _format_date.add('');
    }

    if (_data.length > 10) {
      for (int i = _data.length - 10; i < _data.length; i++) {
        str_date = _data[i]['practice_exam_date'];
        dt_date = DateFormat('y/M/d').parse(str_date);

        format_date = DateFormat('M/d').format(dt_date);
        _format_date.removeAt(i);
        _format_date.insert(i, format_date);

        score_data.add(
          ScoreModel(
            _format_date[i], // 受験日
            _data[i][select_subject], // 得点
          ),
        );
      }
    } else {
      for (int i = 0; i < _data.length; i++) {
        str_date = _data[i]['practice_exam_date'];
        dt_date = DateFormat('y/M/d').parse(str_date);

        format_date = DateFormat('M/d').format(dt_date);
        _format_date.removeAt(i);
        _format_date.insert(i, format_date);

        score_data.add(
          ScoreModel(
            _format_date[i], // 受験日
            _data[i][select_subject], // 得点
          ),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推移'),
      ),
      body: score_data.length >= 1
          ? Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: '表示中の項目',
                        border: OutlineInputBorder(),
                      ),
                      value: select_subject,
                      items: [
                        DropdownMenuItem(
                          child: Text('合計点'),
                          value: 'sum_score',
                        ),
                        DropdownMenuItem(
                          child: Text('偏差値'),
                          value: 'deviation_score',
                        ),
                        DropdownMenuItem(
                          child: Text('国語'),
                          value: 'Japanese_score',
                        ),
                        DropdownMenuItem(
                          child: Text('数学'),
                          value: 'math_score',
                        ),
                        DropdownMenuItem(
                          child: Text('英語'),
                          value: 'English_score',
                        ),
                        DropdownMenuItem(
                          child: Text('理科'),
                          value: 'science_score',
                        ),
                        DropdownMenuItem(
                          child: Text('社会'),
                          value: 'social_studies_score',
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          score_data.clear();
                          _format_date.clear();

                          select_subject = value!;
                          DrawGraph();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '※直近10回分のデータが表示されます',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SfCartesianChart(
                      title: ChartTitle(text: SetGraphTitle()),
                      legend: Legend(isVisible: false),
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxisData(),
                      tooltipBehavior: _tooltip,
                      series: <ChartSeries<ScoreModel, String>>[
                        ColumnSeries(
                          dataSource: score_data,
                          xValueMapper: (ScoreModel date, _) => date.date,
                          yValueMapper: (ScoreModel score, _) => score.score,
                          name: select_subject == 'deviation_score'
                              ? '偏差値'
                              : '得点',
                          width: 0.8,
                          color: SetGraphColor(),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  )
                ],
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

  String SetGraphTitle() {
    String graph_title = '';

    switch (select_subject) {
      case 'sum_score':
        graph_title = '合計点';
        break;
      case 'deviation_score':
        graph_title = '偏差値';
        break;
      case 'Japanese_score':
        graph_title = '国語';
        break;
      case 'math_score':
        graph_title = '数学';
        break;
      case 'English_score':
        graph_title = '英語';
        break;
      case 'science_score':
        graph_title = '理科';
        break;
      case 'social_studies_score':
        graph_title = '社会';
        break;
    }
    return graph_title;
  }

  Color SetGraphColor() {
    Color color = Colors.white;

    switch (select_subject) {
      case 'sum_score':
        color = Colors.cyan;
        break;
      case 'deviation_score':
        color = Colors.grey;
        break;
      case 'Japanese_score':
        color = Colors.pink;
        break;
      case 'math_score':
        color = Colors.blue;
        break;
      case 'English_score':
        color = Colors.purple;
        break;
      case 'science_score':
        color = Colors.green;
        break;
      case 'social_studies_score':
        color = Colors.orange;
        break;
    }
    return color;
  }

  NumericAxis NumericAxisData() {
    NumericAxis y_data = new NumericAxis();

    if (select_subject == 'sum_score') {
      y_data = NumericAxis(minimum: 0, maximum: 250, interval: 50);
    } else if (select_subject == 'deviation_score') {
      y_data = NumericAxis(minimum: 0, maximum: 100, interval: 20);
    } else {
      y_data = NumericAxis(minimum: 0, maximum: 50, interval: 10);
    }
    return y_data;
  }
}
