import 'package:json_annotation/json_annotation.dart';

part 'image_collection.g.dart';

@JsonSerializable()
class ImageCollection {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'backdrops')
  final List<MovieImage> backdrops;

  const ImageCollection(this.id, this.backdrops);

  factory ImageCollection.fromJson(Map<String, dynamic> json) =>
      _$ImageCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$ImageCollectionToJson(this);

  List<String> getImagesPaths() {
    var list = backdrops.map((MovieImage image) {
      return 'http://image.tmdb.org/t/p/w342/${image.filePath}';
    }).toList();
    if (list.length > 5) {
      list = list.sublist(0, 5);
    }
    return list;
  }
}

@JsonSerializable()
class MovieImage {
  @JsonKey(name: 'aspect_ratio')
  final double aspectRatio;

  @JsonKey(name: 'file_path')
  final String filePath;

  const MovieImage(this.aspectRatio, this.filePath);

  factory MovieImage.fromJson(Map<String, dynamic> json) =>
      _$MovieImageFromJson(json);

  Map<String, dynamic> toJson() => _$MovieImageToJson(this);
}
