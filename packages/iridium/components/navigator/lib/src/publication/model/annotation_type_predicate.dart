
import 'package:mno_commons/utils/predicate.dart';
import 'package:mno_navigator/publication.dart';

class AnnotationTypePredicate extends Predicate<ReaderAnnotation> {
  final AnnotationType annotationType;

  AnnotationTypePredicate(this.annotationType) {
    addEqualsCondition("annotationType", annotationType.id);
  }

  @override
  bool test(ReaderAnnotation element) =>
      element.annotationType == annotationType;
}
