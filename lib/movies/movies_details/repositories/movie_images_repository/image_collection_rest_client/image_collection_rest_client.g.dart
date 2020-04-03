// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_collection_rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ImageCollectionRestClient implements ImageCollectionRestClient {
  _ImageCollectionRestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://api.themoviedb.org';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getImageCollection(id, apiKey) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(apiKey, 'apiKey');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'api_key': apiKey};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/3/movie/$id/images',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ImageCollection.fromJson(_result.data);
    return Future.value(value);
  }
}
