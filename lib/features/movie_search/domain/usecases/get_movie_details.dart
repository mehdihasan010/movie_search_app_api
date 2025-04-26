import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails implements UseCase<MovieDetail, GetMovieDetailsParams> {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, MovieDetail>> call(
      GetMovieDetailsParams params) async {
    return await repository.getMovieDetails(params.imdbId);
  }
}

class GetMovieDetailsParams extends Equatable {
  final String imdbId;

  const GetMovieDetailsParams({required this.imdbId});

  @override
  List<Object?> get props => [imdbId];
}
