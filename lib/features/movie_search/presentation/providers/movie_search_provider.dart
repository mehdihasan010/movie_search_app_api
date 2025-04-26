import 'package:flutter/material.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/movie_search_result.dart';
import '../../domain/usecases/search_movies.dart';

/// Defines the possible states for the movie search feature
enum SearchState { initial, loading, loaded, error, loadingMore, noResults }

/// Provider that manages movie search functionality, including
/// search operations, pagination, and state management.
class MovieSearchProvider extends ChangeNotifier {
  final SearchMovies searchMoviesUseCase;

  MovieSearchProvider({required this.searchMoviesUseCase});

  /// Current state of the search operation
  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  /// List of movies retrieved from search
  List<MovieSearchResult> _movies = [];
  List<MovieSearchResult> get movies => _movies;

  /// Error message to display when an error occurs
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Current search query
  String _currentQuery = '';

  /// Current page number for pagination
  int _currentPage = 1;

  /// Flag to check if more pages can be loaded
  bool _canLoadMore = true;

  /// Searches for movies with the given query, resetting any previous results
  /// and starting from page 1.
  ///
  /// If [query] is empty, reverts to initial state with empty results.
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _movies = [];
      _state = SearchState.initial;
      _errorMessage = '';
      notifyListeners();
      return;
    }

    _currentQuery = query;
    _currentPage = 1;
    _movies = [];
    _state = SearchState.loading;
    notifyListeners();

    final result = await searchMoviesUseCase(
        SearchMoviesParams(query: _currentQuery, page: _currentPage));

    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (moviesResult) {
        if (moviesResult.isEmpty) {
          _state = SearchState.noResults;
          _errorMessage = 'No movies found for "$_currentQuery"';
        } else {
          _movies = moviesResult;
          _state = SearchState.loaded;
          _canLoadMore = true;
        }
      },
    );
    notifyListeners();
  }

  /// Loads more movies for the current query by incrementing the page number
  /// and appending to the existing movie list.
  ///
  /// Only executes if not already loading more, has a valid query,
  /// and is able to load more.
  Future<void> loadMoreMovies() async {
    if (_state == SearchState.loadingMore ||
        _currentQuery.isEmpty ||
        !_canLoadMore) {
      return;
    }

    _state = SearchState.loadingMore;
    notifyListeners();

    _currentPage++;
    final result = await searchMoviesUseCase(
        SearchMoviesParams(query: _currentQuery, page: _currentPage));

    result.fold(
      (failure) {
        _handleFailure(failure, isLoadingMore: true);
      },
      (newMovies) {
        if (newMovies.isEmpty) {
          _canLoadMore = false;
          _state = SearchState.loaded;
        } else {
          _movies.addAll(newMovies);
          _state = SearchState.loaded;
          _canLoadMore = true;
        }
      },
    );
    notifyListeners();
  }

  /// Handles different types of failures that might occur during
  /// search operations, setting appropriate error messages and states.
  ///
  /// If [isLoadingMore] is true, keeps the loaded state to avoid
  /// hiding already loaded movies when pagination fails.
  void _handleFailure(Failure failure, {bool isLoadingMore = false}) {
    if (failure is NoResultsFailure) {
      _state = SearchState.noResults;
      _errorMessage = failure.message;
    } else if (failure is NetworkFailure) {
      _state = SearchState.error;
      _errorMessage = 'Network error: ${failure.message}';
    } else if (failure is ServerFailure) {
      _state = SearchState.error;
      _errorMessage = 'Server error: ${failure.message}';
    } else {
      _state = SearchState.error;
      _errorMessage = 'An unexpected error occurred: ${failure.message}';
    }

    if (isLoadingMore) {
      _state = SearchState.loaded;
      debugPrint("Error loading more: $_errorMessage");
      _canLoadMore = false;
    }
  }
}
