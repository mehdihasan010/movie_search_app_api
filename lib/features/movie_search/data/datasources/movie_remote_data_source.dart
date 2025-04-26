import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_search_result_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieSearchResultModel>> searchMovies(String query, int page);
  Future<MovieDetailModel> getMovieDetails(String imdbId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieSearchResultModel>> searchMovies(
      String query, int page) async {
    final url = Uri.parse(ApiConstants.searchUrl(query, page));
    try {
      final response =
          await client.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['Response'] == 'True') {
          final List results = jsonResponse['Search'];
          return results
              .map((movieJson) => MovieSearchResultModel.fromJson(movieJson))
              .toList();
        } else if (jsonResponse['Error'] == 'Movie not found!') {
          // Handle case where API returns success but no movies found
          return []; // Return empty list for "Movie not found"
        } else {
          // Handle other API errors reported in the 'Error' field
          throw ServerException(
              message:
                  jsonResponse['Error'] ?? 'Unknown API error during search');
        }
      } else {
        // Handle HTTP errors (4xx, 5xx)
        throw ServerException(
            message:
                'Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network errors or JSON parsing errors
      if (e is ServerException) rethrow; // Propagate known server exceptions
      print("Error during searchMovies API call: $e"); // Log the actual error
      throw ServerException(
          message:
              'Failed to fetch search results. Check connection or API response.');
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetails(String imdbId) async {
    final url = Uri.parse(ApiConstants.detailUrl(imdbId));
    try {
      final response =
          await client.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['Response'] == 'True') {
          return MovieDetailModel.fromJson(jsonResponse);
        } else {
          throw ServerException(
              message: jsonResponse['Error'] ??
                  'Unknown API error fetching details');
        }
      } else {
        throw ServerException(
            message:
                'Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      print("Error during getMovieDetails API call: $e");
      throw ServerException(
          message:
              'Failed to fetch movie details. Check connection or API response.');
    }
  }
}
