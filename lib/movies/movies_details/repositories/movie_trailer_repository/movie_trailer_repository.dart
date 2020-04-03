import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/models/movie_trailer_result/movie_trailer_result.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/repositories/movie_trailer_repository/movie_trailer_rest_client/movie_trailers_rest_client.dart';
import 'package:flutter_movies_booking_app/resources/strings.dart';

class MovieTrailerRepository {
  final Dio _dio = Dio();

  String get _apiKey => tmdb_api_key;

  Future<Box<String>> get _movieTrailerBox async =>
      await Hive.openBox<String>(_movieTrailerBoxKey);

  static const String _movieTrailerBoxKey = 'movie_trailer_box';

  Future<String> getTrailerPathByMovieId(int id) async {
    final Box<String> _movieTrailerCache = await _movieTrailerBox;
    String trailerPath;
    if (_movieTrailerCache.containsKey(id)) {
      trailerPath = _movieTrailerCache.get(id);
    } else {
      final imagesCollectionRestClient = MovieTrailerResultRestClient(_dio);
      MovieTrailerResult movieTrailerResult =
          await imagesCollectionRestClient.getMovieTrailerResult(id, _apiKey);
      trailerPath = movieTrailerResult.trailers.first.key;
      await _movieTrailerCache.put(id, trailerPath);
    }
    await _movieTrailerCache.close();
    return trailerPath;
  }
}
