import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/api/apiservice.dart';
import 'package:restoranapp/ui/model/detail_resto_model.dart';
import 'package:restoranapp/ui/model/resto_model.dart';
import 'package:restoranapp/ui/provider/db_provider.dart';
import 'package:restoranapp/ui/provider/detailscreen_provider.dart';

//class enum states sudah diimpor di bawah ini
import 'states.dart';

class DetailRestaurant extends StatefulWidget {
  static const routeName = '/detailRestaurant';
  final String restaurantId;
  const DetailRestaurant({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  State<DetailRestaurant> createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends State<DetailRestaurant> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailScreenProvider>(
      create: (_) => DetailScreenProvider(
          apiService: ApiService(), restaurantId: widget.restaurantId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail"),
        ),
        body: Consumer<DetailScreenProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              var detailrestaurant = state.result.restaurant;
              return _detailrestaurant(context, detailrestaurant);
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Text(state.message),
              );
            } else if (state.state == ResultState.error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(
                child: Material(
                  child: Text(" "),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _detailrestaurant(
      BuildContext context, RestaurantDetail detailrestaurant) {
    return Consumer<DbProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(detailrestaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Image.network(
                        "https://restaurant-api.dicoding.dev/images/large/${detailrestaurant.pictureId}",
                        width: MediaQuery.of(context).size.width,
                        height: 250.0,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: isBookmarked
                            ? IconButton(
                                onPressed: () {
                                  provider.removeBookmark(detailrestaurant.id);
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  size: 32.0,
                                  color: Colors.red,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  provider.addBookmarks(Restaurant(
                                      id: detailrestaurant.id,
                                      name: detailrestaurant.name,
                                      description: detailrestaurant.description,
                                      pictureId: detailrestaurant.pictureId,
                                      city: detailrestaurant.city,
                                      rating: detailrestaurant.rating));
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detailrestaurant.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  detailrestaurant.city,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  detailrestaurant.address,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Rating",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  detailrestaurant.rating.toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            )
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        Text(
                          detailrestaurant.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(color: Colors.grey),
                        Text(
                          "Menu makanan disini",
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Text(
                                  "${detailrestaurant.menus.foods[index].name}, ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                  ),
                                );
                              },
                              itemCount: detailrestaurant.menus.foods.length,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        Text(
                          "Menu minuman disini",
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Text(
                                  "${detailrestaurant.menus.drinks[index].name}, ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                  ),
                                );
                              },
                              itemCount: detailrestaurant.menus.drinks.length,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
