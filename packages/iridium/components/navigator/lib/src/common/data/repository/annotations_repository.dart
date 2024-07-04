import 'package:dartx/dartx.dart';
import 'package:mno_navigator/data.dart';
import 'package:mno_navigator/publication.dart';
import 'package:sembast/sembast.dart';

class AnnotationRepository {
  final Database _database;
  final _store = intMapStoreFactory.store("annotation_store");
  AnnotationRepository()
      : _database = DatabaseConfig.getDatabaseInstance(
            DatabaseConfig.annotationDatabaseName);
  Future<void> addAnnotationLocal(ReaderAnnotation annotation) async =>
      await _store
          .record(annotation.id.toInt())
          .put(_database, annotation.toJson(), merge: true);

  Future<List<ReaderAnnotation>> annotationLocalList() async {
    final finder = Finder(sortOrders: [SortOrder('name')]);
    final records = await _store.find(_database, finder: finder);
    return records.map((e) => ReaderAnnotation.fromJson(e.value)).toList();
  }

  Future<void> clearAnnotation() async => await _store.delete(_database);
  Future<void> deleteAnnotationLocal(ReaderAnnotation annotation) async =>
      await _store.record(annotation.id.toInt()).delete(_database);
}




