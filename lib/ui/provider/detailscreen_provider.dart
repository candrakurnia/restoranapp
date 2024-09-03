import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restoranapp/api/apiservice.dart';
import 'package:restoranapp/ui/model/detail_resto_model.dart';

//class enum states sudah diimpor di bawah ini
import '../page/states.dart';


class DetailScreenProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  DetailScreenProvider({required this.apiService, required this.restaurantId}) {
    detailOfRestaurant(restaurantId);
  }

  late DetailResto _detailResto;
  late ResultState _state;

  String _message = '';

  String get message => _message;
  DetailResto get result => _detailResto;
  ResultState get state => _state;
  // String get idResult => "";

  Future<dynamic> detailOfRestaurant(String restaurantId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restoDetail = await ApiService().detailRestoran(restaurantId);

      if (restoDetail.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailResto = restoDetail;
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = "periksa kembali jaringan anda";
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "Error ---> $e";
    }
  }
}
