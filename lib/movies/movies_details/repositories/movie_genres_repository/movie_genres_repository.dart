import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/models/genre/genre.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/repositories/movie_genres_repository/movie_genres_rest_client/movie_genres_rest_client.dart';
import 'package:flutter_movies_booking_app/resources/strings.dart';

class MoviesGenresRepository {
  final Dio _dio = Dio();

  Future<Box<Genre>> get _movieGenresBox async =>
      await Hive.openBox<Genre>(_movieGenresBoxKey);

  String get _apiKey => tmdb_api_key;

  static const String _movieGenresBoxKey = 'movie_genres_box';

  Future<List<Genre>> get genres async {
    final Box<Genre> movieGenresCache = await _movieGenresBox;
    List<Genre> list;
    try {
      if (movieGenresCache.isNotEmpty) {
        // from cache.
        list = movieGenresCache.values.toList();
      } else {
        final movieGenresRestClientGenre = MovieGenresRestClient(_dio);
        final genreResult =
            await movieGenresRestClientGenre.getGenreResult(_apiKey);
        list = genreResult.genres;
        await _cacheGenres(list, movieGenresCache);
      }
    } catch (e) {
      print(e);
    }
    await movieGenresCache.close();
    return list;
  }

  Future<void> _cacheGenres(List<Genre> results, Box<Genre> box) async {
    Map<int, Genre> genresMap =
        Map.fromIterable(results, key: (e) => e.id, value: (e) => e);
    await box.putAll(genresMap);
  }

  Future<Genre> getGenreById(final int id) async {
    final Box<Genre> genreCache = await _movieGenresBox;
    Genre movie;
    if (genreCache.containsKey(id)) {
      // from cache.
      movie = genreCache.get(id);
    } else {
      await genres;
      movie = await getGenreById(id);
    }
    if (genreCache.isOpen) {
      await genreCache.close();
    }
    return movie;
  }
}
