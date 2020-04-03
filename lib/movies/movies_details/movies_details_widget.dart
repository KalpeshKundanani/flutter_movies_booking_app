import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/models/genre/genre.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/movie_details_view_model.dart';
import 'package:flutter_movies_booking_app/tickets/search/city_search_widget.dart';
import 'package:flutter_movies_booking_app/utils/utility_widgets.dart';
import 'package:flutter_movies_booking_app/youtube_player/youtube_player_widget.dart';

/// This widget is used to show user the details of the movie like:
/// Movie Title, Overview, Rating, Trailer, Images. This widget also
/// gives user an option to book movie tickets.
class MoviesDetailsWidget extends StatelessWidget {
  /// Used by the navigator to push this widget on the stack.
  static const routeName = './MoviesDetailsWidget';

  /// The parent widget is supposed to inject the dependency of
  /// MovieDetailsViewModel to create this widget.
  /// This method will fetch that passed ViewModel from the Navigator and
  /// will return.
  MovieDetailsViewModel _getMovieDetailsViewModel(BuildContext context) =>
      ModalRoute.of(context).settings.arguments;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: _body(context),
      );

  /// Observes view model, when data is changed this will rebuild the
  /// movie details widget. Initially there will be not data so loading
  /// will be shown. When data will be updated in ViewModel
  /// the UI will consume it.
  FutureBuilder<ValueNotifier<Movie>> _body(final BuildContext context) {
    final MovieDetailsViewModel viewModel = _getMovieDetailsViewModel(context);
    return FutureBuilder<ValueNotifier<Movie>>(
      future: viewModel.movieNotifier,
      builder: (_, final AsyncSnapshot<ValueNotifier<Movie>> snapshot) {
        if (snapshot.hasData) {
          dismissLoading();
          return ValueListenableBuilder<Movie>(
            valueListenable: snapshot.data,
            builder: (_, final Movie value, __) =>
                _buildMovieDetailsWidget(context, value),
          );
        }

        showLoadingDialog();
        return Container();
      },
    );
  }

  /// Will create the Layout of the complete screen.
  Widget _buildMovieDetailsWidget(
    final BuildContext context,
    final Movie movie,
  ) {
    final viewModel = _getMovieDetailsViewModel(context);
    final ThemeData theme = Theme.of(context);
    final posterPath = movie.posterPath;
    return Stack(fit: StackFit.expand, children: <Widget>[
      buildCachedNetworkImage(posterPath),
      blurScreen(context),
      OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.portrait) {
            return _buildMovieDetailsPortraitView(viewModel, movie, theme);
          } else {
            return _buildMovieDetailsLandscapeView(viewModel, movie, theme);
          }
        },
      ),
      _buildBottomButtonRow(context, movie),
    ]);
  }

  /// Will create a view where all the elements are arranged
  /// from top to bottom in a List.
  Widget _buildMovieDetailsPortraitView(
    final MovieDetailsViewModel viewModel,
    final Movie movie,
    final ThemeData theme,
  ) =>
      ListView(
        children: <Widget>[
          _buildImageSlider(viewModel),
          _buildTitleWidget(movie, viewModel, theme),
          _buildOverviewWidget(movie),
        ],
      );

  /// Will create a view where image slider will be at the left
  /// buttons will be in bottom center
  /// rest of the details will be on the right.
  Widget _buildMovieDetailsLandscapeView(
    final MovieDetailsViewModel viewModel,
    final Movie movie,
    final ThemeData theme,
  ) =>
      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Expanded(child: _buildImageSlider(viewModel)),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _buildTitleWidget(movie, viewModel, theme),
              _buildOverviewWidget(movie),
            ],
          ),
        )
      ]);

  /// Will create a row of buttons that are used to watch trailer and
  /// book tickets.
  /// the buttons will be aligned in bottom center of the screen.
  Align _buildBottomButtonRow(
    final BuildContext context,
    final Movie movie,
  ) =>
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildWatchTrailerButton(context),
              _buildBookNowButton(context, movie),
            ],
          ),
        ),
      );

  /// This button is used ot launch the place selection UI. This button
  /// basically starts the booking process.
  Widget _buildBookNowButton(BuildContext context, Movie movie) =>
      _buildExpandedFloatingButton(
        Icon(Icons.payment),
        context,
        'Book Now',
        () => _onBookNowClicked(context, movie),
      );

  /// Launch the next screen for place search. Initiate the booking
  /// process.
  void _onBookNowClicked(BuildContext context, Movie movie) =>
      Navigator.pushNamed(
        context,
        CitySearchWidget.routeName,
        arguments: movie,
      );

  /// This will create a text view that has maximum 5 lines.
  /// if the content needs more than 5 lines then this text view will show
  /// ellipsis at the end of the text.
  Padding _buildOverviewWidget(Movie movie) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          movie.overview,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: TextStyle(fontSize: 20),
        ),
      );

  /// This widget contains movie title, rating, genres and release date.
  /// It is the title widget of the screen as it gives the most information
  /// at a glance.
  Padding _buildTitleWidget(
    Movie movie,
    MovieDetailsViewModel viewModel,
    ThemeData theme,
  ) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildMovieTitle(movie),
                  _buildGenreText(viewModel, movie, theme),
                  _buildReleaseDateText(movie, theme),
                ],
              )),
              _buildMovieRatingWidget(movie),
            ],
          ),
        ),
      );

  /// Creates a widget that shows movie rating out of 10.
  Container _buildMovieRatingWidget(final Movie movie) =>
      containerWithTranslucentBackground(
        padding: EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(Icons.star, color: Colors.yellow),
            ),
            Text('${movie.rating}', style: TextStyle(fontSize: 24.0)),
            Text('/10 TMDB', style: TextStyle(fontSize: 12.0)),
          ],
        ),
      );

  /// Builds a widget that shows the formatted release date of the movie
  /// to user.
  Padding _buildReleaseDateText(Movie movie, ThemeData theme) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          'Released on: ${movie.formattedReleaseDate}',
          style: theme.textTheme.subtitle,
        ),
      );

  /// Builds a text that shows genres classification of the movie to the user.
  /// e.g: Action | Comedy and etc.
  Padding _buildGenreText(
    final MovieDetailsViewModel viewModel,
    final Movie movie,
    final ThemeData theme,
  ) =>
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: FutureBuilder<ValueNotifier<List<Genre>>>(
          future: viewModel.genreListNotifier,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ValueListenableBuilder<List<Genre>>(
                valueListenable: snapshot.data,
                builder:
                    (BuildContext context, List<Genre> value, Widget child) {
                  String genreString = _getGenreString(movie.genreIds, value);
                  return Text(genreString, style: theme.textTheme.subtitle);
                },
              );
            }
            return loadingSpinKit();
          },
        ),
      );

  /// Builds the title widget that shows movie title to the user.
  Text _buildMovieTitle(Movie movie) => Text(
        movie.title,
        style: TextStyle(fontSize: 30.0),
      );

  /// Builds an Image slider with dots at the bottom representing page number.
  /// This Image slider slides images automatically.
  /// This slider observes image list in ViewModel, any change in the list
  /// of images in the view model will be reflected on this UI.
  Padding _buildImageSlider(MovieDetailsViewModel viewModel) => Padding(
        padding: const EdgeInsets.only(top: 64, bottom: 32),
        child: FutureBuilder<ValueNotifier<List<String>>>(
          future: viewModel.movieImagesNotifier,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ValueListenableBuilder<List<String>>(
                valueListenable: snapshot.data,
                builder: (_, final List<String> value, __) {
                  return value != null
                      ? CarouselWithIndicator(value)
                      : loadingSpinKit();
                },
              );
            }
            return loadingSpinKit();
          },
        ),
      );

  /// This button launches the Youtube player.
  /// Initially when the youtube id is not yet fetched from the
  /// api this button will show a loading UI, when the URL is fetched this
  /// button will show watch trailer text.
  Widget _buildWatchTrailerButton(final BuildContext context) {
    final viewModel = _getMovieDetailsViewModel(context);
    // initialises field that holds youtube key in view model.
    return FutureBuilder<ValueNotifier<String>>(
      future: viewModel.movieTrailerNotifier,
      builder: (_, final AsyncSnapshot<ValueNotifier<String>> snapshot) {
        if (snapshot.hasData) {
          // observes change field that holds youtube key in view model.
          return ValueListenableBuilder<String>(
            valueListenable: snapshot.data,
            builder: (_, final String youtubeKey, __) =>
                _buildExpandedFloatingButton(
              Icon(Icons.play_arrow),
              context,
              'Watch Trailer',
              () => _onWatchTrailerClicked(context, youtubeKey),
            ),
          );
        }
        return _buildExpandedFloatingButton(
          loadingSpinKit(),
          context,
          'Watch Trailer',
          null,
        );
      },
    );
  }

  /// Will launch the widget that will play the youtube video
  /// using provided youtubeKey.
  void _onWatchTrailerClicked(
    final BuildContext context,
    final String youtubeKey,
  ) =>
      Navigator.pushNamed(
        context,
        YoutubePlayerWidget.routeName,
        arguments: youtubeKey,
      );

  /// This button can only be used in Row or Column, it will take the
  /// whole size that is available in the parent.
  Widget _buildExpandedFloatingButton(
    final Widget icon,
    final BuildContext context,
    final String buttonText,
    final VoidCallback onPressed,
  ) {
    final ThemeData theme = Theme.of(context);
    // .2 opacity will give an effect that button is disabled.
    final double opacity = onPressed != null ? .5 : .2;
    final buttonColor = theme.accentColor.withOpacity(opacity);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          heroTag: buttonText,
          icon: icon,
          backgroundColor: buttonColor,
          onPressed: onPressed,
          label: Text(
            buttonText.toUpperCase(),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  /// This is used to map the movie's genre ids with the genre values.
  /// String with all the genre values separated by | operator will be
  /// returned.
  String _getGenreString(List<int> genreIds, List<Genre> availableGenres) {
    // empty list.
    final List<String> genreNames = <String>[];
    // iterating all genres of current movie.
    genreIds.forEach((int genreId) {
      try {
        final Genre matchedGenre = availableGenres.firstWhere((Genre genre) {
          return genre.id == genreId;
        });
        if (matchedGenre != null) {
          // matched Genre from genreId.
          genreNames.add(matchedGenre.name);
        }
      } catch (e) {
        // when no such element is found in availableGenres.
      }
    });
    return genreNames.join(' | ');
  }
}

/// This widget is used to create Image slider that will have page
/// indicators at the bottom.
/// this slider will slide automatically.
class CarouselWithIndicator extends StatelessWidget {
  CarouselWithIndicator(
    this.imagesURLs, {
    Key key,
  }) : super(key: key);

  /// urls from where images will be downloaded and inflated in the slider.
  final List<String> imagesURLs;

  /// index of current image that is visible in the center.
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) => Column(children: [
        _buildImageSlider(),
        _buildPageIndicator(),
      ]);

  /// This will create the Image slider that will auto slide and will have
  /// the center page enlarged.
  /// Following slider's call back will change the value of dots at the
  /// bottom of this widget.
  CarouselSlider _buildImageSlider() => CarouselSlider(
        items: _buildImageSliderItem(imagesURLs),
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.2,
        onPageChanged: (index) => _pageIndexNotifier.value = index,
      );

  /// This widget is used to create the page indicator UI where all
  /// the dots will be arranged horizontally and the dot whose index
  /// matches current page number will be having different color
  /// then all other dots.
  ValueListenableBuilder<int> _buildPageIndicator() => ValueListenableBuilder(
        valueListenable: _pageIndexNotifier,
        builder: (_, final int currentIndex, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(
            imagesURLs,
            (index, url) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        currentIndex == index ? Colors.white : Colors.white30),
              );
            },
          ),
        ),
      );

  /// An image in the image slider.
  List<Widget> _buildImageSliderItem(List<String> imgList) => map<Widget>(
        imgList,
        (index, imageURL) => containerWithTranslucentBackground(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: buildCachedNetworkImage(imageURL),
          ),
        ),
      ).toList();

  /// Map operator that provides index will mapping.
  List<T> map<T>(List list, Function handler) {
    final List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
}
