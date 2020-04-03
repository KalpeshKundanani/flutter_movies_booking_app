import 'package:flutter/cupertino.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/models/genre/genre.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/repositories/movie_genres_repository/movie_genres_repository.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/repositories/movie_images_repository/movie_images_repository.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/repositories/movie_trailer_repository/movie_trailer_repository.dart';
import 'package:flutter_movies_booking_app/movies/movies_repository/movies_repository.dart';

class MovieDetailsViewModel {
  final int id;
  final MoviesRepository _moviesRepository = MoviesRepository();
  final MovieImagesRepository _movieImagesRepository = MovieImagesRepository();
  final MovieTrailerRepository _movieTrailerRepository =
      MovieTrailerRepository();
  final MoviesGenresRepository _genresRepository = MoviesGenresRepository();

  ValueNotifier<List<Genre>> _genresListNotifier;
  ValueNotifier<List<String>> _movieImagesNotifier;
  ValueNotifier<String> _movieTrailerNotifier;
  ValueNotifier<Movie> _movieNotifier;

  MovieDetailsViewModel(this.id);

  Future<ValueNotifier<Movie>> get movieNotifier async {
    if (_movieNotifier == null) {
      final Movie movie = await _moviesRepository.getMovieById(id);
      _movieNotifier = ValueNotifier<Movie>(movie);
    }
    return _movieNotifier;
  }

  Future<ValueNotifier<List<String>>> get movieImagesNotifier async {
    if (_movieImagesNotifier != null) return _movieImagesNotifier;
    final List<String> movieImages =
        await _movieImagesRepository.getImagePathsByMovieId(id);
    _movieImagesNotifier = ValueNotifier<List<String>>(movieImages);
    return _movieImagesNotifier;
  }

  Future<ValueNotifier<String>> get movieTrailerNotifier async {
    if (_movieTrailerNotifier != null) return _movieTrailerNotifier;
    final String trailerPath =
        await _movieTrailerRepository.getTrailerPathByMovieId(id);
    _movieTrailerNotifier = ValueNotifier<String>(trailerPath);
    return _movieTrailerNotifier;
  }

  Future<ValueNotifier<List<Genre>>> get genreListNotifier async {
    if (_genresListNotifier != null) return _genresListNotifier;
    final List<Genre> movies = await _genresRepository.genres;
    _genresListNotifier = ValueNotifier<List<Genre>>(movies);
    return _genresListNotifier;
  }
}
