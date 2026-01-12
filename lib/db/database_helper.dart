import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/galeria_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('galeria.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE galeria(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        autor TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertItem(GaleriaItem item) async {
    final db = await instance.database;
    await db.insert('galeria', item.toMap());
  }

  Future<List<GaleriaItem>> getItemsByAutor(String autor) async {
    final db = await instance.database;
    final maps = await db.query(
      'galeria',
      where: 'autor = ?',
      whereArgs: [autor],
    );
    return maps.map((map) => GaleriaItem.fromMap(map)).toList();
  }

  Future<void> insertSampleData() async {
    final db = await instance.database;

    // Insertar 15 registros de ejemplo
    List<GaleriaItem> items = List.generate(15, (index) {
      return GaleriaItem(
        id: index + 1,
        titulo: 'Imagen ${index + 1}',
        imageUrl: 'https://picsum.photos/seed/${index + 1}/200/200',
        autor: index % 2 == 0 ? 'RA-7' : 'OTRO-1', // solo algunos coinciden
      );
    });

    for (var item in items) {
      await insertItem(item);
    }
  }
}
