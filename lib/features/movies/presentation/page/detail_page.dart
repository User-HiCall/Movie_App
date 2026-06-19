import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/detail_cubit.dart';
import '../bloc/detail_state.dart';

class DetailPage extends StatefulWidget {
  final int movieId;

  const DetailPage({super.key, required this.movieId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailCubit>().loadMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Details')),
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailError) {
            return const Center(child: Text('Failed to load movie details.'));
          } else if (state is DetailLoaded) {
            final movie = state.movieData;
            final backdropUrl = 'https://image.tmdb.org/t/p/w780${movie['backdrop_path']}';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    backdropUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(height: 200, child: Icon(Icons.broken_image)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie['title'] ?? 'Unknown',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text('${(movie['vote_average'] as num).toStringAsFixed(1)}/10', style: const TextStyle(color: Colors.white)),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time, size: 20, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${movie['runtime']} min', style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Storyline',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie['overview'] ?? 'No overview available.',
                          style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
