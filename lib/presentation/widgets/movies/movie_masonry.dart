
import 'package:flutter/material.dart';
import '../../../domain/entities/movie.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'movie_poster_link.dart';

class MovieMasonry extends StatefulWidget {

  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry({
    super.key, 
    required this.movies, 
    this.loadNextPage
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonry();
}

class _MovieMasonry extends State<MovieMasonry> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {                   // listener para la posición del scroll
      if( widget.loadNextPage == null ) return;         // Si loadNextPage no tiene más películas no hay más scroll

      if( (scrollController.position.pixels + 100) >= scrollController.position.maxScrollExtent ) {  // Si se llega al final de la pantalla + 100px
        widget.loadNextPage!();                                                                     // Se carga la siguiente página de favoritos
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3, // 3 columnas
        mainAxisSpacing: 10,
        crossAxisSpacing: 10, 
        itemCount: widget.movies.length, // widget porque estamos dentro de un stateful
        itemBuilder: (context, index){

          if(index == 1){
            return Column(
              children: [
                const SizedBox(height: 40),
                MoviePosterLink( movie: widget.movies[index])
              ],
            );
          }
    
          return MoviePosterLink( movie: widget.movies[index]);
        }
      ),
    );
  }
}