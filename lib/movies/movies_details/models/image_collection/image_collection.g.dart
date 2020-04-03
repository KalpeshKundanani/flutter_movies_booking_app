// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageCollection _$ImageCollectionFromJson(Map<String, dynamic> json) {
  return ImageCollection(
    json['id'] as int,
    (json['backdrops'] as List)
        ?.map((e) =>
            e == null ? null : MovieImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ImageCollectionToJson(ImageCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'backdrops': instance.backdrops,
    };

MovieImage _$MovieImageFromJson(Map<String, dynamic> json) {
  return MovieImage(
    (json['aspect_ratio'] as num)?.toDouble(),
    json['file_path'] as String,
  );
}

Map<String, dynamic> _$MovieImageToJson(MovieImage instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'file_path': instance.filePath,
    };
