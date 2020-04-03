import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_movies_booking_app/movies/movies_details/models/movie_trailer_result/movie_trailer_result.dart';
import 'package:retrofit/retrofit.dart';

part 'movie_trailers_rest_client.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org')
abstract class MovieTrailerResultRestClient {
  factory MovieTrailerResultRestClient(Dio dio, {String baseUrl}) =
      _MovieTrailerResultRestClient;

  @GET("/3/movie/{id}/videos")
  Future<MovieTrailerResult> getMovieTrailerResult(
      @Path("id") int id, @Query("api_key") String apiKey);
}
