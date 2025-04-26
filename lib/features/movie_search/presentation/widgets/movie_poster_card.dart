import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/cached_image_with_shimmer.dart';
import '../../domain/entities/movie_search_result.dart';
import '../providers/favorites_provider.dart';

class MoviePosterCard extends StatelessWidget {
  final MovieSearchResult movie;
  final VoidCallback onTap;
  final bool showFavoriteIcon;

  const MoviePosterCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.showFavoriteIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(movie.imdbId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CachedImageWithShimmer(
                    imageUrl: movie.posterUrl,
                    width: 120,
                    height: 140,
                    borderRadius: BorderRadius.circular(8),
                    fit: BoxFit.cover,
                  ),
                ),
                if (showFavoriteIcon)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(movie);
                        },
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            SizedBox(
              width: 120,
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            // Year
            Text(
              movie.year,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
