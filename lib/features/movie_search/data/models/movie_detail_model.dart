import '../../domain/entities/movie_detail.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required String title,
    required String year,
    required String plot,
    required String posterUrl,
    required String imdbId,
  }) : super(
          title: title,
          year: year,
          plot: plot,
          posterUrl: posterUrl,
          imdbId: imdbId,
        );

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      title: json['Title'] ?? 'N/A',
      year: json['Year'] ?? 'N/A',
      plot: json['Plot'] ?? 'No description available.',
      posterUrl: (json['Poster'] == null || json['Poster'] == 'N/A')
          ? '' // Placeholder URL
          : json['Poster'],
      imdbId: json['imdbID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Year': year,
      'Plot': plot,
      'Poster': posterUrl,
      'imdbID': imdbId,
    };
  }
}
