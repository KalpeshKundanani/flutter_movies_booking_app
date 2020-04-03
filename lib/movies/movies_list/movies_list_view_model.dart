import 'package:flutter/cupertino.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/movies/movies_repository/movies_repository.dart';

class MoviesViewModel {
  ValueNotifier<List<Movie>> _movieListNotifier;
  final MoviesRepository _moviesRepository = MoviesRepository();

  Future<ValueNotifier<List<Movie>>> get movieListNotifier async {
    if (_movieListNotifier != null) return _movieListNotifier;
    final List<Movie> movies = await _moviesRepository.movies;
    _movieListNotifier = ValueNotifier<List<Movie>>(movies);
    return _movieListNotifier;
  }
}
