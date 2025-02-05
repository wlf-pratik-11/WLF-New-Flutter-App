import 'package:rxdart/rxdart.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen_dl.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen_repo.dart';

class PaginationScreenBloc {
  PaginationScreenBloc() {
    getData();
  }
  PaginationScreenRepo repo = PaginationScreenRepo();

  final resultController = BehaviorSubject<List<Results>>();

  Future<void> getData() async {
    final data = await repo.fetchData();
    List<Results> resultsList = data.results ?? [];
    resultController.sink.add(resultsList);
  }
}
