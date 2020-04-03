import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/movies_details_widget.dart';
import 'package:flutter_movies_booking_app/movies/movies_list/movies_list_widget.dart';
import 'package:flutter_movies_booking_app/tickets/search/cinema_search_widget.dart';
import 'package:flutter_movies_booking_app/tickets/search/city_search_widget.dart';
import 'package:flutter_movies_booking_app/tickets/seat_selector_widget.dart';
import 'package:flutter_movies_booking_app/tickets/summary_widget.dart';
import 'package:flutter_movies_booking_app/tickets/tickets_list_widget.dart';
import 'package:flutter_movies_booking_app/youtube_player/youtube_player_widget.dart';

/// This route will be the first screen that will be shown to the user
/// once user opens the app.
final String initialRoute = MoviesListWidget.routeName;

/// These routes will be used by the navigator to open the respective widget.
final Map<String, WidgetBuilder> routesMap = {
  MoviesListWidget.routeName: (context) => MoviesListWidget(),
  MoviesDetailsWidget.routeName: (context) => MoviesDetailsWidget(),
  YoutubePlayerWidget.routeName: (context) => YoutubePlayerWidget(),
  CitySearchWidget.routeName: (context) => CitySearchWidget(),
  CinemaSearchWidget.routeName: (context) => CinemaSearchWidget(),
  SeatSelectorWidget.routeName: (context) => SeatSelectorWidget(),
  SummaryWidget.routeName: (context) => SummaryWidget(),
  TicketSListWidget.routeName: (context) => TicketSListWidget(),
};
