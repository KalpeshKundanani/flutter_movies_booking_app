import 'dart:async' show Future;
import 'dart:convert';
import 'package:hive/hive.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_movies_booking_app/utils/app_hive_utils.dart';
import 'package:meta/meta.dart';

part 'cities_repository.g.dart';

List<Place> _places;

Future<List<Place>> fetchPlaces() async {
  if (_places == null) {
    var jsonString = await rootBundle.loadString('assets/indian_cities.json');
    _places = placesFromJson(jsonString);
  }
  return _places;
}

List<Place> popularCities = <Place>[
  Place(city: 'Ahmedabad', district: 'Ahmedabad', state: 'Gujarat'),
  Place(city: 'Bangalore', district: 'Bangalore', state: 'Karnataka'),
  Place(city: 'Delhi/NCR', district: 'Delhi', state: 'Delhi'),
  Place(city: 'Hyderabad', district: 'Unnao', state: 'Uttar Pradesh'),
  Place(city: 'Kolkata', district: 'Kolkata', state: 'West Bengal'),
  Place(city: 'Mumbai', district: 'Mumbai', state: 'Maharashtra'),
  Place(city: 'Pune', district: 'Pune', state: 'Maharashtra'),
  Place(city: 'Chennai', district: 'Chennai', state: 'Tamil Nadu'),
];

List<Place> placesFromJson(String str) =>
    List<Place>.from(json.decode(str).map((x) => Place.fromJson(x)));

@HiveType(typeId: placeTypeId)
class Place {
  @HiveField(0)
  final String city;
  @HiveField(1)
  final String state;
  @HiveField(2)
  final String district;

  Place({
    @required this.city,
    @required this.state,
    @required this.district,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        city: json["City"],
        state: json["State"],
        district: json["District"],
      );

  bool query(String searchQuery) {
    searchQuery = searchQuery.toLowerCase();
    return city.toLowerCase().contains(searchQuery);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Place &&
          runtimeType == other.runtimeType &&
          city == other.city &&
          state == other.state &&
          district == other.district;

  @override
  int get hashCode => city.hashCode ^ state.hashCode ^ district.hashCode;

  @override
  String toString() {
    return 'Place{city: $city, state: $state, district: $district}';
  }
}
