import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget { // Un consumer puede leer providers
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState(); // Estado
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage(); // lectura del provider
  }

  @override
  Widget build(BuildContext context) {

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );  // Cuando el estado cambia reconstruye el widget.
    final slideShowMovies = ref.watch( moviesSlideshowProvider );    // Usaremos el provider del slideshow basado en provider ppal para mostrar en la cabezera solo 6 resultados

    return Column(
      children: [

        CustomAppbar(),

        MoviesSlideshow(movies: slideShowMovies),

        MovieHorizontalListview(
          movies: nowPlayingMovies,
          title: 'En cines',
          subTitle: 'Lunes 20', 
          loadNextPage: (){ 
            ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(); // movies_providers lee el movies_repository_provider y este a su vez el movieRepositoryImpl
          }, 
        ),

        // Expanded(
        //   child: ListView.builder(
        //     itemCount: nowPlayingMovies.length,
        //     itemBuilder: (context, index){
        //       final movie = nowPlayingMovies[index];
        //       return ListTile(
        //         title: Text( movie.title ),
        //       );
        //     }
        //   ),
        // )
      ],
    );
  }
}