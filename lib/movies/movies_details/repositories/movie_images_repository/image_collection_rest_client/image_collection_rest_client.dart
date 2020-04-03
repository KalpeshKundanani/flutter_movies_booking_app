import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_movies_booking_app/movies/movies_details/models/image_collection/image_collection.dart';
import 'package:retrofit/retrofit.dart';

part 'image_collection_rest_client.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org')
abstract class ImageCollectionRestClient {
  factory ImageCollectionRestClient(Dio dio, {String baseUrl}) =
      _ImageCollectionRestClient;

  @GET("/3/movie/{id}/images")
  Future<ImageCollection> getImageCollection(
      @Path("id") int id, @Query("api_key") String apiKey);
}
