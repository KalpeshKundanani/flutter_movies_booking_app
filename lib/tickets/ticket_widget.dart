import 'package:flutter/material.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:flutter_movies_booking_app/movies/movie/movie.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// This widget is used to create ticket UI.
class TicketWidget extends StatelessWidget {
  final Movie movie;

  const TicketWidget({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Ticket(
            innerRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            outerRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [BoxShadow(color: Colors.white)],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(movie.ticketPosterPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  QrImage(
                    data: movie.toString(),
                    version: QrVersions.auto,
                    size: 160.0,
                  )
                ],
              ),
            ),
          ),
          Ticket(
            innerRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
            outerRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
              )
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(movie.title,
                      style: TextStyle(fontSize: 30.0, color: Colors.black)),
                  Text(
                      '${movie.place.city} - ${movie.cinema.name}  |  ${movie.cinema.selectedShowTime}',
                      style: TextStyle(fontSize: 18.0, color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Seats: ${movie.cinema.selectedSeatsAsString}',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
