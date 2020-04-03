import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/movie_details_view_model.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/movies_details_widget.dart';
import 'package:flutter_movies_booking_app/movies/movies_list/movies_list_view_model.dart';
import 'package:flutter_movies_booking_app/tickets/tickets_list_widget.dart';
import 'package:flutter_movies_booking_app/utils/utility_widgets.dart';

/// This widget is used to show the list of movies.
/// List item contains poster, name, release date of the movie.
/// Clicking on book now button or the list item will
/// take user to the MovieDetail Screen.
class MoviesListWidget extends StatelessWidget {
  // Used to register routes for navigator.
  static const String routeName = './MoviesListWidget';

  // provides movie list value notifier through which UI
  // is updated whenever the list is updated in ViewModel.
  final MoviesViewModel _viewModel = MoviesViewModel();

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.movie),
          onPressed: () {
            Navigator.pushNamed(context, TicketSListWidget.routeName);
          },
          label: Text('Your Tickets'),
        ),
        resizeToAvoidBottomInset: false,
        appBar: _appBar,
        body: _body,
      );

  /// creates appbar with app's logo in the middle.
  AppBar get _appBar => AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/app_bar_logo.png',
          fit: BoxFit.cover,
          height: 35.0,
        ),
      );

  /// Observes movielist in ViewModel. Shows loading untill it is not initialized.
  FutureBuilder<ValueNotifier<List<Movie>>> get _body =>
      FutureBuilder<ValueNotifier<List<Movie>>>(
        future: _viewModel.movieListNotifier,
        builder: (_, AsyncSnapshot<ValueNotifier<List<Movie>>> snapshot) {
          return _buildBodyWidgetOnSnapshotReceived(snapshot);
        },
      );

  /// Shows loading view till the ViewModel is initialized and data is fetched
  /// from the repository. When ViewModel is initialized, this widget will
  /// receive every change in movie list that is in ViewModel.
  Widget _buildBodyWidgetOnSnapshotReceived(
    AsyncSnapshot<ValueNotifier<List<Movie>>> snapshot,
  ) {
    if (!snapshot.hasData) {
      showLoadingDialog();
      return Container();
    } else {
      dismissLoading();
      return ValueListenableBuilder<List<Movie>>(
        valueListenable: snapshot.data,
        builder: (BuildContext context, List<Movie> value, Widget child) {
          return _buildMovieListView(value);
        },
      );
    }
  }

  /// List of movies that contains name, poster, release date and adult rating.
  /// list item has an option for user to book tickets,
  ListView _buildMovieListView(List<Movie> movies) {
    var itemCount = movies?.length ?? 0;
    return ListView.builder(
      itemCount: itemCount + 1, // for empty space at the end.
      itemBuilder: (BuildContext context, int index) {
        if (index < movies.length) {
          final Movie movie = movies.elementAt(index);
          final VoidCallback onBookNowClicked =
              () => _showMovieDetailsScreen(context, movie);
          return InkWell(
            child: MovieListItemWidget(movie, onBookNowClicked),
            onTap: onBookNowClicked,
          );
        } else {
          // for empty space at the end so that floating button don't
          // overlap the last item of the list.
          return Container(
            height: 100,
          );
        }
      },
    );
  }

  void _showMovieDetailsScreen(BuildContext context, Movie movie) {
    Navigator.pushNamed(
      context,
      MoviesDetailsWidget.routeName,
      arguments: MovieDetailsViewModel(movie.id),
    );
  }
}

/// This class is used to represent instance of Movie class on UI.
/// Name, poster, release date are represented on this widget.
class MovieListItemWidget extends StatelessWidget {
  final Movie movie;
  final VoidCallback onBookNowClicked;

  const MovieListItemWidget(
    this.movie,
    this.onBookNowClicked, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _posterCard,
        Expanded(
            child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Column(
            children: [
              // title
              _movieTitleText,
              _padding,
              // date
              Text(movie.formattedReleaseDate),
              _padding,
              // is adult
              Text(movie.isAdult ? 'A' : 'U/A')
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        )),
        _bookNowButton,
      ],
    );
  }

  Padding get _bookNowButton => Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlineButton(
          child: Text("Book Now"),
          onPressed: onBookNowClicked,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      );

  Padding get _padding => Padding(padding: const EdgeInsets.all(2.0));

  Text get _movieTitleText => Text(
        movie.title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );

  Card get _posterCard => Card(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Container(
          child: Container(
            width: 70.0,
            height: 100.0,
            child: buildCachedNetworkImage(movie.posterPath),
            // child: Image.network(movie.posterPath),
          ),
        ),
      );
}
