import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/tickets/search/cinema_search_widget.dart';
import 'package:flutter_movies_booking_app/tickets/search/cities_repository.dart';
import 'package:flutter_movies_booking_app/tickets/summary_widget.dart';

/// This widget is used to give user an option to select the seat.
/// At-least one seat is needed to be selected to go to next page.
/// Whenever a seat is selected the state of this widget is rebuilt.
class SeatSelectorWidget extends StatefulWidget {
  /// Used by the navigator to push this widget on the stack.
  static const routeName = './SeatSelectorWidget';

  @override
  _SeatSelectorWidgetState createState() => _SeatSelectorWidgetState();
}

class _SeatSelectorWidgetState extends State<SeatSelectorWidget> {
  /// The parent widget is supposed to inject the dependency of
  /// Movie to create this widget.
  /// This variable will be initialized from the fetched movie from
  /// the Navigator at build time.
  Movie _movie;

  /// Place selected by user in previous screens.
  Place get _place => _movie.place;

  /// Cinema selected by user in previous screen.
  Cinema get _cinema => _movie.cinema;

  /// seats ids that user wants to select.
  /// when the size is greater than 0 user can see the
  /// confirm button and can buy those seats.
  List<String> _selectedSeats = <String>[];

  @override
  Widget build(BuildContext context) {
    _movie = ModalRoute.of(context).settings.arguments;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: _buildConfirmButton(context),
      appBar: _buildAppBar(textTheme),
      body: _buildBody(textTheme),
    );
  }

  /// Widget that shows user the seat selection widget and the
  /// screen's position.
  SingleChildScrollView _buildBody(TextTheme textTheme) =>
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Screen', style: textTheme.title),
            ),
            Divider(indent: 20, endIndent: 20, thickness: 5),
            _buildSeatsSelectionWidget(),
          ],
        ),
      );

  /// Will create a widget where seats will be arranged in the grid and
  /// user can tap and select/un-select those seats.
  Padding _buildSeatsSelectionWidget() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _dummyData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
            ),
            itemBuilder: (_, final int index) => _buildSeat(index)),
      );

  /// Seat grid list item. Layout of per seat.
  Widget _buildSeat(int index) {
    var seat = _dummyData.elementAt(index);
    var isSelected = isSelectedSeat(seat);
    var seatColor = !isSelected ? Colors.white30 : Colors.white70;
    return InkWell(
      onTap: () => setState(() =>
          isSelected ? _selectedSeats.remove(seat) : _selectedSeats.add(seat)),
      child: Padding(
        // space around seat.
        padding: const EdgeInsets.all(2),
        // seat it self.
        child: Container(
          color: seatColor,
          alignment: Alignment.center,
          padding: EdgeInsets.all(8), // spacing around the text of the seat.
          // text that fits in the seat and represents seat id.
          child: FittedBox(
            child: Text(seat, style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }

  /// Will create an app bar that will show user their selected place,
  /// cinema and showtime.
  AppBar _buildAppBar(TextTheme textTheme) => AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${_place.city}',
              style: TextStyle(fontSize: textTheme.title.fontSize),
            ),
            Text(
              '${_cinema.name} | ${_cinema.selectedShowTime}',
              style: TextStyle(fontSize: textTheme.subtitle.fontSize),
            ),
          ],
        ),
      );

  /// This button is shown to user when they have selected at least one seat.
  /// When user press this button they are redirected to the screen
  /// where they can see the summary.
  Widget _buildConfirmButton(BuildContext context) => Visibility(
        visible: _selectedSeats.isNotEmpty,
        child: FloatingActionButton.extended(
          icon: Icon(Icons.thumb_up),
          label: Text('Done'),
          onPressed: () {
            _selectedSeats.sort();
            _cinema.selectedSeats = _selectedSeats;
            _movie.cinema = _cinema;
            Navigator.pushNamed(
              context,
              SummaryWidget.routeName,
              arguments: _movie,
            );
          },
        ),
      );

  /// Returns true if selected seats has the provided seat, false other wise.
  bool isSelectedSeat(String seat) => _selectedSeats.contains(seat);
}

List<String> _dummyData = [
  'A 1',
  'A 2',
  'A 3',
  'A 4',
  'A 5',
  'A 6',
  'A 7',
  'A 8',
  'A 9',
  'B 1',
  'B 2',
  'B 3',
  'B 4',
  'B 5',
  'B 6',
  'B 7',
  'B 8',
  'B 9',
  'C 1',
  'C 2',
  'C 3',
  'C 4',
  'C 5',
  'C 6',
  'C 7',
  'C 8',
  'C 9',
  'D 1',
  'D 2',
  'D 3',
  'D 4',
  'D 5',
  'D 6',
  'D 7',
  'D 8',
  'D 9',
  'E 1',
  'E 2',
  'E 3',
  'E 4',
  'E 5',
  'E 6',
  'E 7',
  'E 8',
  'E 9',
  'F 1',
  'F 2',
  'F 3',
  'F 4',
  'F 5',
  'F 6',
  'F 7',
  'F 8',
  'F 9',
  'G 1',
  'G 2',
  'G 3',
  'G 4',
  'G 5',
  'G 6',
  'G 7',
  'G 8',
  'G 9',
  'H 1',
  'H 2',
  'H 3',
  'H 4',
  'H 5',
  'H 6',
  'H 7',
  'H 8',
  'H 9',
  'I 1',
  'I 2',
  'I 3',
  'I 4',
  'I 5',
  'I 6',
  'I 7',
  'I 8',
  'I 9',
];
