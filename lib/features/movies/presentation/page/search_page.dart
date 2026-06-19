import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';
import 'detail_page.dart';
import '../bloc/detail_cubit.dart';
import '../bloc/movie_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: (query) {
            context.read<SearchCubit>().search(query);
          },
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(child: Text('Type something to search for movies!'));
          } else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchError) {
            return const Center(child: Text('Error finding movies.'));
          } else if (state is SearchLoaded) {
            if (state.results.isEmpty) {
              return const Center(child: Text('No movies found.'));
            }
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final movie = state.results[index];
                final posterUrl = 'https://image.tmdb.org/t/p/w200${movie.posterPath}';

                return ListTile(
                  leading: movie.posterPath.isNotEmpty
                      ? Image.network(posterUrl, width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.movie, color: Colors.white70),
                  title: Text(movie.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => DetailCubit(
                            repository: context.read<SearchCubit>().repository,
                          ),
                          child: DetailPage(movieId: movie.id),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
