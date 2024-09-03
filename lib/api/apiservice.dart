import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restoranapp/ui/model/detail_resto_model.dart';
import 'package:restoranapp/ui/model/resto_model.dart';
import 'package:restoranapp/ui/model/search_restaurant_model.dart';

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<RestoModel> listResto(http.Client client) async {
    final response = await client.get(Uri.parse("${_baseUrl}list"));

    if (response.statusCode == 200) {
      return RestoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load all restaurant");
    }
  }

  Future<DetailResto> detailRestoran(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));

    if (response.statusCode == 200) {
      return DetailResto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to load restaurant detail");
    }
  }

  Future<SearchRestaurant> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$query"));

    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Searching Restaurant");
    }
  }
}
