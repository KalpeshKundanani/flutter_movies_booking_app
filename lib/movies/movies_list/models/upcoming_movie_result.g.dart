// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_movie_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpcomingMovieResult _$UpcomingMovieResultFromJson(Map<String, dynamic> json) {
  return UpcomingMovieResult(
    (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Movie.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UpcomingMovieResultToJson(
        UpcomingMovieResult instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
