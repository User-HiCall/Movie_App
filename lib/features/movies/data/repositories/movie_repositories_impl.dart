import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../datasources/movie_local_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource
  });

  @override
  Future<List<Movie>> getPopularMovies() async {
    return await remoteDataSource.fetchPopularMovies();
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      return await remoteDataSource.searchMovies(query);
    } catch (e) {
      throw Exception('Repository error: Search failed.');
    }
  }

  @override
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    try {
    return await remoteDataSource.fetchMovieDetails(movieId);
    } catch (e) {
      throw Exception('Repository error: Could not fetch details for movie $movieId');
    }
  }

  @override
  Future<void> saveFavorite(Movie movie) async {
    final model = MovieModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
    );
    await localDataSource.cacheFavoriteMovie(model);
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    await localDataSource.removeFavoriteMovie(movieId);
  }

  @override
  List<Movie> getFavorites() {
    return localDataSource.getFavoriteMovies();
  }

  @override
  bool checkIsFavorite(int movieId) {
    return localDataSource.isFavorite(movieId);
  }
}