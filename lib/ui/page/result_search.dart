import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/ui/model/search_restaurant_model.dart';
import 'package:restoranapp/ui/provider/searchscreen_provider.dart';

import 'detail_restaurant.dart';

//class enum states sudah diimpor di bawah ini
import 'states.dart';

class ResultSearch extends StatelessWidget {
  final String resultSearch = "";

  const ResultSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchScreenProvider>(
      builder: (context, state, _) {
        if (state.stateSearch == ResultState.loading) {
          return const CircularProgressIndicator();
        } else if (state.stateSearch == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.searchRestaurant!.restaurants.length,
            itemBuilder: (context, index) {
              var cariRestoran = state.searchRestaurant!.restaurants[index];
              return listSearchRestaurant(context, cariRestoran);
            },
          );
        } else if (state.stateSearch == ResultState.noData) {
          return const Center(
            child: Text("Tidak ada data ditemukan"),
          );
        } else if (state.stateSearch == ResultState.error) {
          return Center(
            child: Text(state.messageSearch),
          );
        } else {
          return const Center(
            child: Text(""),
          );
        }
      },
    );
  }
}

Widget listSearchRestaurant(
    BuildContext context, Restaurantsearch cariRestoran) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    leading: Image.network(
      "https://restaurant-api.dicoding.dev/images/medium/${cariRestoran.pictureId}",
      width: 120,
    ),
    title: Text(
      cariRestoran.name,
      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
    ),
    subtitle: Text(
      cariRestoran.city,
      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
    ),
    onTap: () async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailRestaurant(restaurantId: cariRestoran.id),
        ),
      );
    },
  );
}
