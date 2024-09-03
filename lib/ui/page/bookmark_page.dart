import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/ui/model/resto_model.dart';
import 'package:restoranapp/ui/page/detail_restaurant.dart';
import 'package:restoranapp/ui/provider/db_provider.dart';

//class enum states sudah diimpor di bawah ini
import 'states.dart';


class BookmarkPage extends StatelessWidget {
  static const routeName = "/bookmark";
  static const String bookmarksTitle = "Bookmarks";

  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Favorite"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DbProvider>(builder: (context, provider, child) {
      if (provider.state == ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ResultState.hasData) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: provider.bookmarks.length,
          itemBuilder: (context, index) {
            return cardData(context, provider.bookmarks[index]);
          },
        );
      } else {
        return Center(
          child: Material(
            child: Text(provider.message),
          ),
        );
      }
    });
  }

  Widget cardData(BuildContext context, Restaurant bookmark) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: Image.network(
          "https://restaurant-api.dicoding.dev/images/medium/${bookmark.pictureId}",
          width: 120,
          fit: BoxFit.fill, errorBuilder: (context, error, stackTrace) {
        return const Text("No Picture");
      }),
      title: Text(
        bookmark.name,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        bookmark.city,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailRestaurant(
              restaurantId: bookmark.id,
            ),
          ),
        );
      },
    );
  }
}
