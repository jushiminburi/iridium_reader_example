// // Định nghĩa lớp _StringSearchService
// import 'package:mno_shared/src/publication/link.dart';
// import 'package:mno_shared/src/publication/services/search_service.dart';

// class StringSearchService extends SearchService {
//   static Function(PublicationServiceContext) makeFactory({
//     int snippetLength = 200,
//     StringSearchAlgorithm searchAlgorithm = const BasicStringSearchAlgorithm(),
//     ResourceContentExtractorFactory extractorFactory = const DefaultResourceContentExtractorFactory(),
//   }) => (PublicationServiceContext context) => StringSearchService(
//         publication: context.publication,
//         language: context.manifest.metadata.language,
//         snippetLength: snippetLength,
//         searchAlgorithm: searchAlgorithm,
//         extractorFactory: extractorFactory,
//       );

//   @override
//   final SearchOptions options;
//   final Publication publication;
//   final Language? language;
//   final int snippetLength;
//   final StringSearchAlgorithm searchAlgorithm;
//   final ResourceContentExtractorFactory extractorFactory;

//   StringSearchService({
//     required this.publication,
//     this.language,
//     required this.snippetLength,
//     required this.searchAlgorithm,
//     required this.extractorFactory,
//   }) : options = searchAlgorithm.options.copyWith(language: language ?? Language.current);

//   @override
//   Future<Cancellable> search({
//     required String query,
//     SearchOptions? options,
//     required void Function(SearchResult<SearchIterator>) completion,
//   }) {
//     final cancellable = CancellableObject();

//     Future.delayed(Duration.zero, () {
//       if (cancellable.isCancelled) return;

//       final publication = this.publication;
//       if (publication == null) {
//         completion(SearchResult.failure(SearchError.cancelled));
//         return;
//       }

//       completion(SearchResult.success(_Iterator(
//         publication: publication,
//         language: language,
//         snippetLength: snippetLength,
//         searchAlgorithm: searchAlgorithm,
//         extractorFactory: extractorFactory,
//         query: query,
//         options: options,
//       )));
//     });

//     return Future.value(cancellable);
//   }
// }

// class _Iterator extends SearchIterator {
//   @override
//   int? resultCount = 0;

//   final Publication publication;
//   final Language? language;
//   final int snippetLength;
//   final StringSearchAlgorithm searchAlgorithm;
//   final ResourceContentExtractorFactory extractorFactory;
//   final String query;
//   final SearchOptions options;

//   _Iterator({
//     required this.publication,
//     this.language,
//     required this.snippetLength,
//     required this.searchAlgorithm,
//     required this.extractorFactory,
//     required this.query,
//     SearchOptions? options,
//   }) : options = options ?? SearchOptions();

//   int index = -1;

//   @override
//   Future<Cancellable> next(void Function(SearchResult<LocatorCollection?>) completion) {
//     final cancellable = CancellableObject();
//     Future.delayed(Duration.zero, () {
//       if (cancellable.isCancelled) return;

//       _findNext(cancellable, completion);
//     });
//     return Future.value(cancellable);
//   }

//   void _findNext(CancellableObject cancellable, void Function(SearchResult<LocatorCollection?>) completion) {
//     if (index >= publication.readingOrder.length - 1) {
//       completion(SearchResult.success(null));
//       return;
//     }
//     index++;
//     final link = publication.readingOrder[index];
//     final resource = publication.get(link);

//     extractorFactory.makeExtractor(resource).then((extractor) {
//       if (extractor == null) {
//         _findNext(cancellable, completion);
//         return;
//       }

//       extractor.extractText(resource).then((text) {
//         if (cancellable.isCancelled) return;

//         final locators = _findLocators(link, index, text, cancellable);
//         if (locators.isEmpty) {
//           _findNext(cancellable, completion);
//         } else {
//           resultCount = (resultCount ?? 0) + locators.length;
//           completion(SearchResult.success(LocatorCollection(locators: locators)));
//         }
//       }).catchError((error) {
//         completion(SearchResult.failure(SearchError.wrap(error)));
//       });
//     }).catchError((error) {
//       completion(SearchResult.failure(SearchError.wrap(error)));
//     });
//   }

