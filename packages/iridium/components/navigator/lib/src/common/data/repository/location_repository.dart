import 'package:mno_navigator/data.dart';
import 'package:mno_navigator/src/publication/model/book_management.dart';
import 'package:sembast/sembast.dart';

class BookManagementRepository {
  final Database _database;
  final _store = intMapStoreFactory.store("book_management_store");
  BookManagementRepository()
      : _database = DatabaseConfig.getDatabaseInstance(
            DatabaseConfig.bookManagementDatabaseName);

  Future<void> insertBookManagement(BookManagement bookManagement) async =>
      await _store
          .record(bookManagement.id)
          .put(_database, bookManagement.toJson());
  Future<void> updateBookManagement(BookManagement bookManagement) async =>
      await _store
          .record(bookManagement.id)
          .update(_database, bookManagement.toJson());
  Future<List<BookManagement>> readDataBookManagement() async {
    final records = await _store.find(_database);
    return records.map((e) => BookManagement.fromJson(e.value)).toList();
  }
  Future<void> clearbookManagements() async => await _store.delete(_database);
}
