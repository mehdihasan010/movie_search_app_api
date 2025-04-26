import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/cached_image_with_shimmer.dart';
import '../../domain/entities/movie_search_result.dart';
import '../providers/favorites_provider.dart';

class MovieListItem extends StatelessWidget {
  final MovieSearchResult movie;
  final VoidCallback onTap;
  final bool showFavoriteIcon;
  final bool? isFavorite;

  const MovieListItem({
    super.key,
    required this.movie,
    required this.onTap,
    this.showFavoriteIcon = false,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider =
        showFavoriteIcon ? Provider.of<FavoritesProvider>(context) : null;

    final isMovieFavorite =
        isFavorite ?? (favoritesProvider?.isFavorite(movie.imdbId) ?? false);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Image
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: CachedImageWithShimmer(
                  imageUrl: movie.posterUrl,
                  width: 80,
                  height: 120,
                  borderRadius: BorderRadius.circular(8),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Title and Year
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Year: ${movie.year}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${movie.imdbId}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Favorite Icon
              if (showFavoriteIcon && favoritesProvider != null)
                IconButton(
                  icon: Icon(
                    isMovieFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isMovieFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(movie);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
