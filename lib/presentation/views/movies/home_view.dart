import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';




class HomeView extends ConsumerStatefulWidget {

  // Un consumer puede leer providers
  const HomeView({super.key});

  @override
   HomeViewState createState() => HomeViewState(); // Estado
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(); // lectura del provider
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider); // Determinamos si se cargaron los providers

    if (initialLoading) return const FullScreenLoader(); // true = cargando y mostramos el loader sino mostramos el CustonScrollVuew

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider); // Cuando el estado cambia reconstruye el widget.
    final slideShowMovies = ref.watch(moviesSlideshowProvider); // Usaremos el provider del slideshow basado en provider ppal para mostrar en la cabezera solo 6 resultados
    final popularMovies = ref.watch(popularMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        flexibleSpace: FlexibleSpaceBar(
          title: CustomAppbar(),
        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            //CustomAppbar(),

            MoviesSlideshow(movies: slideShowMovies),

            MovieHorizontalListview(
              movies: nowPlayingMovies,
              title: 'En cines',
              subTitle: 'Lunes 20',
              loadNextPage: () {
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

            const SizedBox(height: 10),

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
      }, childCount: 1)),
    ]);
  }
}
