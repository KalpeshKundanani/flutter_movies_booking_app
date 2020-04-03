import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/tickets/tickets_repository.dart';

class TicketsListViewModel {
  ValueNotifier<List<Movie>> _movieListNotifier;
  final TicketsRepository _moviesRepository = TicketsRepository();

  Future<ValueNotifier<List<Movie>>> get movieTicketsListNotifier async {
    if (_movieListNotifier != null) return _movieListNotifier;
    final List<Movie> movies = await _moviesRepository.readBookedMovieTickets;
    _movieListNotifier = ValueNotifier<List<Movie>>(movies);
    return _movieListNotifier;
  }

  Future bookTicket(Movie movie) async =>
      await _moviesRepository.saveBookedTicket(movie);
}
