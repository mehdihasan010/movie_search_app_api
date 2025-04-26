import 'package:flutter/material.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/movie_search_result.dart';
import '../../domain/usecases/search_movies.dart';

enum SearchState { initial, loading, loaded, error, loadingMore, noResults }

class MovieSearchProvider extends ChangeNotifier {
  final SearchMovies searchMoviesUseCase;

  MovieSearchProvider({required this.searchMoviesUseCase});

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  List<MovieSearchResult> _movies = [];
  List<MovieSearchResult> get movies => _movies;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _currentQuery = '';
  int _currentPage = 1;
  bool _canLoadMore = true;

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

  void _handleFailure(Failure failure, {bool isLoadingMore = false}) {
    if (failure is NoResultsFailure) {
      _state = SearchState.noResults;
      _errorMessage = failure.message;
    } else if (failure is NetworkFailure) {
      _state = SearchState.error;
      _errorMessage = failure.message;
    } else if (failure is ServerFailure) {
      _state = SearchState.error;
      _errorMessage = failure.message;
    } else {
      _state = SearchState.error;
      _errorMessage = 'An unknown error occurred: ${failure.message}';
    }
    if (isLoadingMore) {
      _state = SearchState.loaded;
      print("Error loading more: $_errorMessage");
      _canLoadMore = false;
    }
  }
}
