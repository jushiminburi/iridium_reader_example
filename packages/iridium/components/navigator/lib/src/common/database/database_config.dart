import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

mixin DatabaseConfig {
  static Database getDatabaseInstance(String nameDB) {
    final database = _instances[nameDB];
    if (database == null) {
      throw Exception('the name provided' ' has no instance available for use');
    }
    return database;
  }

  static Future<void> init(StoreRef<dynamic, dynamic> store) async =>
      _initDatabase(databaseNames, store);

  static final Map<String, Database> _instances = {};

  static Future<void> _initDatabase(
      List<String> nameDB, StoreRef<dynamic, dynamic> store) async {
    for (final name in nameDB) {
      final dbPath = await _generateDBPath(name);
      final dbFactory = databaseFactoryIo;
      final db = await dbFactory.openDatabase(dbPath);
      final databaseReference = _instances[name];
      if (databaseReference != null) await databaseReference.close();
      _instances[name] = db;
    }
  }

  static List<String> databaseNames = [
    bookmarkDatabaseName,
    hightlightDatabaseName
  ];

  static Future<String> _generateDBPath(String nameDb) async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, nameDb);
    return dbPath;
  }

  static String get bookmarkDatabaseName => 'bookmark.db';
  static String get hightlightDatabaseName => 'hightlight.db';
}
