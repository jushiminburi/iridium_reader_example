import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mno_navigator/publication.dart';
import 'package:mno_navigator/src/common/data/repository/annotations_repository.dart';
final getIt = GetIt.instance;
class ReaderAnnotationBloc
    extends Bloc<ReaderAnnotationsEvent, ReaderAnnotationState> {
  ReaderAnnotationBloc() : super(ReaderAnnotationState([])) {
    AnnotationRepository annotationRepository = AnnotationRepository();
    on<InitAnnotationsEvent>((event, emit) async {
      final readerAnnotations =
          await annotationRepository.annotationLocalList();
      emit(ReaderAnnotationState(readerAnnotations));
    });
    on<AddAnnotationsEvent>((event, emit) async {
      await annotationRepository.addAnnotationLocal(event.readerAnnotation);
    });
    on<DeleteAnnotationsEvent>((event, emit) async => await annotationRepository
        .deleteAnnotationLocal(event.readerAnnotation));
    on<ClearAnnotationsEvent>(
        (event, emit) async => await annotationRepository.clearAnnotation());
  }
}

@immutable
abstract class ReaderAnnotationsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitAnnotationsEvent extends ReaderAnnotationsEvent {
  @override
  List<Object?> get props => [];
}

class AddAnnotationsEvent extends ReaderAnnotationsEvent {
  final ReaderAnnotation readerAnnotation;
  AddAnnotationsEvent(this.readerAnnotation);
  @override
  List<Object?> get props => [readerAnnotation];
}

class DeleteAnnotationsEvent extends ReaderAnnotationsEvent {
  final ReaderAnnotation readerAnnotation;
  DeleteAnnotationsEvent(this.readerAnnotation);
  @override
  List<Object?> get props => [readerAnnotation];
}

class ClearAnnotationsEvent extends ReaderAnnotationsEvent {
  @override
  List<Object?> get props => [];
}

@immutable
class ReaderAnnotationState extends Equatable {
  final List<ReaderAnnotation> readerAnnotations;
  const ReaderAnnotationState(this.readerAnnotations);

  @override
  List<Object> get props => [readerAnnotations];
}
