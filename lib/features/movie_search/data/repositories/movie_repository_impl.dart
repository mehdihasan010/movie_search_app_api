import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/movie_search_result.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<MovieSearchResult>>> searchMovies(String query,
      {int page = 1}) async {
    try {
      final remoteMovies = await remoteDataSource.searchMovies(query, page);
      if (remoteMovies.isEmpty && page == 1) {
        // Explicitly handle the case where the API returns an empty list for the first page search
        return Left(NoResultsFailure(message: 'No movies found for "$query"'));
      }
      return Right(remoteMovies);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      // Catch other potential exceptions during the process
      print("Unexpected error in searchMovies Repository: $e");
      return Left(ServerFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetails(String imdbId) async {
    try {
      final remoteDetail = await remoteDataSource.getMovieDetails(imdbId);
      return Right(remoteDetail);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      print("Unexpected error in getMovieDetails Repository: $e");
      return Left(ServerFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
