import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final MovieRepository repository;

  DetailCubit({required this.repository}) : super(DetailInitial());

  Future<void> loadMovieDetails(int movieId) async {
    try {
      emit(DetailLoading());
      final data = await repository.getMovieDetails(movieId);
      emit(DetailLoaded(data));
    } catch (_) {
      emit(DetailError());
    }
  }
}