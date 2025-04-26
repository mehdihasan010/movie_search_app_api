import '../../domain/entities/movie_search_result.dart';

class MovieSearchResultModel extends MovieSearchResult {
  const MovieSearchResultModel({
    required String title,
    required String year,
    required String imdbId,
    required String posterUrl,
  }) : super(
          title: title,
          year: year,
          imdbId: imdbId,
          posterUrl: posterUrl,
        );

  factory MovieSearchResultModel.fromJson(Map<String, dynamic> json) {
    return MovieSearchResultModel(
      title: json['Title'] ?? 'N/A',
      year: json['Year'] ?? 'N/A',
      imdbId: json['imdbID'] ?? '',
      posterUrl: (json['Poster'] == null || json['Poster'] == 'N/A')
          ? '' // Provide a placeholder image URL if needed
          : json['Poster'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Year': year,
      'imdbID': imdbId,
      'Poster': posterUrl,
    };
  }
}
