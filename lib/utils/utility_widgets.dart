import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Shows a loading widget.
Widget loadingSpinKit() {
  return SpinKitWave(
    color: Colors.white,
    size: 20,
  );
}

/// Used to show network images, once image is loaded using this
/// widget it is cached and can be accessible in offline mode.
CachedNetworkImage buildCachedNetworkImage(
  posterPath, {
  BorderRadius borderRadius = BorderRadius.zero,
}) {
  return CachedNetworkImage(
    imageUrl: posterPath,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    placeholder: (context, url) => loadingSpinKit(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

/// This method will show a loading dialog once the widget tree is built.
void showLoadingDialog() => WidgetsBinding.instance.addPostFrameCallback(
      (_) => EasyLoading.show(
        status: 'loading...',
      ),
    );

/// This method will dismiss the dialog once the widget tree is built.
void dismissLoading() =>
    WidgetsBinding.instance.addPostFrameCallback((_) => EasyLoading.dismiss());

/// Creates a full blur screen which can be placed on
/// poster image that is at the background of the screen.
Widget blurScreen(BuildContext context) => BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Theme.of(context).primaryColorDark.withOpacity(0.5),
      ),
    );

/// This is used to create container that will have black background with
/// 50% opacity.
Container containerWithTranslucentBackground({
  final EdgeInsetsGeometry padding = const EdgeInsets.all(.0),
  final EdgeInsetsGeometry margin = const EdgeInsets.all(.0),
  final Widget child,
}) =>
    Container(
      padding: padding,
      margin: margin,
      child: child,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.5)),
    );
