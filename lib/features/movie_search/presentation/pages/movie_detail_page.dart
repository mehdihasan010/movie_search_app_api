import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_detail_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_message_widget.dart';

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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: movie.posterUrl.isNotEmpty &&
                                  movie.posterUrl != 'N/A'
                              ? Image.network(
                                  movie.posterUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 300,
                                    color: Colors.grey[300],
                                    child: const Center(
                                        child: Icon(
                                            Icons.movie_creation_outlined,
                                            size: 60,
                                            color: Colors.grey)),
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 300,
                                      color: Colors.grey[300],
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  },
                                )
                              : Container(
                                  height: 300,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Center(
                                      child: Icon(Icons.movie_creation_outlined,
                                          size: 60, color: Colors.grey)),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      movie.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
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

                    // Back Button (Alternative)
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back to Search'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
