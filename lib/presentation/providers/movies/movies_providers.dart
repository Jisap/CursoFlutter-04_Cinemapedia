import '../../../domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



                                                      //controlador   data que se controla
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){  // Nos indica los cambios del estado del provider

  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying; // Cuando getNowPlaying sea llamado se obtendrá una lista de movie

  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies // Esa lista de movie se notificará
  );
});

typedef MovieCallback = Future<List<Movie>> Function({ int page });                                                                                                 


class MoviesNotifier extends StateNotifier<List<Movie>>{ // Controlador que recibe los cambios y modifica el state
  
  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies 
  }): super([]);

  Future<void> loadNextPage() async{ // Modifica la data, osea la lista de movie
    currentPage ++;
    final List<Movie> movies = await fetchMoreMovies( page: currentPage );
    state = [...state, ...movies];
  }
  
}