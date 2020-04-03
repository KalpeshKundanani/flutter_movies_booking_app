import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movies_booking_app/movies/movies_details/movies_details_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// This widget is used to display youtube player in the landscape mode.
/// When the video ends this player is closed and user is returned back to
/// Movies details widget.
/// After video starts user has an option to close video and move to
/// Movies details widget by pressing done button or the back button.
class YoutubePlayerWidget extends StatefulWidget {
  /// Used by the navigator to push this widget on the stack.
  static const routeName = '/YoutubePlayerWidget';

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

/// State of the YoutubePlayerWidget.
class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  YoutubePlayerController _controller;

  /// The parent widget is supposed to inject the dependency of
  /// youtube id as String to create this widget.
  /// This method will fetch that passed Youtube id from the Navigator and
  /// will return.
  String _getYoutubeVideoId(BuildContext context) =>
      ModalRoute.of(context).settings.arguments;

  @override
  void initState() {
    super.initState();

    /// setting proffered orientation to landscape.
    /// This is done because full screen mode used to toggle after
    /// video used to start and till then the player was visible
    /// in portrait mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Returns the initialized YoutubeController, if an instance is not
  /// initialized then it is initialized and returned.
  /// the instance will auto play the video.
  YoutubePlayerController _getYoutubeController(BuildContext context) {
    if (_controller != null) return _controller;
    _controller = YoutubePlayerController(
      initialVideoId: _getYoutubeVideoId(context),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHideAnnotation: false,
        hideControls: false,
        hideThumbnail: false,
        controlsVisibleAtStart: true,
      ),
    )..addListener(() {
        final currentPlayerState = _controller.value.playerState;
        if (currentPlayerState == PlayerState.ended) {
          pop(context);
        } else if (currentPlayerState == PlayerState.unStarted) {
          _controller.play();
        }
      });
    return _controller;
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    try {
      /// When this screen is closed then we will reset all the
      /// orientations.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);

      /// Youtube player hides the status and navigation bar so
      /// when it is closed we will show them again.
      SystemChrome.setEnabledSystemUIOverlays([
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ]);
      _controller.dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = _getYoutubeController(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OrientationBuilder(
        builder: (_, final Orientation orientation) {
          _closeIfBackFromLandscape(context, orientation);
          return _buildYoutubePlayer(context);
        },
      ),
    );
  }

  /// Builds an youtube player that will be shown in the landscape UI.
  YoutubePlayer _buildYoutubePlayer(BuildContext context) => YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).accentColor,
        topActions: _buildYoutubePlayerActions(context),
        onReady: _onReady,
        onEnded: (id) => pop(context),
      );

  /// When youtube player is ready we make it full screen.
  void _onReady() => WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller.toggleFullScreenMode();
      });

  /// For giving user an option to close the youtube player when from the
  /// player.
  List<Widget> _buildYoutubePlayerActions(BuildContext context) => <Widget>[
        FloatingActionButton.extended(
          onPressed: () {
            pop(context);
          },
          label: Text('Done'),
        ),
      ];

  /// We want to show youtube player only in Landscape mode,
  /// if user is coming from landscape to portrait made it means
  /// they have pressed back button and want to go back to the previous
  /// widget so we send them to the MoviesDetailsWidget.
  void _closeIfBackFromLandscape(
      BuildContext context, Orientation orientation) {
    final bool isBackFromLandscapeYoutubePlayer =
        _controller.value.hasPlayed && orientation == Orientation.portrait;
    if (isBackFromLandscapeYoutubePlayer) {
      _controller.pause();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pop(context);
      });
    }
  }

  /// Will pop the current screen.
  void pop(BuildContext context) => Navigator.popUntil(
        context,
        ModalRoute.withName(MoviesDetailsWidget.routeName),
      );
}
