import 'package:mno_navigator/src/common/database/database_config.dart';
import 'package:mno_navigator/src/epub/settings/reader_theme_config.dart';
import 'package:sembast/sembast.dart';

class ReaderThemeRepository {
  final Database _database;
  final _store = intMapStoreFactory.store("theme_store");
  ReaderThemeRepository()
      : _database = DatabaseConfig.getDatabaseInstance(
            DatabaseConfig.themeDatabaseName);
  Future<void> saveReaderTheme(ReaderThemeConfig themeConfig) async =>
      await _store.record(0).put(_database, themeConfig.toJson(), merge: true);

  Future<ReaderThemeConfig?> currenthemeConfig() async {
    final record = await _store.find(_database);
    return record.length == 1
        ? record.map((e) => ReaderThemeConfig.fromJson(e.value)).toList().first
        : null;
  }
}
