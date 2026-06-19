import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/entities/movie.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final MovieRepository repository;

  FavoriteCubit({required this.repository}) : super(FavoriteInitial());

  void loadFavorites() {
    final list = repository.getFavorites();
    emit(FavoriteLoaded(list));
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (repository.checkIsFavorite(movie.id)) {
      await repository.removeFavorite(movie.id);
    } else {
      await repository.saveFavorite(movie);
    }
    loadFavorites(); // Refresh local list state
  }
}