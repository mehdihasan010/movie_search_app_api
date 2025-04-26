class AppConstants {
  // API related constants
  static const String apiBaseUrl = 'http://www.omdbapi.com/';
  static const int defaultPageSize = 10;
  static const double paginationTriggerRatio =
      0.9; // Scroll percentage to trigger pagination

  // UI related constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultCardElevation = 3.0;
  static const double posterCardWidth = 120.0;
  static const double posterCardHeight = 140.0;
  static const double movieListItemHeight = 120.0;
  static const double movieListItemWidth = 80.0;

  // Storage keys
  static const String favoritesStorageKey = 'favorites';

  // Default search terms
  static const String defaultPopularMoviesSearch = 'marvel';
}

class ApiEndpoints {
  static const String search = '';
  static const String movieDetails = '';
}

class ErrorMessages {
  static const String networkError =
      'Unable to connect. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String noResults = 'No movies found for your search.';
  static const String defaultError = 'Something went wrong. Please try again.';
  static const String loadFavoritesError =
      'Failed to load favorites. Please try again.';
}
