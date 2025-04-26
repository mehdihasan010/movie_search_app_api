import 'package:flutter/material.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_details.dart';

enum DetailState { initial, loading, loaded, error }

class MovieDetailProvider extends ChangeNotifier {
  final GetMovieDetails getMovieDetailsUseCase;

  MovieDetailProvider({required this.getMovieDetailsUseCase});

  DetailState _state = DetailState.initial;
  DetailState get state => _state;

  MovieDetail? _movieDetail;
  MovieDetail? get movieDetail => _movieDetail;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchMovieDetails(String imdbId) async {
    _state = DetailState.loading;
    _movieDetail = null;
    _errorMessage = '';
    notifyListeners();

    final result =
        await getMovieDetailsUseCase(GetMovieDetailsParams(imdbId: imdbId));

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          _errorMessage = failure.message;
        } else if (failure is ServerFailure) {
          _errorMessage = failure.message;
        } else {
          _errorMessage = 'An unknown error occurred: ${failure.message}';
        }
        _state = DetailState.error;
      },
      (detail) {
        _movieDetail = detail;
        _state = DetailState.loaded;
      },
    );
    notifyListeners();
  }
}
