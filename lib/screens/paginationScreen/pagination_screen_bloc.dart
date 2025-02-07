import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen_dl.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen_repo.dart';

class PaginationScreenBloc {
  PaginationScreenBloc() {
    pagingController.addPageRequestListener(
      (pageNumber) {
        getData(pageNumber);
      },
    );
  }
  PaginationScreenRepo repo = PaginationScreenRepo();
  final isExpanded = BehaviorSubject<bool>.seeded(false);

  PagingController<int, Results> pagingController = PagingController(firstPageKey: 1);

  Future<void> getData(int pageNumber) async {
    final data = await repo.fetchData(pageNumber);
    List<Results> resultsList = data.results ?? [];
    final isLastPage = resultsList.length < 20;
    if (isLastPage) {
      pagingController.appendLastPage(resultsList);
    } else {
      final nextPageKey = pageNumber + resultsList.length;
      pagingController.appendPage(resultsList, nextPageKey);
    }
  }
}