//   List<Locator> _findLocators(Link link, int resourceIndex, String text, CancellableObject cancellable) {
//     if (text.isEmpty) return [];

//     var resourceLocator = publication.locate(link);
//     final title = publication.tableOfContents.titleMatchingHREF(link.href);
//     resourceLocator = resourceLocator.copyWith(title: title ?? link.title);

//     final locators = <Locator>[];

//     final currentLanguage = options.language ?? language;
//     for (final range in searchAlgorithm.findRanges(query, options, text, currentLanguage, cancellable)) {
//       if (cancellable.isCancelled) return locators;

//       locators.add(_makeLocator(resourceIndex, resourceLocator, text, range));
//     }

//     return locators;
//   }

//   Locator _makeLocator(int resourceIndex, Locator resourceLocator, String text, Range range) {
//     final progression = (range.start / text.length).clamp(0.0, 1.0);

//     double? totalProgression;
//     final positions = publication.positionsByReadingOrder;
//     if (positions.length > resourceIndex) {
//       final resourceStartTotalProg = positions[resourceIndex].first.locations.totalProgression ?? 0.0;
//       final resourceEndTotalProg = (resourceIndex + 1 < positions.length)
//           ? positions[resourceIndex + 1].first.locations.totalProgression ?? 1.0
//           : 1.0;
//       totalProgression = resourceStartTotalProg + progression * (resourceEndTotalProg - resourceStartTotalProg);
//     }

//     return resourceLocator.copyWith(
//       locations: Locations(
//         progression: progression,
//         totalProgression: totalProgression,
//       ),
//       text: TextSnippet(
//         after: _extractSnippet(text, range.start, snippetLength, false),
//         before: _extractSnippet(text, range.end, snippetLength, true),
//         highlight: text.substring(range.start, range.end),
//       ),
//     );
//   }

//   String _extractSnippet(String text, int index, int length, bool reverse) {
//     final snippet = StringBuffer();
//     int count = length;

//     final iterator = reverse ? text.substring(0, index).runes.iterator : text.substring(index).runes.iterator;
//     while (iterator.moveNext() && count >= 0) {
//       final char = String.fromCharCode(iterator.current);
//       if (char.trim().isEmpty) break;

//       snippet.write(reverse ? char : char);
//       count--;
//     }

//     return snippet.toString();
//   }
// }

// // Giao diện cho thuật toán tìm kiếm chuỗi
// abstract class StringSearchAlgorithm {
//   SearchOptions get options;

//   List<Range> findRanges(
//     String query,
//     SearchOptions options,
//     String text,
//     Language? language,
//     CancellableObject cancellable,
//   );
// }

// // Thuật toán tìm kiếm chuỗi cơ bản sử dụng API tìm kiếm chuỗi trong Dart
// class BasicStringSearchAlgorithm implements StringSearchAlgorithm {
//   @override
//   final SearchOptions options;

//   const BasicStringSearchAlgorithm()
//       : options = SearchOptions(
//           caseSensitive: false,
//           diacriticSensitive: false,
//           exact: false,
//           regularExpression: false,
//         );

//   @override
//   List<Range> findRanges(
//     String query,
//     SearchOptions options,
//     String text,
//     Language? language,
//     CancellableObject cancellable,
//   ) {
//     final compareOptions = CompareOptions(
//       caseSensitive: options.caseSensitive ?? false,
//       diacriticSensitive: options.diacriticSensitive ?? false,
//       exact: options.exact ?? false,
//       regularExpression: options.regularExpression ?? false,
//     );

//     final ranges = <Range>[];
//     int index = 0;
//     while (!cancellable.isCancelled && index < text.length) {
//       final range = _findRange(query, text, index, compareOptions);
//       if (range != null) {
//         ranges.add(range);
//         index = range.start + 1;
//       } else {
//         break;
//       }
//     }

