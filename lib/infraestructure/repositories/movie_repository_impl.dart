


import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {        // Los repositorios llaman los datasources

  final MoviesDatasource datasource;                        // Definimos el datasource que vamos a usar -> el definido en dominio con el método getNowPlaying

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {       // Este método devuelve una lista de movie
    return datasource.getNowPlaying(page:page);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
     return datasource.getUpcoming(page: page);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
     return datasource.getTopRated(page: page);
    
  }


}