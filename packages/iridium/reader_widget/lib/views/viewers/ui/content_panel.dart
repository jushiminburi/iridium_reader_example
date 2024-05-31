import 'package:flutter/material.dart';
import 'package:mno_navigator/publication.dart';
import 'package:mno_shared/publication.dart';

class ContentPanel extends StatefulWidget {
  final ReaderContext readerContext;

  const ContentPanel({super.key, required this.readerContext});

  @override
  State<StatefulWidget> createState() => ContentPanelState();
}

class ContentPanelState extends State<ContentPanel> {
  @override
  Widget build(BuildContext context) => Column(
        children: [_buildTitleContentPanel(), _buildListItemTableOfContents()]);
  Widget _buildListItemTableOfContents() {
    final tableOfContents = _flattenList(widget.readerContext.tableOfContents);
    return Expanded(
      child: ListView.separated(
        itemCount: tableOfContents.length,
        itemBuilder: (_, index) => Material(
          color: const Color.fromARGB(0, 255, 255, 255),
          child: ListTile(
            title: Text(tableOfContents[index].title ?? ""),
            onTap: () => _onTap(tableOfContents[index]),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Color(0xffE0E0E0),
        ),
      ),
    );
  }

  Widget _buildTitleContentPanel() => const Text('Mục Lục',
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black));

  List<Link> _flattenList(List<Link> tocReferences, {int level = 1}) {
    List<Link> flatList = [];
    for (var reference in tocReferences) {
      reference.level = level;
      flatList.add(reference);
      if (reference.children.isNotEmpty) {
        flatList.addAll(_flattenList(reference.children, level: level + 1));
      }
    }
    return flatList;
  }

  void _onTap(Link link) {
    Navigator.pop(context);
    widget.readerContext
        .execute(GoToHrefCommand(link.hrefPart, link.elementId));
  }
}
