import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/models/image_collection/image_collection.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/repositories/movie_images_repository/image_collection_rest_client/image_collection_rest_client.dart';
import 'package:flutter_movies_booking_app/resources/strings.dart';

class MovieImagesRepository {
  final Dio _dio = Dio();

  Future<Box<List<String>>> get _movieImagesBox async =>
      await Hive.openBox<List<String>>(_movieImagesBoxKey);

  String get _apiKey => tmdb_api_key;

  static const String _movieImagesBoxKey = 'movie_images_box';

  Future<List<String>> getImagePathsByMovieId(int id) async {
    final Box<List<String>> _movieImagesCache = await _movieImagesBox;
    List<String> imagePathList;
    if (_movieImagesCache.containsKey(id)) {
      imagePathList = _movieImagesCache.get(id);
    } else {
      final imagesCollectionRestClient = ImageCollectionRestClient(_dio);
      ImageCollection imageCollection =
          await imagesCollectionRestClient.getImageCollection(id, _apiKey);
      imagePathList = imageCollection.getImagesPaths();
      await _movieImagesCache.put(id, imagePathList);
    }
    await _movieImagesCache.close();
    return imagePathList;
  }
}
