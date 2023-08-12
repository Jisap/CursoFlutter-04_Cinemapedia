import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
//import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.movie_outlined, color: colors.primary),
                  const SizedBox(width: 5),
                  Text('Cinemapedia', style: titleStyle),
                  const Spacer(),
                  IconButton(
                      
                      onPressed: () async {
                        
                        final searchedMovies = ref.read( searchedMoviesProvider );  // Exponemos el estado de la última List<Movie> y su query
                        final searchQuery = ref.read(searchQueryProvider);         

                        showSearch<Movie?>(                                        // Permite pinchar en uno de los rdos de las suggestions
                            query: searchQuery,
                            context: context,
                            delegate: SearchMovieDelegate(                         // SearchMovieDelegate nos muestra las suggestions  
                                initialMovies: searchedMovies,
                                searchMovies:                                                    
                                  ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery // Enviamos solo la referencia a la función de busqueda                             
                            )
                        ).then((movie) {                                           // Si se pincha en una de las movies                      
                            if( movie == null ) return;

                            context.push('/home/0/movie/${ movie.id }');                  // redirección a la página de la movie
                        });
                                  
                      },
                      icon: const Icon(Icons.search)
                  )
                ],
              ))),
    );
  }
}
