import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';

class TicketsRepository {
  Future<Box<Movie>> get _movieBox async =>
      await Hive.openBox<Movie>('confirmed_tickets');

  Future<void> saveBookedTicket(Movie movie) async {
    Box<Movie> box = await _movieBox;
    await box.put(movie.hashCode, movie);
    await box.close();
  }

  Future<List<Movie>> get readBookedMovieTickets async {
    Box<Movie> box = await _movieBox;
    Iterable<Movie> values = box.values;
    await box.close();
    return values.toList();
  }
}
