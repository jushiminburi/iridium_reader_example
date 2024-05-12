part of 'annotations_local_data_source.dart';

class AnnotationDataSourceImplement implements AnnotationDataSource {
  final Database _database;
  final StoreRef<String, ReaderAnnotation> _store;

  AnnotationDataSourceImplement(
    Database database,
    StoreRef<String, ReaderAnnotation> store,
  )   : _database = database,
        _store = store;
  @override
  Future<void> addAnnotationLocal(ReaderAnnotation annotation) async =>
      await _store
          .record(annotation.id)
          .put(_database, annotation, merge: true);

  @override
  Future<List<ReaderAnnotation>> annotationLocalList() async => await _store
      .query()
      .getSnapshots(_database)
      .then((value) => value.map((e) => e.value).toList());

  @override
  Future<void> clearAnnotation() async =>
    await _store.delete(_database);
  

  @override
  Future<void> deleteAnnotationLocal(ReaderAnnotation annotation) async =>
    await _store.record(annotation.id).delete(_database);
  
}
