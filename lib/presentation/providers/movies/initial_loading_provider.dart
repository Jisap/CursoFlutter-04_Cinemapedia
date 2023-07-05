
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';




final initialLoadingProvider = Provider<bool>((ref){

  final step1 = ref.watch( nowPlayingMoviesProvider ).isEmpty; // Con isEmpty verificamos si estan vacios.    
  final step2 = ref.watch( popularMoviesProvider ).isEmpty;
  final step3 = ref.watch( topRatedMoviesProvider ).isEmpty;
  final step4 = ref.watch( upComingMoviesProvider ).isEmpty;

  if(step1 || step2 || step3 || step4 ) return true; // Mientras estan cargando data devolvemos true.

  return false; // Si Terminamos de cargar y no se cumple el isEmpty devolvemos false.

});