import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/tickets/search/cities_repository.dart';
import 'package:flutter_movies_booking_app/tickets/seat_selector_widget.dart';
import 'package:flutter_movies_booking_app/utils/app_hive_utils.dart';

part 'cinema_search_widget.g.dart';

/// This widget is used to show the dummy list of cinemas for a
/// movie on a selected place.
/// users can select the time of the show.
class CinemaSearchWidget extends StatefulWidget {
  /// Used by the navigator to push this widget on the stack.
  static const String routeName = './CinemaSearchWidget';

  @override
  _CinemaSearchWidgetState createState() => _CinemaSearchWidgetState();
}

class _CinemaSearchWidgetState extends State<CinemaSearchWidget> {
  /// The parent widget is supposed to inject the dependency of
  /// Movie to create this widget.
  /// This variable will be initialized from the fetched movie from
  /// the Navigator at build time.
  Movie _movie;

  Place get place => _movie.place;

  @override
  Widget build(BuildContext context) {
    _movie = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(place.city)),
      body: ListView.builder(
        itemCount: 10, // dummy list with 10 cinemas.
        itemBuilder: (BuildContext context, int index) {
          final Cinema cinema = Cinema(index + 1);
          return _buildCinemaListItem(context, cinema);
        },
      ),
    );
  }

  /// Creates a list item that is a Card and shows Cinema name and
  /// list of show time of that cinema.
  Card _buildCinemaListItem(BuildContext context, Cinema cinema) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildCinemaTitle(cinema, theme),
            _buildShowTimeList(cinema, context)
          ],
        ),
      ),
    );
  }

  /// Will create the list of show time. This list will contain
  /// input chips clicking on which user will be shown option to select
  /// seats.
  Wrap _buildShowTimeList(Cinema cinema, BuildContext context) => Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: cinema.showTimes
            .map((String showTime) =>
                _buildShowTimeListItem(showTime, cinema, context))
            .toList(),
      );

  /// This will create an Input chip that will represent a given
  /// show time. clicking on this show time will take user to
  ///
  Padding _buildShowTimeListItem(
          String showTime, Cinema cinema, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InputChip(
          // backgroundColor: the,
          label: Text(showTime),
          onPressed: () => _onShowTimeSelected(cinema, showTime, context),
        ),
      );

  /// This will launch the seat selection widget.
  void _onShowTimeSelected(
      Cinema cinema, String showTime, BuildContext context) {
    cinema.selectedShowTime = showTime;
    _movie.cinema = cinema;
    Navigator.pushNamed(
      context,
      SeatSelectorWidget.routeName,
      arguments: _movie,
    );
  }

  /// Name of the cinema in cinema list item.
  Padding _buildCinemaTitle(Cinema cinema, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        cinema.name,
        style: TextStyle(
            color: theme.accentColor,
            fontSize: 25,
            fontWeight: FontWeight.w300),
      ),
    );
  }
}

/// this is supposed to be fetched from the theatre api, as we don't
/// have it as of now we are using dummy data

@HiveType(typeId: cinemaTypeId)
class Cinema {
  Cinema(this.id);

  String get name => 'Cinema $id';

  @HiveField(0)
  final int id;

  @HiveField(1)
  String selectedShowTime;

  @HiveField(2)
  List<String> selectedSeats;

  String get selectedSeatsAsString => selectedSeats.join(', ');

  final List<String> showTimes = [
    '09:00 AM',
    '10:15 AM',
    '11:00 AM',
    '12:15 PM',
    '02:00 PM',
    '03:15 PM',
    '05:00 PM',
    '06:15 PM',
    '08:00 PM',
    '10:15 PM',
    '12:00 AM',
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cinema &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          selectedShowTime == other.selectedShowTime &&
          selectedSeats == other.selectedSeats;

  @override
  int get hashCode =>
      id.hashCode ^ selectedShowTime.hashCode ^ selectedSeats.hashCode;

  @override
  String toString() {
    return 'Cinema{name: $name, selectedShowTime: $selectedShowTime, selectedSeats: $selectedSeats}';
  }
}
