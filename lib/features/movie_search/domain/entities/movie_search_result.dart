import 'package:equatable/equatable.dart';

class MovieSearchResult extends Equatable {
  final String title;
  final String year;
  final String imdbId;
  final String posterUrl;

  const MovieSearchResult({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.posterUrl,
  });

  @override
  List<Object?> get props => [title, year, imdbId, posterUrl];
}
