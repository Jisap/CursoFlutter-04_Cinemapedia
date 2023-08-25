

import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';




// State
final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) { 
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);  // provider basado en la implementación de infraestructure 
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository); // Devuelve un state basado en dicho provider
});



class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  
  int page = 0;                                         // Cargamos la página en la que estamos, valor inicial 0.
  final LocalStorageRepository localStorageRepository;  // Cargamos el repositorio que llama al datasource
  
  StorageMoviesNotifier({
    required this.localStorageRepository
  }): super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 20); //list<Movie> según page
    page++; // Incrementamos page en 1

    final tempMoviesMap = <int, Movie>{}; // Conversión a Map<int, movie>
    for( final movie in movies){
      tempMoviesMap[movie.id] = movie;
    }

    state = { ...state, ...tempMoviesMap }; // Devolución de un state basado en el provider de favoritos desde una página cambiante
  
    return movies;                          // Y devolución de la lista de películas de la bd basado en el provider
  }

  Future<void> toggleFavorite( Movie movie) async{
    await localStorageRepository.toogleFavorite(movie);       // Cargamos la función del provider basado en la implementación de infraestructure
    final bool isMovieInFavorites = state[movie.id] != null;  // Vemos si la película esta en bd(favoritos)

    if( isMovieInFavorites ){                                 // Si esta en favoritos
      state.remove(movie.id);                                 // la borramos 
      state = { ...state };                                   // Spread del state que provoca la rerenderización de la app
    }else{                                                    // Sino esta en favoritos
      state = { ...state, movie.id: movie };                  // agregamos la película al state
    }
  }
}