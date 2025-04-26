import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_search_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_message_widget.dart';
import '../widgets/movie_list_item.dart';
import '../widgets/movie_poster_card.dart';
import 'movie_detail_page.dart';
import 'movie_search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the HomeProvider with the MovieSearchProvider
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final movieSearchProvider =
        Provider.of<MovieSearchProvider>(context, listen: false);

    // Set up connection between providers
    homeProvider.setMovieSearchProvider(movieSearchProvider);

    // Load popular movies when the page is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider.loadPopularMovies();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _navigateToSearchPage(context),
          ),
        ],
      ),
      body: Consumer<MovieSearchProvider>(
        builder: (context, provider, child) {
          if (provider.state == SearchState.initial ||
              provider.state == SearchState.loading) {
            return const Center(child: LoadingWidget());
          }

          if (provider.state == SearchState.error) {
            return ErrorMessageWidget(
              message: provider.errorMessage,
              onRetry: homeProvider.loadPopularMovies,
            );
          }

          if (provider.movies.isEmpty) {
            return const Center(child: Text('No movies available'));
          }

          return SingleChildScrollView(
            controller: homeProvider.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: homeProvider.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search movies by title...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          homeProvider.performSearch();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    onSubmitted: (_) {
                      homeProvider.performSearch();
                      FocusScope.of(context).unfocus();
                    },
                    textInputAction: TextInputAction.search,
                  ),
                ),

                // Popular Movies (Horizontal Scrolling Cards)
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Popular Movies',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.movies.length > 10
                        ? 10
                        : provider.movies.length,
                    itemBuilder: (context, index) {
                      final movie = provider.movies[index];
                      return MoviePosterCard(
                        movie: movie,
                        onTap: () =>
                            _navigateToMovieDetailPage(context, movie.imdbId),
                      );
                    },
                  ),
                ),

                // All Movies (Vertical List)
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Text(
                    'All Movies',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.movies.length,
                  itemBuilder: (context, index) {
                    final movie = provider.movies[index];
                    return MovieListItem(
                      movie: movie,
                      onTap: () =>
                          _navigateToMovieDetailPage(context, movie.imdbId),
                    );
                  },
                ),

                // Loading indicator for more movies
                if (provider.state == SearchState.loadingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: LoadingWidget()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToMovieDetailPage(BuildContext context, String imdbId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(imdbId: imdbId),
      ),
    );
  }

  void _navigateToSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MovieSearchPage(),
      ),
    );
  }
}
