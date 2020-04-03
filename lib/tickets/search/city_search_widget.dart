import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/tickets/search/cinema_search_widget.dart';
import 'package:flutter_movies_booking_app/tickets/search/cities_repository.dart';
import 'package:flutter_movies_booking_app/utils/utility_widgets.dart';

/// This Widget is used to provide user a facility where they can select
/// any indian city.
/// List of popular cities is shown to the user and they can even search
/// any other city if they want.
/// While creating this widget it is important to pass the movie
/// via named route's argument.
class CitySearchWidget extends StatelessWidget {
  /// Used by the navigator to push this widget on the stack.
  static const String routeName = './CitySearchWidget';

  /// Controller that is used for the search widget.
  final TextEditingController _searchQueryController = TextEditingController();

  /// Used to observe change in search query.
  /// Change in query will change the items in the search result list.
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>("");

  /// The parent widget is supposed to inject the dependency of
  /// Movie to create this widget.
  /// This method will fetch that passed Movie from the Navigator and
  /// will return.
  Movie _getMovie(BuildContext context) =>
      ModalRoute.of(context).settings.arguments;

  @override
  Widget build(BuildContext context) {
    final Movie movie = _getMovie(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: _buildBody(movie, context),
    );
  }

  /// Creates the background as the blurred poster image and
  /// content is overlaying on this blurred background.
  Stack _buildBody(Movie movie, BuildContext context) =>
      Stack(fit: StackFit.expand, children: <Widget>[
        buildCachedNetworkImage(movie.posterPath),
        blurScreen(context),
        _buildContent(),
      ]);

  /// Observes the change in the places list that is being loaded from
  /// the assets.
  /// initially when it is empty the loading UI is shown to user.
  /// when the places are loaded from the assets list of popular cities is
  /// shown to user.
  FutureBuilder<List<Place>> _buildContent() => FutureBuilder<List<Place>>(
        future: fetchPlaces(),
        builder: (BuildContext context, AsyncSnapshot<List<Place>> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: loadingSpinKit(),
            );
          // observe change in search query.
          return ValueListenableBuilder<String>(
            valueListenable: _searchQueryNotifier,
            builder: (_, final String searchQuery, __) {
              // When the search query is not entered or is cleared
              // the list of popular cities is shown to user.
              if (searchQuery == null || searchQuery.isEmpty) {
                return _buildPopularCitiesWidget(context);
              }

              // when some search query is entered we take all the cities.
              final List<Place> placesList = snapshot.data;
              // filter cities according to the name.
              final places = _searchPlaces(placesList, searchQuery);
              // we build the search result list that is having the list
              // of cities that are filtered according to search query.
              return _buildCitySearchResultsWidget(places);
            },
          );
        },
      );

  /// Creates the app bar that supports search bar.
  /// and has an option to go to previous screen using back button.
  AppBar _buildAppBar(BuildContext context) => AppBar(
        leading: const BackButton(),
        title: _buildSearchField(),
        actions: _buildAppBarActions(context),
      );

  /// this will filter and return the list of places that match the
  /// search query.
  List<Place> _searchPlaces(List<Place> placesList, String searchQuery) =>
      placesList.where((Place place) => place.query(searchQuery)).toList();

  /// The list of searched cities whose background is translucent.
  Widget _buildCitySearchResultsWidget(List<Place> places) {
    return containerWithTranslucentBackground(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (BuildContext context, int index) {
            var place = places.elementAt(index);
            return _buildSearchResultListItem(place, context);
          },
        ),
      ),
    );
  }

  /// An item that is clickable and has the name, district and state's name
  /// of the searched city.
  Widget _buildSearchResultListItem(Place place, BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(place.city, style: textTheme.title),
            Text(
              '${place.district}  -  ${place.state}',
              style: textTheme.subtitle,
            ),
          ],
        ),
      ),
      onTap: () => _onPlaceClicked(context, place),
    );
  }

  /// This will show the cinema and show time selection screen.
  void _onPlaceClicked(BuildContext context, Place place) {
    final Movie movie = _getMovie(context);
    movie.place = place;
    Navigator.pushNamed(
      context,
      CinemaSearchWidget.routeName,
      arguments: movie,
    );
  }

  /// This is used to give users the quick access to the cities
  /// which are popularly selected.
  Widget _buildPopularCitiesWidget(BuildContext context) => Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: containerWithTranslucentBackground(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Popular Cities',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Wrap(
                  children: popularCities.map((Place place) {
                    return _buildCityChip(context, place);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );

  /// Will create an InputChip which when clicked will show the
  /// Cinema and show time selection page.
  Padding _buildCityChip(BuildContext context, Place place) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: InputChip(
          padding: const EdgeInsets.all(2.0),
          label: Text(place.city),
          onPressed: () {
            _onPlaceClicked(context, place);
          },
        ),
      );

  /// Will create a search view wher user can enter the search query to find
  /// the city.
  Widget _buildSearchField() => TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search Cities...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.only(left: 16, right: 16),
      ),
      onChanged: (query) => updateSearchQuery(query),
    );

  /// Will create the cross button which will be used ot clear the
  /// search query, if user has not entered any query then it will take
  /// user back to the movies details page.
  List<Widget> _buildAppBarActions(BuildContext context) => <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (_searchQueryController == null ||
              _searchQueryController.text.isEmpty) {
            Navigator.pop(context);
            return;
          }
          _clearSearchQuery();
        },
      ),
    ];

  /// This will notify the search query listeners that the query is changed.
  /// by this new UI according to new query is supposed to be
  /// inflated.
  void updateSearchQuery(String newQuery) =>
      _searchQueryNotifier.value = newQuery;

  /// Will clear the search field and will clear the search results.
  void _clearSearchQuery() {
    _searchQueryController.clear();
    updateSearchQuery("");
  }
}
