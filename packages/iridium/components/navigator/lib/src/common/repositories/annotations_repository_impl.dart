part of 'annotations_repository.dart';

class AnnotationsRepositoryImplement implements AnnotationRepository {
  final AnnotationDataSource annotationDataSource;
  AnnotationsRepositoryImplement(this.annotationDataSource);

  @override
  Future<void> addAnnotationLocal(ReaderAnnotation annotation) async =>
      await annotationDataSource.addAnnotationLocal(annotation);

  @override
  Future<List<ReaderAnnotation>> annotationLocalList() async =>
      await annotationDataSource.annotationLocalList();

  @override
  Future<void> clearAnnotation() async =>
      await annotationDataSource.clearAnnotation();

  @override
  Future<void> deleteAnnotationLocal(ReaderAnnotation annotation) async =>
      await annotationDataSource.deleteAnnotationLocal(annotation);
}
