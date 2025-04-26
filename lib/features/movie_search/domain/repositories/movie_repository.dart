import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/movie_detail.dart';
import '../entities/movie_search_result.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieSearchResult>>> searchMovies(String query,
      {int page = 1});
  Future<Either<Failure, MovieDetail>> getMovieDetails(String imdbId);
}
