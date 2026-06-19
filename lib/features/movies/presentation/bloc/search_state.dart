import '../../domain/entities/movie.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<Movie> results;
  SearchLoaded(this.results);
}
class SearchError extends SearchState {}