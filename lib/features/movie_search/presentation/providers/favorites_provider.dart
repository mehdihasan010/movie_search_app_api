import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/movie_search_result.dart';
import '../../data/models/movie_search_result_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<MovieSearchResult> _favorites = [];
  List<MovieSearchResult> get favorites => _favorites;

  static const String _favoritesKey = 'favorites';
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      _favorites.clear();
      for (final movieJson in favoritesJson) {
        final movieMap = jsonDecode(movieJson) as Map<String, dynamic>;
        _favorites.add(MovieSearchResultModel.fromJson(movieMap));
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
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

      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  bool isFavorite(String imdbId) {
    return _favorites.any((movie) => movie.imdbId == imdbId);
  }

  Future<void> toggleFavorite(MovieSearchResult movie) async {
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
    await _saveFavorites();
  }

  Future<void> removeFavorite(String imdbId) async {
    _favorites.removeWhere((m) => m.imdbId == imdbId);
    notifyListeners();
    await _saveFavorites();
  }
}
