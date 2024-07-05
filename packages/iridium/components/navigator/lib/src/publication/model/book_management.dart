import 'package:mno_commons/utils/jsonable.dart';
import 'package:mno_navigator/publication.dart';
import 'package:mno_navigator/src/epub/settings/reader_theme_config.dart';

class BookManagement with JSONable {
  final String bookId;
  final int id;
  final String location;
  final ReaderAnnotation? readerAnnotion;
  final ReaderThemeConfig? themeConfig;

  BookManagement(this.id, this.bookId, this.location,
      {this.readerAnnotion, this.themeConfig});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "bookId": bookId,
        "location": location,
        "ReaderAnnotation": readerAnnotion?.toJson(),
        "ReaderThemeConfig": themeConfig?.toJson()
      };

  static BookManagement fromJson(Map<String, dynamic> json) =>
      BookManagement(json["id"], json["bookId"], json["location"],
          readerAnnotion: json["ReaderAnnotation"] != null
              ? ReaderAnnotation.fromJson(json["ReaderAnnotation"])
              : null,
          themeConfig: json['ReaderThemeConfig'] != null
              ? ReaderThemeConfig.fromJson(json["ReaderAnnotation"])
              : null);
  @override
  String toString() => '$runtimeType{id: $id, '
      'bookId: $bookId, '
      'location: $location, '
      'ReaderAnnotation: $readerAnnotion, '
      'ReaderAnnotation: $themeConfig}';
}
