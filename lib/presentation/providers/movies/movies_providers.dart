import '../../../domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



                                                      //controlador   data que se controla
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){  // Nos indica los cambios del estado del provider

  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;               // Cuando getNowPlaying sea llamado se obtendrá una lista de movie

  return MoviesNotifier(                                                                    // Se devolverá una "notificación de movies"
    fetchMoreMovies: fetchMoreMovies                                                        // que recibe como argumento la lista de movies
  );
});


final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {    // Provider para peliculas populares
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular; 
  return MoviesNotifier(fetchMoreMovies:fetchMoreMovies );
});

final upComingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {   // Provider para próximas películas
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  // Provider para peliculas topRated
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<Movie>> Function({ int page });                                                                                                 


class MoviesNotifier extends StateNotifier<List<Movie>>{ // Este "notificador" es un controlador que recibe los cambios en la lista y modifica el state
  
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies 
  }): super([]);

  Future<void> loadNextPage() async{ // Modifica la data, osea la lista de movie
    if(isLoading) return;

    isLoading = true;

    currentPage ++;
    final List<Movie> movies = await fetchMoreMovies( page: currentPage );
    state = [...state, ...movies];

    await Future.delayed(const Duration(milliseconds: 300));
    isLoading=false;
  }
  
}