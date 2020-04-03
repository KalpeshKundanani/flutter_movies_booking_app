import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_movies_booking_app/movies/movies_details/models/genre/genre.dart';
import 'package:retrofit/retrofit.dart';

part 'movie_genres_rest_client.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org')
abstract class MovieGenresRestClient {
  factory MovieGenresRestClient(Dio dio, {String baseUrl}) =
      _MovieGenresRestClient;

  @GET("/3/genre/movie/list")
  Future<GenreResult> getGenreResult(@Query("api_key") String apiKey);
}
