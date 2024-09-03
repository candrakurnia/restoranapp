import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/api/apiservice.dart';
import 'package:restoranapp/db/db_helper.dart';
import 'package:restoranapp/navigation.dart';
import 'package:restoranapp/ui/page/bookmark_page.dart';
import 'package:restoranapp/ui/page/detail_restaurant.dart';
import 'package:restoranapp/ui/page/homescreen_page.dart';
import 'package:restoranapp/ui/page/search_page.dart';
import 'package:restoranapp/ui/page/setting_page.dart';
import 'package:restoranapp/ui/page/splashscreen_page.dart';
import 'package:restoranapp/ui/provider/db_provider.dart';
import 'package:restoranapp/ui/provider/homescreen_provider.dart';
import 'package:restoranapp/ui/provider/notification_preferences.dart';
import 'package:restoranapp/ui/provider/searchscreen_provider.dart';
import 'package:restoranapp/utils/background_services.dart';
import 'package:restoranapp/utils/notification_helper.dart';
import 'package:restoranapp/utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => NotificationPreferencesProvider(
                notifPreferences: NotifPreferences(
                    sharedPreferences: SharedPreferences.getInstance()))),
        ChangeNotifierProvider(
          create: (context) => HomeScreenProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchScreenProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) => DbProvider(databasehelper: Databasehelper())),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreenPage.routeName,
        routes: {
          SplashScreenPage.routeName: (context) => const SplashScreenPage(),
          HomeScreenPage.routeName: (context) => const HomeScreenPage(),
          DetailRestaurant.routeName: (context) => DetailRestaurant(
                restaurantId:
                    ModalRoute.of(context)!.settings.arguments as String,
              ),
          BookmarkPage.routeName: (context) => const BookmarkPage(),
          SearchPage.routeName: (context) => const SearchPage(),
          SettingsPage.routeName: (context) => const SettingsPage(),
        },
      ),
    );
  }
}
