import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_search_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_message_widget.dart';
import '../widgets/movie_list_item.dart';
import 'movie_detail_page.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({super.key});

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MovieSearchProvider>().loadMoreMovies();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger loading a bit before reaching the absolute end
    return currentScroll >= (maxScroll * 0.9);
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<MovieSearchProvider>().searchMovies(query);
      // Hide keyboard
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search movies by title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
              textInputAction: TextInputAction.search,
            ),
          ),

          // Content Area (List, Loading, Error)
          Expanded(
            child: Consumer<MovieSearchProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case SearchState.initial:
                    return const Center(
                        child: Text('Enter a movie title to search'));
                  case SearchState.loading:
                    return const LoadingWidget();
                  case SearchState.error:
                    return ErrorMessageWidget(
                      message: provider.errorMessage,
                      onRetry: () {
                        final lastQuery = provider.movies.isNotEmpty
                            ? _searchController.text
                            : '';
                        if (lastQuery.isNotEmpty) {
                          provider.searchMovies(lastQuery);
                        } else if (_searchController.text.isNotEmpty) {
                          _performSearch();
                        }
                      },
                    );
                  case SearchState.noResults:
                    return ErrorMessageWidget(message: provider.errorMessage);
                  case SearchState.loadingMore:
                  case SearchState.loaded:
                    if (provider.movies.isEmpty) {
                      return const Center(child: Text('No movies found.'));
                    }
                    // Movie List
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.movies.length +
                          (provider.state == SearchState.loadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.movies.length) {
                          // If it's the extra item and we are loading more, show indicator
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: LoadingWidget(),
                          );
                        }
                        // Build list item
                        final movie = provider.movies[index];
                        return MovieListItem(
                          movie: movie,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MovieDetailPage(imdbId: movie.imdbId),
                              ),
                            );
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
