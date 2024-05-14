// Copyright (c) 2021 Mantano. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited.
// Proprietary and confidential.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iridium_reader_widget/util/router.dart';
import 'package:iridium_reader_widget/views/viewers/ui/annotations_panel.dart';
import 'package:iridium_reader_widget/views/viewers/ui/content_panel.dart';
import 'package:iridium_reader_widget/views/viewers/ui/settings/menu_support.dart';
import 'package:iridium_reader_widget/views/viewers/ui/settings/settings_panel.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/publication.dart';
import 'package:sheet/route.dart';

class ReaderAppBar extends StatefulWidget {
  final ReaderContext readerContext;
  final PublicationController publicationController;

  const ReaderAppBar({
    super.key,
    required this.readerContext,
    required this.publicationController,
  });

  @override
  State<StatefulWidget> createState() => ReaderAppBarState();
}

class ReaderAppBarState extends State<ReaderAppBar> {
  static const double height = kToolbarHeight;
  final GlobalKey _settingsKey = GlobalKey();
  late StreamSubscription<bool> _streamSubscription;
  double opacity = 0.0;

  ReaderContext get readerContext => widget.readerContext;

  @override
  void initState() {
    super.initState();
    _streamSubscription = widget.readerContext.toolbarStream.listen((visible) {
      setState(() {
        opacity = (visible) ? 1.0 : 0.0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: IgnorePointer(
            ignoring: opacity < 1.0,
            child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                    height: height,
                    child: AppBar(backgroundColor: Colors.white, actions: [
                      IconButton(
                          onPressed: _onBookmarkPressed,
                          icon: const ImageIcon(AssetImage(
                              'packages/iridium_reader_widget/assets/images/icon_search.png'))),
                      IconButton(
                          onPressed: _onBookmarkPressed,
                          icon: const ImageIcon(AssetImage(
                              'packages/iridium_reader_widget/assets/images/icon_bookmark.png'))),
                      IconButton(
                          key: _settingsKey,
                          // onPressed: _onSettingsPressed,
                          onPressed: showBottomModalDialog,
                          icon: const ImageIcon(AssetImage(
                              'packages/iridium_reader_widget/assets/images/icon_settings.png'))),
                      _onMenuPressed(),
                    ])))),
      );

  void _onBookmarkPressed() {
    ReaderAnnotationBloc readerAnnotationBloc =
        BlocProvider.of<ReaderAnnotationBloc>(context);
    readerContext.toggleBookmark(readerAnnotationBloc);
  }

  Widget _onMenuPressed() => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 0:
                MyRouter.pushRoute(
                    context, ContentPanel(readerContext: readerContext));
                break;
              case 1:
                MyRouter.pushRoute(
                    context,
                    AnnotationsPanel(
                        readerContext: readerContext,
                        annotationType: AnnotationType.bookmark));
                break;
              case 2:
                MyRouter.pushRoute(
                    context,
                    AnnotationsPanel(
                        readerContext: readerContext,
                        annotationType: AnnotationType.highlight));
                break;
              default:
            }
          },
          offset: const Offset(40, 40),
          itemBuilder: (context) => MenuSupports.values
              .map((menu) =>
                  PopupMenuItem(value: menu.index, child: Text(menu.name)))
              .toList(),
          child: const ImageIcon(AssetImage(
              'packages/iridium_reader_widget/assets/images/icon_menu.png')),
        ),
      );

  void showBottomModalDialog() {
    ViewerSettingsBloc viewerSettingsBloc =
        BlocProvider.of<ViewerSettingsBloc>(context);
    ReaderThemeBloc readerThemeBloc = BlocProvider.of<ReaderThemeBloc>(context);
    Navigator.of(context).push(CupertinoSheetRoute<void>(
        initialStop: 0.3,
        stops: <double>[0, 0.3, 1],
        builder: (BuildContext context) => SafeArea(
            child: SettingsPanel(
                readerContext: readerContext,
                viewerSettingsBloc: viewerSettingsBloc,
                readerThemeBloc: readerThemeBloc))));
  }

  // void _onMenuPressed() {
  //   MyRouter.pushPage(
  //       context, ReaderNavigationScreen(readerContext: readerContext));
  // }
}
