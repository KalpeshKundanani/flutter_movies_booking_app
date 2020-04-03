import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/tickets/search/cinema_search_widget.dart';
import 'package:flutter_movies_booking_app/tickets/search/cities_repository.dart';
import 'package:flutter_movies_booking_app/tickets/ticket_list_view_model.dart';
import 'package:flutter_movies_booking_app/utils/utility_widgets.dart';

import '../movies/movies_list/movies_list_widget.dart';
import '../movies/movies_list/movies_list_widget.dart';
import 'tickets_list_widget.dart';

/// This widget is used to show user the summary of the selection
/// of movie, city, cinema, showtime and their seats.
/// User can click on the confirm dialog to buy the
/// ticket for this selection.
class SummaryWidget extends StatefulWidget {
  /// Used by the navigator to push this widget on the stack.
  static const routeName = './SummaryWidget';

  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  /// The parent widget is supposed to inject the dependency of
  /// Movie to create this widget.
  /// This variable will be initialized from the fetched movie from
  /// the Navigator at build time.
  /// Selected Movie.
  Movie _movie;

  /// Selected city.
  Place get _place => _movie.place;

  /// Selected cinema.
  Cinema get _cinema => _movie.cinema;

  /// Selected seats.
  List<String> get _selectedSeats => _cinema.selectedSeats;

  @override
  Widget build(BuildContext context) {
    _movie = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      floatingActionButton: _buildConfirmButton(context),
      body: Stack(fit: StackFit.expand, children: [
        buildCachedNetworkImage(_movie.posterPath),
        blurScreen(context),
        _buildContent(),
      ]),
    );
  }

  /// Gives details of the selection to the user.
  /// Contains movie title, city, cinema, showtime and selected seats.
  SafeArea _buildContent() => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildPoster(),
                Text(_movie.title, style: TextStyle(fontSize: 60.0)),
                Text('${_place.city}', style: TextStyle(fontSize: 30.0)),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    '${_cinema.name}  |  ${_cinema.selectedShowTime}',
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Seats: $_selectedSeatsAsString',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Returns comma separated seats as single string.
  String get _selectedSeatsAsString => _selectedSeats.join(', ');

  /// Creates poster of the movie.
  Container _buildPoster() {
    return Container(
      width: 300,
      height: 300,
      child: buildCachedNetworkImage(
        _movie.hqPosterPath,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  /// Button clicking on which user can move to next page.
  FloatingActionButton _buildConfirmButton(BuildContext context) =>
      FloatingActionButton.extended(
        icon: Icon(Icons.thumb_up),
        label: Text('Confirm'),
        onPressed: () async {
          final TicketsListViewModel _ticketsViewModel = TicketsListViewModel();
          await _ticketsViewModel.bookTicket(_movie);
          // remove all the widgets till app's initial route
          // and push tickets widget so that when back button is pressed
          // it takes user to the main screen.
          Navigator.of(context).pushNamedAndRemoveUntil(
              TicketSListWidget.routeName,
              ModalRoute.withName(MoviesListWidget.routeName));
        },
      );
}
