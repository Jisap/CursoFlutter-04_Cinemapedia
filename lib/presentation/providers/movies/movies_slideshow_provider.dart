
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref){ // Provider de solo lectura. Ref hace referencia a todos los providers que gestiona riverpod

  final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider ); // importamos el provider de movies general

  if( nowPlayingMovies.isEmpty ) return [];

  return nowPlayingMovies.sublist(0, 6);

});