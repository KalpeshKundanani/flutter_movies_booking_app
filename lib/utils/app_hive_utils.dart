import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/models/genre/genre.dart';
import 'package:flutter_movies_booking_app/tickets/search/cinema_search_widget.dart';
import 'package:flutter_movies_booking_app/tickets/search/cities_repository.dart';

const int movieTypeId = 0;
const int genreTypeId = 1;
const int placeTypeId = 2;
const int cinemaTypeId = 3;

void registerHiveAdapters() {
  Hive.registerAdapter(MovieAdapter());
  Hive.registerAdapter(GenreAdapter());
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(CinemaAdapter());
}
