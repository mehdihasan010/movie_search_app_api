import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/movie_search_result.dart';
import '../../data/models/movie_search_result_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<MovieSearchResult> _favorites = [];
  List<MovieSearchResult> get favorites => List.unmodifiable(_favorites);

  static const String _favoritesKey = 'favorites';
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      _favorites.clear();
      for (final movieJson in favoritesJson) {
        try {
          final movieMap = jsonDecode(movieJson) as Map<String, dynamic>;
          _favorites.add(MovieSearchResultModel.fromJson(movieMap));
        } catch (e) {
          debugPrint('Error parsing favorite movie: $e');
          // Continue loading other favorites even if one fails
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load favorites: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _saveFavorites() async {
    _errorMessage = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favorites.map((movie) {
        if (movie is MovieSearchResultModel) {
          return jsonEncode(movie.toJson());
        }
        final model = MovieSearchResultModel(
          title: movie.title,
          year: movie.year,
          imdbId: movie.imdbId,
          posterUrl: movie.posterUrl,
        );
        return jsonEncode(model.toJson());
      }).toList();

      return await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      _errorMessage = 'Failed to save favorites: $e';
      debugPrint(_errorMessage);
      return false;
    }
  }

  bool isFavorite(String imdbId) {
    return _favorites.any((movie) => movie.imdbId == imdbId);
  }

  Future<bool> toggleFavorite(MovieSearchResult movie) async {
    final isAlreadyFavorite = isFavorite(movie.imdbId);

    if (isAlreadyFavorite) {
      _favorites.removeWhere((m) => m.imdbId == movie.imdbId);
    } else {
      if (movie is! MovieSearchResultModel) {
        movie = MovieSearchResultModel(
          title: movie.title,
          year: movie.year,
          imdbId: movie.imdbId,
          posterUrl: movie.posterUrl,
        );
      }
      _favorites.add(movie);
    }

    notifyListeners();
    return await _saveFavorites();
  }

  Future<bool> removeFavorite(String imdbId) async {
    if (!isFavorite(imdbId)) return true; // Already not a favorite

    _favorites.removeWhere((m) => m.imdbId == imdbId);
    notifyListeners();
    return await _saveFavorites();
  }

  Future<bool> addToFavorites(MovieSearchResult movie) async {
    if (isFavorite(movie.imdbId)) return true; // Already a favorite

    if (movie is! MovieSearchResultModel) {
      movie = MovieSearchResultModel(
        title: movie.title,
        year: movie.year,
        imdbId: movie.imdbId,
        posterUrl: movie.posterUrl,
      );
    }

    _favorites.add(movie);
    notifyListeners();
    return await _saveFavorites();
  }

  Future<void> clearAllFavorites() async {
    _favorites.clear();
    notifyListeners();
    await _saveFavorites();
  }

  void retryLoadFavorites() {
    _loadFavorites();
  }
}
