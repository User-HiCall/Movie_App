import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> searchMovies(String query);
  Future<Map<String, dynamic>> getMovieDetails(int movieId);
  Future<void> saveFavorite(Movie movie);
  Future<void> removeFavorite(int movieId);
  List<Movie> getFavorites();
  bool checkIsFavorite(int movieId);
}