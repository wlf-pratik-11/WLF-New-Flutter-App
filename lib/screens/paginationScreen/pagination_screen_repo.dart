import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen_dl.dart';

class PaginationScreenRepo {
  final String url = "https://rickandmortyapi.com/api/character?page=";
  int page = 1;
  Future<PaginationScreenDl> fetchData(int pageNumber) async {
    try {
      final dio = Dio();
      final response = await dio.get(url + pageNumber.toString());
      return PaginationScreenDl.fromJson(response.data);
    } catch (e) {
      debugPrint("Error in fetching Data :::::::: ${e.toString()}");
      return PaginationScreenDl();
    }
  }
}
