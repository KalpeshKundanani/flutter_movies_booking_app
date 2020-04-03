// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_trailer_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieTrailerResult _$MovieTrailerResultFromJson(Map<String, dynamic> json) {
  return MovieTrailerResult(
    json['id'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : MovieTrailer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MovieTrailerResultToJson(MovieTrailerResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.trailers,
    };

MovieTrailer _$MovieTrailerFromJson(Map<String, dynamic> json) {
  return MovieTrailer(
    json['id'] as String,
    json['key'] as String,
  );
}

Map<String, dynamic> _$MovieTrailerToJson(MovieTrailer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
    };
