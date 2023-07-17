import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infraestructure/datasources/actor_moviedb_datasource.dart';
import '../../../infraestructure/repositories/actor_repository_impl.dart';

// El provider expone un valor de solo lectura
final actorsRepositoryProvider = Provider((ref) {            // El provider usa la implementación del repositorio
  return ActorRepositoryImpl(ActorMovieDbDatasource());      // usando como datasource el Actor_Moviedb_datasource de infraestructure
});
