

import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

final searchQueryProvider = StateProvider<String>((ref) => ''); // Estado para un query



                                                      //notifier          //state
final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref){ 
// Este provider nos da el nuevo estado de List<Movie> y actualiza el estado del query  


  final movieRepository = ref.read(movieRepositoryProvider);  // Exponemos la función de busqueda según query 

  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies,
    ref: ref
  );
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);




class SearchedMoviesNotifier extends StateNotifier<List<Movie>>{  // Notificador del cambio de estado de una List<Movie>

  final SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref
  }): super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async{        // Cuando se recibe un query

    final List<Movie> movies = await searchMovies(query);             // la lista de movie cambia
    ref.read(searchQueryProvider.notifier).update((state) => query);  // se cambia el estado del query

    state = movies;                                                   // Se guarda la lista de la última busqueda

    return movies;                                                    // Se notifica la nueva lista
  }

}