import 'package:json_annotation/json_annotation.dart';

part 'movie_trailer_result.g.dart';

@JsonSerializable()
class MovieTrailerResult {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'results')
  final List<MovieTrailer> trailers;

  const MovieTrailerResult(this.id, this.trailers);

  factory MovieTrailerResult.fromJson(Map<String, dynamic> json) =>
      _$MovieTrailerResultFromJson(json);

  Map<String, dynamic> toJson() => _$MovieTrailerResultToJson(this);

  @override
  String toString() {
    return ' $trailers';
  }
}

@JsonSerializable()
class MovieTrailer {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'key')
  final String key;

  const MovieTrailer(this.id, this.key);

  factory MovieTrailer.fromJson(Map<String, dynamic> json) =>
      _$MovieTrailerFromJson(json);

  Map<String, dynamic> toJson() => _$MovieTrailerToJson(this);

  @override
  String toString() {
    return ' $key';
  }
}
