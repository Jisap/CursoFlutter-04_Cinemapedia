import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

import '../../config/helpers/human_formats.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallback searchMovies; // Función que devuelve una lista de movies según un query y que se envio desde el Custom_appbar
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast(); // Listener para varios eventos de peticiones de busqueda que almacena los rdos de busqueda
  StreamController<bool> isLoadingStream = StreamController.broadcast(); // Listener que devuelve un bool según este o no cargando datos en el stream
  Timer? _debounceTimer; // Esto es como un setTimeOut
  List<Movie> initialMovies;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies
  });

  void clearStreams() {                 // Función que limpia el contenido del stream de la memoria del dispositivo
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {  // Función que despues de 500ms sin pulsar tecla obtiene una lista de movie según query

    isLoadingStream.add(true); // Cuando se esta escribiendo mandamos un stream = true -> spin

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();      // Si existía un timer se anula

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async { // Sino existía se define y pasados 500ms

      final movies = await searchMovies(query); // Obtenemos las películas
      debouncedMovies.add(movies);              // y se añaden al stream de datos
      initialMovies = movies;                   // Ademas damos valor a initialMovies con el rdo de la busqueda

      isLoadingStream.add(false); // Cuando tenemos las películas mandamos un stream = false -> mostramos una X
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot){
          
          if( snapshot.data ?? false){ // Si se esta cargando datos mostramos el spin
            return SpinPerfect(
              duration: const Duration( seconds: 20 ),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',    // Borra el contenido de la busqueda
                icon: const Icon(Icons.refresh_rounded)),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
                onPressed: () => query = '', // Borra el contenido de la busqueda
                icon: const Icon(Icons.clear)),
          );

        },
      ),
   
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {  // Permite salir de la busqueda
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null); // Suponemos que el rdo es null porque quería salir de la busqueda y no busco nada
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  Widget buildResultsAndSuggestions() {
    
    return StreamBuilder(
        initialData: initialMovies,
        stream: debouncedMovies.stream, // Se recibe el stream de datos que contiene la List<Movie> según query despues del debounce
        builder: (context, snapshot) {
          
          final movies = snapshot.data ?? []; // Valor de la respuesta List<Movie> // Snapshot siempre contendrá el valor anterior

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _MovieItem(
                  movie: movies[index],
                  onMovieSelected: (context, movie) {
                    clearStreams();
                    close(context, movie);
                  },
                );
              });
        });
  }


  @override
  Widget buildResults(BuildContext context) { // Esta función ejecuta una busqueda sobre el query cuando se hace enter -> el stream = initialData realizado en suggestions
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) { // Esta función realiza una busqueda sobre query según vamos escribiendo
    
    _onQueryChanged(query); // Cada vez que se pulsa una tecla se llama esta función -> se reinicia un debounceTimer -> Cuando termina petición https -> debouncedStream se llena de datos con los rdos

    return buildResultsAndSuggestions(); // Aquí el initialData proviene de la última petición de busqueda realizada con _onQueryChanged
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(children: [

            //Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) =>
                        FadeIn(child: child),
                  )),
            ),

            const SizedBox(width: 10),

            //Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded,
                          color: Colors.yellow.shade800),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  )
                ],
              ),
            )
          ])),
    );
  }
}
