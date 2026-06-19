import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite_cubit.dart';
import '../bloc/favorite_state.dart';
import 'detail_page.dart';
import '../bloc/detail_cubit.dart';
import '../bloc/movie_cubit.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('My Favorites Movies')),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoaded) {
            if (state.favoriteMovies.isEmpty) {
              return const Center(child: Text('No favorite movies saved yet!'));
            }
            return ListView.builder(
              itemCount: state.favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = state.favoriteMovies[index];
                return ListTile(
                  leading: Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}', width: 50, fit: BoxFit.cover),
                  title: Text(movie.title, style: const TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<FavoriteCubit>().toggleFavorite(movie);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => DetailCubit(repository: context.read<FavoriteCubit>().repository),
                          child: DetailPage(movieId: movie.id),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
