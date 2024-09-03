import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restoranapp/db/db_helper.dart';
import 'package:restoranapp/ui/model/resto_model.dart';

//class enum states sudah diimpor di bawah ini
import '../page/states.dart';


class DbProvider extends ChangeNotifier {
  final Databasehelper databasehelper;

  DbProvider({required this.databasehelper}) {
    _getBookmarks();
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _bookmarks = [];
  List<Restaurant> get bookmarks => _bookmarks;

  void _getBookmarks() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _bookmarks = await databasehelper.getBookmark();
      if (_bookmarks.isNotEmpty) {
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = "Empty Data";
      }
      notifyListeners();
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      _message = "periksa kembali jaringan anda";
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      _message = "Error ---> $e";
    }
  }


  void addBookmarks(Restaurant restaurant) async {
    try {
      await databasehelper.insertBookmark(restaurant);
      _getBookmarks();
    } catch (e) {
      _state = ResultState.error;
      _message = "Error : $e";
      notifyListeners();
    }
  }

  Future<bool> isBookmarked(String id) async {
    final bookmarkedRestaurant = await databasehelper.getBookmarkbyId(id);
    return bookmarkedRestaurant.isNotEmpty;
  }

  void removeBookmark(String id) async {
    try {
      await databasehelper.removeBookmark(id);
      _getBookmarks();
    } catch (e) {
      _state = ResultState.error;
      _message = "Error : $e";
      notifyListeners();
    }
  }
}
