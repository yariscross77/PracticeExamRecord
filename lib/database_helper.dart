import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "PracticeExamTable.db"; // DB名
  static final _databaseVersion = 1; // スキーマのバージョン指定

  static final table = 'PracticeExamTable'; // テーブル名

  static final columnId = 'ID';
  static final columnPracticeExamName = 'practice_exam_name';
  static final columnPracticeExamDate = 'practice_exam_date';
  static final columnPracticeExamDateShow = 'practice_exam_date_show';
  static final columnDeviationScore = 'deviation_score';
  static final columnJapaneseScore = 'Japanese_score';
  static final columnMathScore = 'math_score';
  static final columnEnglishScore = 'English_score';
  static final columnScienceScore = 'science_score';
  static final columnSocialStudiesScore = 'social_studies_score';
  static final columnSumScore = 'sum_score';

  // DatabaseHelper クラスを定義
  DatabaseHelper._privateConstructor();
  // DatabaseHelper._privateConstructor() コンストラクタを使用して生成されたインスタンスを返すように定義
  // DatabaseHelper クラスのインスタンスは、常に同じものであるという保証
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Databaseクラス型のstatic変数_databaseを宣言
  // クラスはインスタンス化しない
  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // アプリケーションのドキュメントディレクトリのパスを取得
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得パスを基に、データベースのパスを生成
    String path = join(documentsDirectory.path, _databaseName);

    //await deleteDatabase(path); // データベースの削除

    // データベース接続
    return await openDatabase(path,
        version: _databaseVersion,
        // テーブル作成メソッドの呼び出し
        onCreate: _onCreate);
  }

  // テーブル作成
  // 引数:dbの名前
  // 引数:スキーマーのversion
  // スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnPracticeExamName TEXT NOT NULL,
            $columnPracticeExamDate TEXT NOT NULL,
            $columnPracticeExamDateShow TEXT NOT NULL,
            $columnDeviationScore INTEGER NOT NULL,
            $columnJapaneseScore INTEGER NOT NULL,
            $columnMathScore INTEGER NOT NULL,
            $columnEnglishScore INTEGER NOT NULL,
            $columnScienceScore INTEGER NOT NULL,
            $columnSocialStudiesScore INTEGER NOT NULL,
            $columnSumScore INTEGER NOT NULL
          )
          ''');
  }

  // 登録処理
  Future<int> insert(
      String practice_exam_name,
      String practice_exam_date,
      String practice_exam_date_show,
      int deviation_score,
      int Japanese_score,
      int math_score,
      int English_score,
      int science_score,
      int social_studies_score,
      int sum_score) async {
    Database? db = await instance.database;
    return await db!.insert(table, {
      columnPracticeExamName: practice_exam_name,
      columnPracticeExamDate: practice_exam_date,
      columnPracticeExamDateShow: practice_exam_date_show,
      columnDeviationScore: deviation_score,
      columnJapaneseScore: Japanese_score,
      columnMathScore: math_score,
      columnEnglishScore: English_score,
      columnScienceScore: science_score,
      columnSocialStudiesScore: social_studies_score,
      columnSumScore: sum_score
    });
  }

  // 参照処理(全体)
  Future select() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  // 参照処理(詳細)
  Future select_detail(int ID) async {
    Database? db = await instance.database;
    return await db!.query(table, where: 'ID = ?', whereArgs: [ID]);
  }

  // レコード数を確認
  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //　更新処理
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //　削除処理
  Future delete(int ID) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: 'ID = ?', whereArgs: [ID]);
  }
}
