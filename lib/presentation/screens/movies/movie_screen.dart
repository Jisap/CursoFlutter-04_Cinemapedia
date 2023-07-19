import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';
import '../../providers/movies/movie_info_provider.dart';


class MovieScreen extends ConsumerStatefulWidget { // El consumer lee información de los providers

  static const name = 'movie-screen';     // Nombre para la ruta

  final String movieId;                   // Id necesario para entrar en esta pantalla

  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();  // Estado
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId); // Cargamos la función que carga la película por id -> modifica el state
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId); // También la funcion que carga los actores de esa película
  }

  @override
  Widget build(BuildContext context) {

    final movies = ref.watch( movieInfoProvider );  // Observamos si el provider emite un nuevo valor (nueva película cargada)
    final Movie? movie = movies[widget.movieId];    // Obtenemos la nueva película

    if( movie == null ){
      return const Scaffold(body: Center( child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1,
          ))
        ],
      )
    );
  }
}


class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({ required this.movie });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles= Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[

        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // y
            children: [

              ClipRRect(                                          // Imagen
              borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,  
                ),
              ),

              const SizedBox(                                     // Espacio
                width: 10
              ),

              SizedBox(                                           // Descripción
                width: (size.width - 40) * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // x
                  children: [
                    Text( movie.title, style: textStyles.titleLarge),
                    Text( movie.overview ),
                  ],)
              )

            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8), // Chips
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only( right: 10),
                child: Chip(
                  label: Text( gender),
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20))  
                ),
              ))
            ]
          )
        ),

        _ActorsByMovie(movieId: movie.id.toString()), // Lista de actores en la parte baja de la pantalla

        const SizedBox( height: 50),

      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  
  final String movieId;
  
  const _ActorsByMovie({ required this.movieId });

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider); // Observamos si la List<Actor> emite un nuevo valor desde su estado -> cargamos el estado
    
    if( actorsByMovie[movieId] == null ){                      // Si ese valor es null la película se esta cargando   
      return const CircularProgressIndicator(strokeWidth: 2);  // mostramos un loader. 
    }

    final actors = actorsByMovie[movieId]!; // Determinamos la lista de actores de una determinada película. Recordar que state = {'505642': <Actor>[],}

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {

          final actor = actors[index];
          
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                FadeInRight(
                  child: ClipRRect(                                    // Actor photo
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,  
                    ),
                  ),
                ),
              
                const SizedBox( height: 5),

                Text(actor.name, maxLines:2),                         // Nombre del actor
                Text(actor.character ?? '', 
                  maxLines: 2,
                  style: TextStyle( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                ),

              ],
            ),

          );
        },
      ),
    );
  }
}


class _CustomSliverAppbar extends StatelessWidget { // Este widget muestra el poster junto el título y el boton de ir atras
  
  final Movie movie;
  
  const _CustomSliverAppbar({
     required this.movie
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size; // Dimensiones del dispositivosize

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      shadowColor: Colors.red,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal:10, vertical:5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children:[

            SizedBox.expand(          // Imagen de la película
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress){
                  if( loadingProgress != null ) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const SizedBox.expand(   // Gradiente de arriba a abajo
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops:[0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87
                    ])
                )
              ),
            ),

            const SizedBox.expand(    // Gradiente superior de izda a derecha
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          stops: [0.0, 0.4],
                          colors: [ Colors.black87,Colors.transparent, ]
                      )
                  )
              ),
            ),

          ],
        ),
      ),
    );
  }
}