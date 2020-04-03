import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/movies/movies_repository/upcoming_movie_rest_client/upcoming_movie_rest_client.dart';
import 'package:flutter_movies_booking_app/resources/strings.dart';

class MoviesRepository {
  final Dio _dio = Dio();
  static const String _movieBoxKey = 'movies_box';

  String get _apiKey => tmdb_api_key;

  Future<Box<Movie>> get _moviesBox async =>
      await Hive.openBox<Movie>(_movieBoxKey);

  Future<List<Movie>> get movies async {
    final Box<Movie> movieCache = await _moviesBox;
    List<Movie> list;
    try {
      if (movieCache.isNotEmpty) {
        // from cache.
        list = movieCache.values.toList();
      } else {
        final upcomingMoviesRestClient = UpcomingMoviesRestClient(_dio);
        final upcomingMovieResult =
            await upcomingMoviesRestClient.getUpcomingMovies(_apiKey);
        list = upcomingMovieResult.results;
        await _cacheMovies(list, movieCache);
      }
    } catch (e) {
      print(e);
    }
    await movieCache.close();
    return list;
  }

  Future<void> _cacheMovies(List<Movie> results, Box<Movie> box) async {
    Map<int, Movie> moviesMap =
        Map.fromIterable(results, key: (e) => e.id, value: (e) => e);
    await box.putAll(moviesMap);
  }

  Future<Movie> getMovieById(final int id) async {
    final Box<Movie> movieCache = await _moviesBox;
    Movie movie;
    if (movieCache.containsKey(id)) {
      // from cache.
      movie = movieCache.get(id);
    }
    await movieCache.close();
    return movie;
  }
}
