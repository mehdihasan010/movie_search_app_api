import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  const CachedImageWithShimmer({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty || imageUrl == 'N/A') {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildShimmerEffect(),
        errorWidget: errorWidget ??
            (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.movie_creation_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.movie_creation_outlined,
            size: 40,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
