import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository repository;

  SearchCubit({required this.repository}) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final results = await repository.searchMovies(query);
      emit(SearchLoaded(results));
    } catch (_) {
      emit(SearchError());
    }
  }
}