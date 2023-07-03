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

    List<Movie> _jsonToMovies( Map<String, dynamic> json ){             // Método abreviado para obtener una lista de movies
      
      final movieDBResponse = MovieDbResponse.fromJson(json);           // Convertimos a json la respuesta total de la api

      final List<Movie> movies = movieDBResponse.results
          .where((moviedb) => moviedb.posterPath != 'no-poster')        // Si viene el posterPath se incluye en la respuesta sino no
          .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))       // Usamos el mapper para obtener de la respuesta una lista de Movie
          .toList();

      return movies;
    }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{                  // Método no abreviado para obtener una lista de Movies

    final response = await dio.get('/movie/now_playing',                    // Obtenemos la respuesta de la api proporcionandole el endpoint final
      queryParameters: {                                                    // y la página que queremos visualizar 
        'page': page
      }
    );                   
    
    final movieDBResponse = MovieDbResponse.fromJson(response.data);        // Convertimos a json la respuesta total de la api

    final List<Movie> movies = movieDBResponse.results
      .where((moviedb) => moviedb.posterPath != 'no-poster')                // Si viene el posterPath se incluye en la respuesta sino no
      .map(                                                                 // Usamos el mapper para obtener de la respuesta una lista de Movie
        (moviedb) => MovieMapper.movieDBToEntity( moviedb )).toList();

    return movies;
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    
    final response = await dio.get('/movie/popular',                        // Obtenemos la respuesta de la api proporcionandole el endpoint final
      queryParameters: {                                                    // y la página que queremos visualizar 
        'page': page
      }
    );                   
    
    return _jsonToMovies(response.data);                                    // Aquí usamos el método abreviado para ahorrar lineas de código
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    
    final response = await dio.get('/movie/top_rated',                       // Obtenemos la respuesta de la api proporcionandole el endpoint final
      queryParameters: {                                                     // y la página que queremos visualizar 
        'page': page
      }
    );  

    return _jsonToMovies(response.data);  
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    
    final response = await dio.get('/movie/upcoming',                       // Obtenemos la respuesta de la api proporcionandole el endpoint final
      queryParameters: {                                                     // y la página que queremos visualizar 
        'page': page
      }
    );  

    return _jsonToMovies(response.data);  
  }

}