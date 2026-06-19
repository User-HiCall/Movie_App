import '../../domain/entities/movie.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}
class FavoriteLoaded extends FavoriteState {
  final List<Movie> favoriteMovies;
  FavoriteLoaded(this.favoriteMovies);
}