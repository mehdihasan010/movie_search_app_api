import 'package:equatable/equatable.dart';

class MovieDetail extends Equatable {
  final String title;
  final String year;
  final String plot;
  final String posterUrl;
  final String imdbId;

  const MovieDetail({
    required this.title,
    required this.year,
    required this.plot,
    required this.posterUrl,
    required this.imdbId,
  });

  @override
  List<Object?> get props => [title, year, plot, posterUrl, imdbId];
}
