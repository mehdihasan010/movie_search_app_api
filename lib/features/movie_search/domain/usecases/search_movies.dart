import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_search_result.dart';
import '../repositories/movie_repository.dart';

class SearchMovies
    implements UseCase<List<MovieSearchResult>, SearchMoviesParams> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<MovieSearchResult>>> call(
      SearchMoviesParams params) async {
    return await repository.searchMovies(params.query, page: params.page);
  }
}

class SearchMoviesParams extends Equatable {
  final String query;
  final int page;

  const SearchMoviesParams({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
}
