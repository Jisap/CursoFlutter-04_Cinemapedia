import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView()
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

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider ); // Cuando el estado cambia reconstruye el widget.

    if( nowPlayingMovies.isEmpty ) return const CircularProgressIndicator();

    return ListView.builder(
      itemCount: nowPlayingMovies.length,
      itemBuilder: (context, index){
        final movie = nowPlayingMovies[index];
        return ListTile(
          title: Text( movie.title ),
        );
      }
    );
  }
}