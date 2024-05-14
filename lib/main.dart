import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mno_navigator/data.dart';
import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase();
  runApp(const MaterialApp(home: MyApp()));
}

Future<void> initDatabase() async {
  await DatabaseConfig.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return EpubScreen.fromPath(filePath: '/Users/duonghoang/Library/Mobile Documents/com~apple~CloudDocs/Flutter/vhmt_example/assets/images/toc_sub_toc.epub');
    return EpubScreen.fromPath(
        filePath:
            '/Users/vhmt/Desktop/iridium_reader_example/assets/images/toc_sub_toc.epub');
  }
}
