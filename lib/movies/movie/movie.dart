import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_movies_booking_app/tickets/search/cinema_search_widget.dart';
import 'package:flutter_movies_booking_app/tickets/search/cities_repository.dart';
import 'package:flutter_movies_booking_app/utils/app_hive_utils.dart';

part 'movie.g.dart';

@JsonSerializable()
@HiveType(typeId: movieTypeId)
class Movie {
  @JsonKey(name: 'id')
  @HiveField(0)
  final int id;

  @JsonKey(name: 'poster_path')
  @HiveField(1)
  final String posterURL;

  @JsonKey(name: 'title')
  @HiveField(2)
  final String title;

  @JsonKey(name: 'release_date')
  @HiveField(3)
  final DateTime releaseDate;

  @JsonKey(name: 'adult')
  @HiveField(4)
  final bool isAdult;

  @JsonKey(name: 'genre_ids')
  @HiveField(5)
  final List<int> genreIds;

  @JsonKey(name: 'overview')
  @HiveField(6)
  final String overview;

  @JsonKey(name: 'vote_average')
  @HiveField(7)
  final double rating;

  @JsonKey(name: 'original_language')
  @HiveField(8)
  final String language;

  @HiveField(9)
  @JsonKey(ignore: true)
  Place place;

  @JsonKey(ignore: true)
  @HiveField(10)
  Cinema cinema;

  Movie(
    this.id,
    this.posterURL,
    this.title,
    this.releaseDate,
    this.isAdult,
    this.genreIds,
    this.overview,
    this.rating,
    this.language,
  );

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  get posterPath {
    return 'http://image.tmdb.org/t/p/w185/$posterURL';
  }

  get hqPosterPath {
    return 'http://image.tmdb.org/t/p/w342/$posterURL';
  }

  get ticketPosterPath {
    return 'http://image.tmdb.org/t/p/w154/$posterURL';
  }

  String get formattedReleaseDate {
    return DateFormat('dd MMM yy').format(releaseDate);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          place == other.place &&
          cinema == other.cinema;

  @override
  int get hashCode => id.hashCode ^ place.hashCode ^ cinema.hashCode;

  @override
  String toString() {
    return 'Movie{title: $title, place: $place, cinema: $cinema}';
  }
}
