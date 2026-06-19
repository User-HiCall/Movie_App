import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository repository;

  MovieCubit({required this.repository}) : super(MovieInitial());

  Future<void> loadPopularMovies() async {
    try {
      emit(MovieLoading());
      final movies = await repository.getPopularMovies();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError("Could not fetch movies. Check your internet connection."));
    }
  }
}