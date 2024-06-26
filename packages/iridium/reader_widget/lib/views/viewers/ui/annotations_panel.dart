import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/publication.dart';
import 'package:mno_shared/publication.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnotationsPanel extends StatefulWidget {
  final ReaderContext readerContext;
  final AnnotationType annotationType;

  const AnnotationsPanel({
    super.key,
    required this.readerContext,
    required this.annotationType,
  });

  @override
  State<StatefulWidget> createState() => AnnotationsPanelState();
}

class AnnotationsPanelState extends State<AnnotationsPanel> {
  final ReaderAnnotationBloc annotationBloc = ReaderAnnotationBloc();
  AnnotationType get _annotationType => widget.annotationType;
  @override
  void initState() {
    super.initState();
    annotationBloc.add(InitAnnotationsEvent());
  }

  Future<List<ReaderAnnotation>> get _readerAnnotationsStream =>
      widget.readerContext.readerAnnotationRepository
          .allWhere(predicate: AnnotationTypePredicate(widget.annotationType));

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xffF8F8F8),
        child: BlocBuilder<ReaderAnnotationBloc, ReaderAnnotationState>(
            bloc: annotationBloc,
            builder: (context, ReaderAnnotationState state) {
              List<ReaderAnnotation> readerAnnotations = <ReaderAnnotation>[];
              if (_annotationType == AnnotationType.highlight) {
                readerAnnotations = state.readerAnnotations
                    .where((e) => e.annotationType == AnnotationType.highlight)
                    .toList();
              }
              if (_annotationType == AnnotationType.bookmark) {
                readerAnnotations = state.readerAnnotations
                    .where((e) => e.annotationType == AnnotationType.bookmark)
                    .toList();
              }
              return Column(children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffE0E0E0)))),
                  child: Text(
                      _annotationType == AnnotationType.bookmark
                          ? 'Dấu trang'
                          : 'Chú thích',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none)),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: readerAnnotations.length,
                    itemBuilder: (context, index) => _annotationType ==
                            AnnotationType.bookmark
                        ? itemBuilderBookmark(context, readerAnnotations[index])
                        : itemBuilderHighlight(
                            context, readerAnnotations[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Color(0xffE0E0E0)),
                  ),
                ),
              ]);
            }),
      );

  Widget itemBuilderBookmark(
      BuildContext context, ReaderAnnotation readerAnnotation) {
    Locator? locator = Locator.fromJsonString(readerAnnotation.location);
    String? title =
        (locator?.title?.isNotEmpty == true) ? locator?.title : null;
    String? text = locator?.text.highlight;
    String? progression =
        ((locator?.locations.progression ?? 0) * 100).toStringAsFixed(2);
    return Material(
        color: const Color(0xffF8F8F8),
        child: ListTile(
            title: Text(
              title ?? text ?? "",
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("$progression%", textAlign: TextAlign.right),
            onTap: () => _onTap(readerAnnotation)));
  }

  Widget itemBuilderHighlight(
      BuildContext context, ReaderAnnotation readerAnnotation) {
    Locator? locator = Locator.fromJsonString(readerAnnotation.location);
    String? title =
        (locator?.title?.isNotEmpty == true) ? locator?.title : null;
    String? text = locator?.text.highlight;
    return Material(
      color: const Color(0xffF8F8F8),
      child: ListTile(
        leading: Container(
            width: 4,
            color: readerAnnotation.tint != null
                ? Color(readerAnnotation.tint ?? 0)
                : null),
        title: Text(title ?? text ?? ""),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: readerAnnotation.annotation != null
              ? Text("Ghi chú: ${readerAnnotation.annotation ?? ""}")
              : null,
        ),
        onTap: () => _onTap(readerAnnotation),
      ),
    );
  }

  void _onTap(ReaderAnnotation readerAnnotation) {
    Navigator.pop(context);
    widget.readerContext
        .execute(GoToLocationCommand(readerAnnotation.location));
  }
}
