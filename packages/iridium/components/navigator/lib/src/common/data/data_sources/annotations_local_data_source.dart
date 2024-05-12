import 'package:mno_navigator/publication.dart';
import 'package:sembast/sembast.dart';
part 'annotations_local_data_source_impl.dart';

abstract class AnnotationDataSource {
  AnnotationDataSource();

  Future<void> addAnnotationLocal(ReaderAnnotation annotation);
  Future<void> deleteAnnotationLocal(ReaderAnnotation annotation);
  Future<List<ReaderAnnotation>> annotationLocalList();
  Future<void> clearAnnotation();
}
