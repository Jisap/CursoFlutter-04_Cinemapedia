


import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider((ref) {            // El provider usa la implementación del repositorio 
  return MovieRepositoryImpl( MoviedbDatasource() );        // usando como datasource el moviedb_datasource de infraestructure
});