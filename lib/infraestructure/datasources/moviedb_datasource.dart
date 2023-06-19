import 'package:dio/dio.dart';


import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviesb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource{

    final dio = Dio(BaseOptions(                                             // Estructura base de la petición http a la api
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-Es'
      }
    ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{                  // Método para obtener una lista de Movies

    final response = await dio.get('/movie/now_playing');                   // Obtenemos la respuesta de la api proporcionandole el endpoint final
    
    final movieDBResponse = MovieDbResponse.fromJson(response.data);        // Convertimos a json la respuesta total de la api

    final List<Movie> movies = movieDBResponse.results
      .where((moviedb) => moviedb.posterPath != 'no-poster')                // Si viene el posterPath se incluye en la respuesta sino no
      .map(                                                                 // Usamos el mapper para obtener de la respuesta una lista de Movie
        (moviedb) => MovieMapper.movieDBToEntity( moviedb )).toList();

    return movies;
  }

}