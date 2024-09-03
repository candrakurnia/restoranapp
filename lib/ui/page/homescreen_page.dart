import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/navigation.dart';
import 'package:restoranapp/ui/model/resto_model.dart';
import 'package:restoranapp/ui/page/bookmark_page.dart';
import 'package:restoranapp/ui/page/detail_restaurant.dart';
import 'package:restoranapp/ui/page/search_page.dart';
import 'package:restoranapp/ui/page/setting_page.dart';
import 'package:restoranapp/ui/provider/homescreen_provider.dart';
import 'package:restoranapp/utils/background_services.dart';
import 'package:restoranapp/utils/notification_helper.dart';

//class enum states sudah diimpor di bawah ini
import 'states.dart';

class HomeScreenPage extends StatefulWidget {
  static const routeName = '/homeScreen';
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  // late NotificationPreferencesProvider notificationPreferencesProvider;
  final BackgroundService _service = BackgroundService();

  @override
  void initState() {
    super.initState();
    port.listen((_) async => await _service.someTask());
    _notificationHelper
        .configureSelectNotificationSubject(DetailRestaurant.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, Candra",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Silahkan Pilih daftar restaurant yang kamu sukai",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchPage()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BookmarkPage()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Consumer<HomeScreenProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.state == ResultState.hasData) {
                    return ListView.builder(
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        var restoran = state.result.restaurants[index];
                        return _listRestoran(context, restoran);
                      },
                    );
                  } else if (state.state == ResultState.noData) {
                    return Center(
                      child: Material(
                        child: Text(state.message),
                      ),
                    );
                  } else if (state.state == ResultState.error) {
                    return Center(
                      child: Material(
                        child: Text(state.message),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Material(
                        child: Text(""),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listRestoran(BuildContext context, Restaurant restoran) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        leading: Image.network(
          "https://restaurant-api.dicoding.dev/images/medium/${restoran.pictureId}",
          width: 120,
        ),
        title: Text(
          restoran.name,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          restoran.city,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        onTap: () async {
          Navigation.intentWithData(DetailRestaurant.routeName, restoran.id);
        });
  }
}
