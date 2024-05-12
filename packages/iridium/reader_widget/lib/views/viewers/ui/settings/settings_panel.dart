import 'package:flutter/material.dart';
import 'package:iridium_reader_widget/views/viewers/ui/settings/general_settings_panel.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/publication.dart';

class SettingsPanel extends StatefulWidget {
  final ReaderContext readerContext;
  final ViewerSettingsBloc viewerSettingsBloc;
  final ReaderThemeBloc readerThemeBloc;

  const SettingsPanel({
    super.key,
    required this.readerContext,
    required this.viewerSettingsBloc,
    required this.readerThemeBloc,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) => GeneralSettingsPanel(
        readerContext: widget.readerContext,
        viewerSettingsBloc: widget.viewerSettingsBloc,
        readerThemeBloc: widget.readerThemeBloc,
      );
}
