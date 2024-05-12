import 'package:mno_navigator/publication.dart';
import 'package:mno_navigator/src/common/data/data_sources/annotations_local_data_source.dart';
part 'annotations_repository_impl.dart';
abstract class AnnotationRepository {
  AnnotationRepository();

  Future<void> addAnnotationLocal(ReaderAnnotation annotation);
  Future<void> deleteAnnotationLocal(ReaderAnnotation annotation);
  Future<List<ReaderAnnotation>> annotationLocalList();
  Future<void> clearAnnotation();
}
