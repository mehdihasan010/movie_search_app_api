import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/cached_image_with_shimmer.dart';
import '../providers/movie_detail_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_message_widget.dart';
import '../../data/models/movie_search_result_model.dart';

class MovieDetailPage extends StatefulWidget {
  final String imdbId;

  const MovieDetailPage({super.key, required this.imdbId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    // Fetch details when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailProvider>().fetchMovieDetails(widget.imdbId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final bool isFavorite = favoritesProvider.isFavorite(widget.imdbId);

    return Scaffold(
      appBar: AppBar(
        title: Consumer<MovieDetailProvider>(
          builder: (context, provider, child) {
            if (provider.state == DetailState.loaded &&
                provider.movieDetail != null) {
              return Text(provider.movieDetail!.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis);
            }
            return const Text('Movie Detail');
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Favorite Button
          Consumer<MovieDetailProvider>(
            builder: (context, provider, child) {
              if (provider.state == DetailState.loaded &&
                  provider.movieDetail != null) {
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    final movie = provider.movieDetail!;
                    // Convert movie detail to movie search result for toggling
                    final movieResult = MovieSearchResultModel(
                      title: movie.title,
                      year: movie.year,
                      imdbId: movie.imdbId,
                      posterUrl: movie.posterUrl,
                    );
                    favoritesProvider.toggleFavorite(movieResult);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<MovieDetailProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case DetailState.initial:
            case DetailState.loading:
              return const LoadingWidget();
            case DetailState.error:
              return ErrorMessageWidget(
                message: provider.errorMessage,
                onRetry: () => provider.fetchMovieDetails(widget.imdbId),
              );
            case DetailState.loaded:
              final movie = provider.movieDetail;
              if (movie == null) {
                return const ErrorMessageWidget(
                    message: 'Movie data not available.');
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enlarged Poster
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: CachedImageWithShimmer(
                          imageUrl: movie.posterUrl,
                          borderRadius: BorderRadius.circular(12.0),
                          fit: BoxFit.contain,
                          width: 300,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title and Favorite button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                            size: 30,
                          ),
                          onPressed: () {
                            final movieResult = MovieSearchResultModel(
                              title: movie.title,
                              year: movie.year,
                              imdbId: movie.imdbId,
                              posterUrl: movie.posterUrl,
                            );
                            favoritesProvider.toggleFavorite(movieResult);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Release Year
                    Text(
                      'Release Year: ${movie.year}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),

                    // Description (Plot)
                    Text(
                      'Description:',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.plot,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
