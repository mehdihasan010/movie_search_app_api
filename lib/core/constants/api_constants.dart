class ApiConstants {
  // --- IMPORTANT: Replace with your actual OMDb API Key ---
  static const String omdbApiKey = '6cd945ad';
  // ---------------------------------------------------------

  static const String omdbBaseUrl = 'https://www.omdbapi.com/';

  static String searchUrl(String query, int page) =>
      '$omdbBaseUrl?apikey=$omdbApiKey&s=$query&page=$page&type=movie';

  static String detailUrl(String imdbId) =>
      '$omdbBaseUrl?apikey=$omdbApiKey&i=$imdbId&plot=full';
}
