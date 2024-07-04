import 'package:mno_navigator/data.dart';
import 'package:mno_navigator/epub.dart';
import 'package:sembast/sembast.dart';



class ViewsettingRepository {
  final Database _database;
  final _store = intMapStoreFactory.store("viewSetting_store");
  ViewsettingRepository()
      : _database = DatabaseConfig.getDatabaseInstance(
            DatabaseConfig.themeDatabaseName);
  Future<void> saveViewsetting(ViewerSettings themeConfig) async => await _store
      .record(0)
      .put(_database, themeConfig.toJson(themeConfig), merge: true);

  Future<ViewerSettings?> currentSettingConfig() async {
    final record = await _store.find(_database);
    return record.length == 1
        ? record.map((e) => ViewerSettings.fromJson(e.value)).toList().first
        : null;
  }
}
