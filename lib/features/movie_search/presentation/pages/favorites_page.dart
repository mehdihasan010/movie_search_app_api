import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/movie_list_item.dart';
import 'movie_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: LoadingWidget());
          }

          if (provider.favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on a movie to add it to favorites',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final movie = provider.favorites[index];
              return Dismissible(
                key: Key(movie.imdbId),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  provider.removeFavorite(movie.imdbId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${movie.title} removed from favorites'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () => provider.toggleFavorite(movie),
                      ),
                    ),
                  );
                },
                child: MovieListItem(
                  movie: movie,
                  onTap: () =>
                      _navigateToMovieDetailPage(context, movie.imdbId),
                  showFavoriteIcon: true,
                  isFavorite: true,
                ),
              );
            },
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
}
