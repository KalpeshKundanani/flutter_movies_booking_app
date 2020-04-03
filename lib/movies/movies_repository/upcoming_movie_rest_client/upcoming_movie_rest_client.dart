import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_movies_booking_app/movies/movies_list/models/upcoming_movie_result.dart';
import 'package:retrofit/retrofit.dart';

part 'upcoming_movie_rest_client.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org')
abstract class UpcomingMoviesRestClient {
  factory UpcomingMoviesRestClient(Dio dio, {String baseUrl}) =
      _UpcomingMoviesRestClient;

  @GET('/3/movie/upcoming')
  Future<UpcomingMovieResult> getUpcomingMovies(
      @Query('api_key') String apiKey);
}
