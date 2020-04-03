import 'package:flutter/material.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:flutter_movies_booking_app/tickets/ticket_list_view_model.dart';
import 'package:flutter_movies_booking_app/tickets/ticket_widget.dart';

/// This widget is used to show user their selected tickets.
class TicketSListWidget extends StatefulWidget {
  static const String routeName = './TicketSListWidget';

  @override
  _TicketSListWidgetState createState() => _TicketSListWidgetState();
}

class _TicketSListWidgetState extends State<TicketSListWidget> {
  final TicketsListViewModel _viewModel = TicketsListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Your Tickets'),
      ),
      body: FutureBuilder(
        future: _viewModel.movieTicketsListNotifier,
        builder: (BuildContext context,
            AsyncSnapshot<ValueNotifier<List<Movie>>> snapshot) {
          if (!snapshot.hasData) return Container();
          return ValueListenableBuilder(
            valueListenable: snapshot.data,
            builder:
                (BuildContext context, List<Movie> movieTickets, Widget child) {
              if (movieTickets == null || movieTickets.isEmpty)
                return Center(
                  child: Text(
                    'No tickets found.',
                    style: Theme.of(context).textTheme.title,
                  ),
                );
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemCount: movieTickets.length,
                itemBuilder: (context, index) {
                  final Movie movie = movieTickets.elementAt(index);
                  return TicketWidget(
                    movie: movie,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
