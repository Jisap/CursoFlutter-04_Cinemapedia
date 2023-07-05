//import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
//import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
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
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( upComingMoviesProvider.notifier).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch( initialLoadingProvider );     // Determinamos si se cargaron los providers

    if( initialLoading ) return const FullScreenLoader();           // true = cargando y mostramos el loader sino mostramos el CustonScrollVuew 

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider ); // Cuando el estado cambia reconstruye el widget.
    final slideShowMovies = ref.watch( moviesSlideshowProvider );   // Usaremos el provider del slideshow basado en provider ppal para mostrar en la cabezera solo 6 resultados
    final popularMovies = ref.watch( popularMoviesProvider );
    final upComingMovies = ref.watch( upComingMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );


    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index){ 
            return Column(
              children: [
          
                //CustomAppbar(),
          
                MoviesSlideshow(movies: slideShowMovies),
          
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subTitle: 'Lunes 20', 
                  loadNextPage: (){ 
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(); // movies_providers lee el movies_repository_provider y este a su vez el movieRepositoryImpl
                  }, 
                ),
          
                MovieHorizontalListview(
                  movies: upComingMovies,
                  title: 'Proximamente',
                  subTitle: 'En este mes',
                  loadNextPage: () {
                    ref.read(upComingMoviesProvider.notifier).loadNextPage(); // movies_providers lee el movies_repository_provider y este a su vez el movieRepositoryImpl
                  },
                ),
          
                MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  subTitle: 'Lunes 20',
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage(); // movies_providers lee el movies_repository_provider y este a su vez el movieRepositoryImpl
                  },
                ),
          
                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor calificadas',
                  subTitle: 'De siempre',
                  loadNextPage: () {
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage(); // movies_providers lee el movies_repository_provider y este a su vez el movieRepositoryImpl
                  },
                ),
          
                const SizedBox( height: 10 ),
          
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
          },
          childCount: 1
        )),

      ]
    );
  }
}