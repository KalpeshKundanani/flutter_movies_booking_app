import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';

part 'upcoming_movie_result.g.dart';

@JsonSerializable()
class UpcomingMovieResult {
  @JsonKey(name: 'results')
  final List<Movie> results;

  const UpcomingMovieResult(this.results);

  factory UpcomingMovieResult.fromJson(Map<String, dynamic> json) =>
      _$UpcomingMovieResultFromJson(json);

  Map<String, dynamic> toJson() => _$UpcomingMovieResultToJson(this);
}
