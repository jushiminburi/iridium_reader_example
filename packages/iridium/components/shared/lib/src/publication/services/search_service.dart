// import 'dart:async';

// import 'package:mno_shared/publication.dart';

// import 'string_search_service.dart';

// // Một kiểu đại diện cho hàm tạo SearchService
// typedef SearchServiceFactory = SearchService? Function(PublicationServiceContext context);


// // Một giao diện cho dịch vụ tìm kiếm
// abstract class SearchService extends PublicationService {
//   SearchOptions get options;

//   Future<Cancellable> search({
//     required String query,
//     SearchOptions? options,
//     required void Function(SearchResult<SearchIterator>) completion,
//   });
// }

// // Giao diện cho trình lặp kết quả tìm kiếm
// abstract class SearchIterator {
//   int? get resultCount;

//   Future<Cancellable> next(void Function(SearchResult<LocatorCollection?>) completion);
//   void close();
// }

// // Mở rộng chức năng cho SearchIterator
// extension SearchIteratorExtensions on SearchIterator {
//   Future<Cancellable> forEach(
//     Future<void> Function(LocatorCollection) block,
//     void Function(SearchResult<void>) completion,
//   ) {

//     final mediator = MediatorCancellable();
//     void next() {
//       final cancellable = this.next((result) async {
//         switch (result) {
//           case SearchResult.success(locators: var locators):
//             if (locators != null) {
//               try {
//                 await block(locators);
//                 next();
//               } catch (error) {
//                 completion(SearchResult.failure(SearchError.wrap(error)));
//               }
//             } else {
//               completion(SearchResult.success());
//             }
//             break;
//           case SearchResult.failure(error: var error):
//             completion(SearchResult.failure(error));
//             break;
//         }
//       });
//       mediator.mediate(cancellable);
//     }
//     next();
//     return mediator;
//   }
// }

// // Giữ các tùy chọn tìm kiếm và các giá trị hiện tại của chúng
// class SearchOptions {
//   bool? caseSensitive;
//   bool? diacriticSensitive;
//   bool? wholeWord;
//   bool? exact;
//   Language? language;
//   bool? regularExpression;
//   Map<String, String> otherOptions;

//   SearchOptions({
//     this.caseSensitive,
//     this.diacriticSensitive,
//     this.wholeWord,
//     this.exact,
//     this.language,
//     this.regularExpression,
//     Map<String, String>? otherOptions,
//   }) : otherOptions = otherOptions ?? {};

//   String? operator [](String key) => otherOptions[key];

//   void operator []=(String key, String? value) {
//     if (value == null) {
//       otherOptions.remove(key);
//     } else {
//       otherOptions[key] = value;
//     }
//   }
// }

// // Kết quả tìm kiếm
// enum SearchResult<Success> {
//   success,
//   failure;
// }

// // Lỗi tìm kiếm
// enum SearchError {
//   publicationNotSearchable,
//   badQuery,
//   resourceError,
//   networkError,
//   cancelled,
//   other;

//   static SearchError wrap(Error error) {
//     switch (error.runtimeType) {
//       case SearchError:
//         return error as SearchError;
//       case ResourceError:
//         return SearchError.resourceError(error as ResourceError);
//       case HTTPError:
//         return SearchError.networkError(error as HTTPError);
//       default:
//         return SearchError.other(error);
//     }
//   }

//   String? get errorDescription {
//     switch (this) {
//       case SearchError.publicationNotSearchable:
//         return "Publication is not searchable";
//       case SearchError.badQuery:
//         return (this as SearchError.badQuery).error.errorDescription;
//       case SearchError.resourceError:
//         return (this as SearchError.resourceError).error.errorDescription;
//       case SearchError.networkError:
//         return (this as SearchError.networkError).error.errorDescription;
//       case SearchError.cancelled:
//         return "Search was cancelled";
//       case SearchError.other:
//         return "Other error occurred";
//     }
//   }
// }

// // Định nghĩa các lớp hỗ trợ như PublicationService, PublicationServiceContext, Cancellable, MediatorCancellable, LocatorCollection, LocalizedError, ResourceError, HTTPError, Publication, v.v. cần được thêm vào. Do đây là ví dụ giả định, các lớp này không được định nghĩa ở đây.
// class Cancellable {
//   bool _isCancelled = false;

