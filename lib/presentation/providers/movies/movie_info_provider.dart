import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';

                                                //controler       dato que devuelve
final movieInfoProvider =StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  // Provider para [String:id, Movie]

  final movieRepository = ref.watch(movieRepositoryProvider);       // Si el provider emite un nuevo valor
                                                                    
  return MovieMapNotifier(getMovie: movieRepository.getMovieById);  // se devuelve la función que obtiene la película por id
});


typedef GetMovieCallback = Future<Movie> Function(String movieId);


class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {  // clase que almacena un observable de un estado inmutable {id,Movie}

  final GetMovieCallback getMovie;                                  // Función que devuelve una pelicula según un id

  MovieMapNotifier({
    required this.getMovie,
  }) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;             // Si existe la película no muestro un loading porque ya esta cargada
    final movie = await getMovie(movieId);          // Sino existe hacemos la petición segun id y la obtenemos
    state = { ...state, movieId: movie };           // Y modificamos el state añadiendo dicha movie
  }
}
