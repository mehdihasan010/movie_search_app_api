import 'package:flutter/material.dart';
import '../../domain/usecases/search_movies.dart';
import 'movie_search_provider.dart';

class HomeProvider extends ChangeNotifier {
  final SearchMovies searchMoviesUseCase;
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  HomeProvider({required this.searchMoviesUseCase}) {
    scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchTextChanged);
  }

  // Track if search text has changed for UI updates
  String _previousSearchText = '';
  bool get hasSearchQuery => searchController.text.trim().isNotEmpty;

  MovieSearchProvider? _movieSearchProvider;

  void setMovieSearchProvider(MovieSearchProvider provider) {
    _movieSearchProvider = provider;
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchTextChanged);
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    // Only notify listeners if the trimmed search text has changed
    // This avoids unnecessary rebuilds
    final currentText = searchController.text.trim();
    if (currentText != _previousSearchText) {
      _previousSearchText = currentText;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (_isBottom) {
      _movieSearchProvider?.loadMoreMovies();
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    // Trigger loading a bit before reaching the absolute end
    return currentScroll >= (maxScroll * 0.9);
  }

  void loadPopularMovies() {
    // Use a predefined search term for popular movies
    _movieSearchProvider?.searchMovies('marvel');
  }

  void performSearch() {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      _movieSearchProvider?.searchMovies(query);
    }
  }

  void clearSearch() {
    searchController.clear();
    // Consider if you want to reload popular movies or leave current results
    // loadPopularMovies();
  }
}
