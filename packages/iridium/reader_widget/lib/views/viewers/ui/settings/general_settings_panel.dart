import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iridium_reader_widget/views/viewers/model/fonts.dart';
import 'package:iridium_reader_widget/views/viewers/ui/settings/color_theme.dart';
import 'package:iridium_reader_widget/views/viewers/ui/settings/font_size_button.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/publication.dart';
import 'package:timelines/timelines.dart';

class GeneralSettingsPanel extends StatefulWidget {
  final ReaderContext readerContext;
  final ViewerSettingsBloc viewerSettingsBloc;
  final ReaderThemeBloc readerThemeBloc;

  const GeneralSettingsPanel({
    super.key,
    required this.readerContext,
    required this.viewerSettingsBloc,
    required this.readerThemeBloc,
  });

  @override
  State<GeneralSettingsPanel> createState() => _GeneralSettingsPanelState();
}

class _GeneralSettingsPanelState extends State<GeneralSettingsPanel> {
  late ColorTheme currentColorTheme;

  int? _selectedSegment = 0;

  ReaderContext get readerContext => widget.readerContext;

  ViewerSettingsBloc get viewerSettingsBloc => widget.viewerSettingsBloc;

  ReaderThemeBloc get readerThemeBloc => widget.readerThemeBloc;

  @override
  void initState() {
    super.initState();
    currentColorTheme = ColorTheme.defaultColorTheme;
  }

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            _buildSelectFontRow(),
            _buildFontSizeRow(),
            _buildColorThemeRow(),
            _buildScrollRow()
          ],
        ),
      );

  Widget _buildFontSizeRow() => Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffE0E0E0)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FontSizeButton(
              viewerSettingsBloc: viewerSettingsBloc,
              increase: false,
            ),
            Expanded(
              child: SizedBox(
                height: 49,
                width: MediaQuery.of(context).size.width,
                child: Timeline.tileBuilder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    builder: TimelineTileBuilder.connected(
                        connectionDirection: ConnectionDirection.before,
                        itemExtentBuilder: (_, __) =>
                            ((MediaQuery.of(context).size.width) - 160) / 4,
                        oppositeContentsBuilder: (_, __) => Container(),
                        contentsBuilder: (context, index) => Container(),
                        indicatorBuilder: (_, index) {
                          if (index <= 1) {
                            return const DotIndicator(
                              size: 15,
                              color: Colors.green,
                            );
                          } else {
                            return const OutlinedDotIndicator(
                              borderWidth: 5,
                              size: 10,
                              color: Colors.green,
                            );
                          }
                        },
                        connectorBuilder: (_, index, type) {
                          if (index > 0) {
                            return const SolidLineConnector(
                                color: Colors.green);
                          } else {
                            return null;
                          }
                        },
                        itemCount: 5)),
              ),
            ),
            FontSizeButton(
                viewerSettingsBloc: viewerSettingsBloc, increase: true),
          ],
        ),
      );

  Widget _buildScrollRow() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        height: 50,
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffE0E0E0)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Cuộn trang'),
            CupertinoSlidingSegmentedControl<int>(
                children: const <int, Widget>{0: Text('Off'), 1: Text('On')},
                groupValue: _selectedSegment,
                onValueChanged: (value) {
                  setState(() {
                    _selectedSegment = value;
                  });
                }),
          ],
        ),
      );

  Widget _buildSelectFontRow() => BlocBuilder(
      bloc: readerThemeBloc,
      builder: (BuildContext context, ReaderThemeState state) =>
          PopupMenuButton(
              onSelected: (value) => readerThemeBloc.add(ReaderThemeEvent(
                  readerThemeBloc.currentTheme.copy(fontFamily: value))),
              itemBuilder: (_) => Fonts.googleFonts
                  .map((fontFamily) =>
                      PopupMenuItem(value: fontFamily, child: Text(fontFamily)))
                  .toList(),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffE0E0E0)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text(readerThemeBloc.currentTheme.fontFamily ?? "Font chữ"),
                    const Image(
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                        image: AssetImage(
                            'packages/iridium_reader_widget/assets/images/chevron-right.png'))
                  ],
                ),
              )));

  Widget _buildColorThemeRow() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffE0E0E0)))),
        height: 52,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ColorTheme.values
                .map((theme) => IconThemeSettings(theme, onTap: () {
                      readerThemeBloc.add(
                          ReaderThemeEvent(readerThemeBloc.currentTheme.copy()
                            ..textColor = theme.textColor
                            ..backgroundColor = theme.backgroundColor));
                      setState(() {
                        currentColorTheme = theme;
                      });
                    },
                        colorSelected: Colors.blue,
                        isSelected: currentColorTheme == theme))
                .toList()),
      );
}
