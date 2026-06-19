abstract class DetailState {}

class DetailInitial extends DetailState {}
class DetailLoading extends DetailState {}
class DetailLoaded extends DetailState {
  final Map<String, dynamic> movieData;
  DetailLoaded(this.movieData);
}
class DetailError extends DetailState {}