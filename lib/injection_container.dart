import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Import all layers
import 'features/movie_search/data/datasources/movie_remote_data_source.dart';
import 'features/movie_search/data/repositories/movie_repository_impl.dart';
import 'features/movie_search/domain/repositories/movie_repository.dart';
import 'features/movie_search/domain/usecases/get_movie_details.dart';
import 'features/movie_search/domain/usecases/search_movies.dart';
import 'features/movie_search/presentation/providers/movie_detail_provider.dart';
import 'features/movie_search/presentation/providers/movie_search_provider.dart';
import 'features/movie_search/presentation/providers/home_provider.dart';
import 'features/movie_search/presentation/providers/favorites_provider.dart';
import 'core/network/connectivity_service.dart';

final sl = GetIt.instance; // Service Locator instance

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => ConnectivityService());

  // UseCases
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}

// Helper function to create the list of providers for main.dart
List<SingleChildWidget> createProviders() {
  return [
    ChangeNotifierProvider(
      create: (_) => MovieSearchProvider(searchMoviesUseCase: sl()),
    ),
    // Create MovieDetailProvider here as well, so it's available for the detail page
    ChangeNotifierProvider(
      create: (_) => MovieDetailProvider(getMovieDetailsUseCase: sl()),
    ),
    // Add HomeProvider
    ChangeNotifierProvider(
      create: (_) => HomeProvider(searchMoviesUseCase: sl()),
    ),
    // Add FavoritesProvider
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
    ),
    // Add Network Connectivity Provider
    Provider<ConnectivityService>.value(
      value: sl<ConnectivityService>(),
    ),
  ];
}