//     return ranges;
//   }

//   Range? _findRange(String query, String text, int startIndex, CompareOptions options) {
//     if (options.regularExpression) {
//       final regExp = RegExp(query);
//       final match = regExp.firstMatch(text.substring(startIndex));
//       if (match != null) {
//         return Range(start: match.start, end: match.end);
//       }
//     } else {
//       final index = options.caseSensitive
//           ? text.indexOf(query, startIndex)
//           : text.toLowerCase().indexOf(query.toLowerCase(), startIndex);
//       if (index != -1) {
//         return Range(start: index, end: index + query.length);
//       }
//     }
//     return null;
//   }
// }

// // Các lớp và hàm phụ trợ
// class Publication {
//   final List<Link> readingOrder;
//   final List<Locator> positionsByReadingOrder;

//   Publication({required this.readingOrder, required this.positionsByReadingOrder});

//   Locator locate(Link link) {
//     // ... implement this method based on your logic
//   }

//   Resource get(Link link) {
//     // ... implement this method based on your logic
//   }

//   List<Link> get tableOfContents => [];
// }

// class PublicationServiceContext {
//   final Publication publication;
//   final Manifest manifest;

//   PublicationServiceContext({required this.publication, required this.manifest});
// }

// class Manifest {
//   final Metadata metadata;

//   Manifest({required this.metadata});
// }

// class Metadata {
//   final Language language;

//   Metadata({required this.language});
// }

// class Language {
//   final Locale locale;

//   Language({required this.locale});

//   static Language current = Language(locale: Locale('en'));

//   // add more implementation if needed
// }

// class Locale {
//   final String languageCode;

//   Locale(this.languageCode);
// }

// class Range {
//   final int start;
//   final int end;

//   Range({required this.start, required this.end});
// }

// class CancellableObject implements Cancellable {
//   bool isCancelled = false;

//   void cancel() {
//     isCancelled = true;
//   }
// }

// class Cancellable {
//   bool get isCancelled => false;

//   void cancel() {}
// }

// class ResourceContentExtractorFactory {
//   const ResourceContentExtractorFactory();

//   Future<ResourceContentExtractor?> makeExtractor(Resource resource) {
//     // ... implement this method based on your logic
//   }
// }

// class DefaultResourceContentExtractorFactory extends ResourceContentExtractorFactory {
//   const DefaultResourceContentExtractorFactory();
// }

// abstract class ResourceContentExtractor {
//   Future<String> extractText(Resource resource);
// }

// class Resource {
//   // ... implement this class based on your logic
// }

// class Locator {
//   final Locations locations;
//   final TextSnippet text;

//   Locator({required this.locations, required this.text});

//   Locator copyWith({Locations? locations, TextSnippet? text}) => Locator(
//       locations: locations ?? this.locations,
//       text: text ?? this.text,
//     );
// }

// class Locations {
//   final double? progression;
//   final double? totalProgression;

//   Locations({this.progression, this.totalProgression});
// }

// class TextSnippet {
//   final String before;
//   final String highlight;
//   final String after;

//   TextSnippet({required this.before, required this.highlight, required this.after});
// }

// class LocatorCollection {
//   final List<Locator> locators;

//   LocatorCollection({required this.locators});
// }

// class MediatorCancellable implements Cancellable {
//   final _cancellables = <Cancellable>[];

//   void mediate(Cancellable cancellable) {
//     _cancellables.add(cancellable);
//   }

//   @override
//   void cancel() {
//     for (final cancellable in _cancellables) {
//       cancellable.cancel();
//     }
//   }
// }

// class CompareOptions {
//   final bool caseSensitive;
//   final bool diacriticSensitive;
//   final bool exact;
//   final bool regularExpression;

//   CompareOptions({
//     required this.caseSensitive,
//     required this.diacriticSensitive,
//     required this.exact,
//     required this.regularExpression,
//   });
// }