import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restoranapp/api/apiservice.dart';
import 'package:restoranapp/ui/model/search_restaurant_model.dart';

//class enum states sudah diimpor di bawah ini
import '../page/states.dart';


class SearchScreenProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchScreenProvider({required this.apiService}) {
    fetchSearchRestaurant(queryResult);
  }

  SearchRestaurant? _searchRestaurant;
  ResultState? _resultStateSearch;
  String _message = "";
  String _query = "";

  SearchRestaurant? get searchRestaurant => _searchRestaurant;
  ResultState? get stateSearch => _resultStateSearch;
  String get messageSearch => _message;
  String get queryResult => _query;

  Future<dynamic> fetchSearchRestaurant(String queryResult) async {
    try {
      if (queryResult.isNotEmpty) {
        _resultStateSearch = ResultState.loading;
        _query = queryResult;
        notifyListeners();
        final responseSearch = await apiService.searchRestaurant(queryResult);
        if (responseSearch.restaurants.isEmpty) {
          _resultStateSearch = ResultState.noData;
          notifyListeners();
          return _message = "tidak ada data";
        } else {
          _resultStateSearch = ResultState.hasData;
          notifyListeners();
          return _searchRestaurant = responseSearch;
        }
      } else {
        return _message = "Text tidak diketahui";
      }
    } on SocketException {
      _resultStateSearch = ResultState.error;
      notifyListeners();
      return _message = "periksa kembali jaringan anda";
    } catch (e) {
      _resultStateSearch = ResultState.error;
      notifyListeners();
      return _message = "error karena + $e";
    }
  }
}
