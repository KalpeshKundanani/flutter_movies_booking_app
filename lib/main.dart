import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/resources/app_routes.dart'
    as app_routes;
import 'package:flutter_movies_booking_app/resources/app_theme.dart'
    as app_theme;
import 'package:flutter_movies_booking_app/utils/app_hive_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_movies_booking_app/resources/strings.dart';

// Entry point.
void main() async {
  // as we are awaiting main(),
  // we need to initialize WidgetsBinding first.
  WidgetsFlutterBinding.ensureInitialized();

  // setup hive ORM.
  await _initHiveDatabase();

  // Setting color on navigation and status
  // bar as per app theme. this is to be done here
  // as it can't be done from theme data of Material App.
  _setNavigationAndStatusBarColor();

  // finally run app.
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // easy loading is used to show loading dialogs
    // from all the decedent widgets of this widget.
    return FlutterEasyLoading(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: app_title,
        theme: app_theme.darkTheme,
        initialRoute: app_routes.initialRoute,
        routes: app_routes.routesMap,
      ),
    );
  }
}

/// Will setup path for Hive database.
/// Will register hive adapters using which objects will
/// be cached and retrived from the hive.
Future _initHiveDatabase() async {
  final Directory directory = await getApplicationDocumentsDirectory();

  // giving file path to Hive.
  Hive.init(directory.path);

  // setup adapters to support CRUD operations.
  registerHiveAdapters();
}

/// Sets transparent color on status bar and background color
/// from darkThemeRed on navigation bar.
void _setNavigationAndStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: app_theme.darkTheme.backgroundColor,
  ));
}
