import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/ui/provider/notification_preferences.dart';
import 'package:restoranapp/ui/provider/scheduling_provider.dart';
import 'package:restoranapp/widget/custom_dialog.dart';
import 'package:restoranapp/widget/platform_widget.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "/settingsPage";

  static const String settingsTitle = 'Settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsPage.settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(SettingsPage.settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(),
      child: Card(
        child: ListTile(
          title: const Text('Scheduling News'),
          trailing:
              Consumer2<SchedulingProvider, NotificationPreferencesProvider>(
            builder: (context, scheduled, notifikasi, _) {
              return Switch.adaptive(
                value: notifikasi.notif!,
                onChanged: (value) async {
                  if (Platform.isIOS) {
                    customDialog(context);
                  } else {
                    notifikasi.setSavebutton(value);
                    scheduled.scheduledNews(value);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
