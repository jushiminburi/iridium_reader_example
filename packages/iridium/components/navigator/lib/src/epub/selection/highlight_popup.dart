import 'package:flutter/material.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/publication.dart';
import 'package:mno_navigator/src/epub/selection/selection_popup.dart';

class HighlightPopup extends SelectionPopup {
  static const List<Color> highlightTints = [
    Color(4294569853),
    Color(4289591163),
    Color(4286367479),
    Color(4294409340),
    Color(4290157055),
  ];

  HighlightPopup(super.selectionListener);

  @override
  double get optionsWidth => 300.0;

  @override
  double get optionsHeight => 48.0;

  void showHighlightPopup(
    BuildContext context,
    Selection selection,
    HighlightStyle style,
    Color tint,
    String? highlightId,
  ) {
    displayPopup(context, selection,
        child: Material(
          type: MaterialType.canvas,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          elevation: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...highlightTints
                  .map((color) => buildColorOption(color, () {
                        if (highlightId != null) {
                          selectionListener.updateHighlight(
                              selection, style, color, highlightId);
                        } else {
                          selectionListener.createHighlight(
                              selection, style, color);
                        }
                        close();
                      })).toList(),
              buildNoteOption(context, selection, highlightId),
              if (highlightId != null) buildDeleteOption(context, highlightId),
            ],
          ),
        ));
  }

  Widget buildColorOption(Color color, VoidCallback action) => IconButton(
        onPressed: action,
        icon: Container(
            width: 30,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      );

  Widget buildNoteOption(
          BuildContext context, Selection selection, String? highlightId) =>
      IconButton(
        onPressed: () {
          selectionListener.showAnnotationPopup(selection,
              highlightId: highlightId);
          close();
        },
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
        ),
      );

  Widget buildDeleteOption(BuildContext context, String highlightId) =>
      IconButton(
        onPressed: () {
          selectionListener.deleteHighlight(highlightId);
          close();
        },
        icon: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
      );
}