//   bool get isCancelled => _isCancelled;

//   void cancel() {
//     _isCancelled = true;
//   }
// }

// class MediatorCancellable extends Cancellable {
//   final List<Cancellable> _cancellables = [];

//   void mediate(Cancellable cancellable) {
//     if (isCancelled) {
//       cancellable.cancel();
//     } else {
//       _cancellables.add(cancellable);
//     }
//   }

//   @override
//   void cancel() {
//     super.cancel();
//     for (var cancellable in _cancellables) {
//       cancellable.cancel();
//     }
//     _cancellables.clear();
//   }
// }

// // Một giao diện cho dịch vụ tìm kiếm
// abstract class SearchService {
//   SearchOptions get options;

//   Future<Cancellable> search({
//     required String query,
//     SearchOptions? options,
//     required void Function(SearchResult<SearchIterator>) completion,
//   });
// }

// /// Giao diện cho trình lặp kết quả tìm kiếm
// abstract class SearchIterator {
//   int? get resultCount;
//   Future<Cancellable> next(void Function(SearchResult<LocatorCollection?>) completion);
//   void close();
// }

// // Mở rộng chức năng cho SearchIterator
// extension SearchIteratorExtensions on SearchIterator {
//   Future<Cancellable> forEach(
//     Future<void> Function(LocatorCollection) block,
//     void Function(SearchResult<void>) completion,
//   ) {
//     final mediator = MediatorCancellable();

//     void next() {
//       final cancellable = this.next((result) async {
//         switch (result) {
//           case SearchResult.success(locators: var locators):
//             if (locators != null) {
//               try {
//                 await block(locators);
//                 next();
//               } catch (error) {
//                 completion(SearchResult.failure(SearchError.wrap(error)));
//               }
//             } else {
//               completion(SearchResult.success());
//             }
//             break;
//           case SearchResult.failure(error: var error):
//             completion(SearchResult.failure(error));
//             break;
//         }
//       });

//       mediator.mediate(cancellable);
//     }

//     next();
//     return mediator;
//   }
// }

// // Giữ các tùy chọn tìm kiếm và các giá trị hiện tại của chúng
// class SearchOptions {
//   bool? caseSensitive;
//   bool? diacriticSensitive;
//   bool? wholeWord;
//   bool? exact;
//   Language? language;
//   bool? regularExpression;
//   Map<String, String> otherOptions;

//   SearchOptions({
//     this.caseSensitive,
//     this.diacriticSensitive,
//     this.wholeWord,
//     this.exact,
//     this.language,
//     this.regularExpression,
//     Map<String, String>? otherOptions,
//   }) : otherOptions = otherOptions ?? {};

//   String? operator [](String key) => otherOptions[key];

//   void operator []=(String key, String? value) {
//     if (value == null) {
//       otherOptions.remove(key);
//     } else {
//       otherOptions[key] = value;
//     }
//   }
// }

// // Kết quả tìm kiếm
// enum SearchResult<Success> {
//   success(Success? locators),
//   failure(SearchError error);
// }

// // Lỗi tìm kiếm
// enum SearchError {
//   publicationNotSearchable,
//   badQuery(LocalizedError error),
//   resourceError(ResourceError error),
//   networkError(HTTPError error),
//   cancelled,
//   other(Error error);

//   static SearchError wrap(Error error) {
//     switch (error.runtimeType) {
//       case SearchError:
//         return error as SearchError;
//       case ResourceError:
//         return SearchError.resourceError(error as ResourceError);
//       case HTTPError:
//         return SearchError.networkError(error as HTTPError);
//       default:
//         return SearchError.other(error);
//     }
//   }

//   String? get errorDescription {
//     switch (this) {
//       case SearchError.publicationNotSearchable:
//         return "Publication is not searchable";
//       case SearchError.badQuery: 
//         return (this as SearchError.badQuery).error.errorDescription;
//       case SearchError.resourceError:
//         return (this as SearchError.resourceError).error.errorDescription;
//       case SearchError.networkError:
//         return (this as SearchError.networkError).error.errorDescription;
//       case SearchError.cancelled:
//         return "Search was cancelled";
//       case SearchError.other:
//         return "Other error occurred";
//     }
//   }
// }
