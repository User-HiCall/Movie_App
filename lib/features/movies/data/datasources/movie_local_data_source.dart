import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheFavoriteMovie(MovieModel movie);
  Future<void> removeFavoriteMovie(int movieId);
  List<MovieModel> getFavoriteMovies();
  bool isFavorite(int movieId);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  // Hive stores data inside designated 'Boxes'
  final Box favoriteBox = Hive.box('favorites_box');

  @override
  Future<void> cacheFavoriteMovie(MovieModel movie) async {
    // Convert movie properties into a local JSON string mapping
    final movieData = {
      'id': movie.id,
      'title': movie.title,
      'overview': movie.overview,
      'poster_path': movie.posterPath,
      'vote_average': movie.voteAverage,
    };
    await favoriteBox.put(movie.id, json.encode(movieData));
  }

  @override
  Future<void> removeFavoriteMovie(int movieId) async {
    await favoriteBox.delete(movieId);
  }

  @override
  List<MovieModel> getFavoriteMovies() {
    final List<MovieModel> favorites = [];
    for (var key in favoriteBox.keys) {
      final rawData = favoriteBox.get(key);
      if (rawData != null) {
        final decoded = json.decode(rawData);
        favorites.add(MovieModel.fromJson(decoded));
      }
    }
    return favorites;
  }

  @override
  bool isFavorite(int movieId) {
    return favoriteBox.containsKey(movieId);
  }
}