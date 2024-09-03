import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restoranapp/api/apiservice.dart';
import 'package:restoranapp/ui/model/resto_model.dart';

//class enum states sudah diimpor di bawah ini
import '../page/states.dart';


class HomeScreenProvider extends ChangeNotifier {
  final ApiService apiService;

  HomeScreenProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late RestoModel _restoModel;
  late ResultState _state;

  String _message = '';

  String get message => _message;
  RestoModel get result => _restoModel;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final resto = await ApiService().listResto(Client());

      if (resto.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restoModel = resto;
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
