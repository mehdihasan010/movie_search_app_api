import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failure.dart';

// Base class for UseCases with parameters
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Use this if your use case doesn't take parameters
abstract class UseCaseWithoutParams<Type> {
  Future<Either<Failure, Type>> call();
}

// Generic NoParams class if needed (often useful)
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
