import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/movies/presentation/bloc/auth_cubit.dart';
import 'features/movies/data/datasources/movie_remote_data_source.dart';
import 'features/movies/data/datasources/movie_local_data_source.dart';
import 'features/movies/data/repositories/movie_repositories_impl.dart';
import 'features/movies/presentation/bloc/movie_cubit.dart';
import 'features/movies/presentation/bloc/favorite_cubit.dart';
import 'features/movies/presentation/bloc/search_cubit.dart';
import 'features/movies/presentation/page/login_page.dart';
import 'features/movies/presentation/page/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('favorites_box');

  final httpClient = http.Client();
  final remoteDataSource = MovieRemoteDataSourceImpl(client: httpClient);
  final localDataSource = MovieLocalDataSourceImpl(); // Init Local Source

  // Inject both sources into the Repository
  final movieRepository = MovieRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  runApp(MyApp(movieRepository: movieRepository));
}

class MyApp extends StatelessWidget {
  final MovieRepositoryImpl movieRepository;
  const MyApp({super.key, required this.movieRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MovieCubit(repository: movieRepository)),
        BlocProvider(create: (context) => FavoriteCubit(repository: movieRepository)),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => SearchCubit(repository: movieRepository)),
      ],
      child: MaterialApp(
        title: 'My Movie App',
        theme: ThemeData.dark(),
        home: const LoginPage()
        ,
      ),
    );
  }
}