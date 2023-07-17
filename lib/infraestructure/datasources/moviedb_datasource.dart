import 'package:cinemapedia/infraestructure/models/moviesdb/movie_details.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviesdb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {              // Aquí se realiza el desarrollo de las peticiones y la gestión de las respuestas
  
  final dio = Dio(BaseOptions(
      // Estructura base de la petición http a la api
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-Es'
      })
  );

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {        // Método abreviado para obtener una lista de movies (json -> data)

    final movieDBResponse = MovieDbResponse.fromJson(json);     // Aplicamos el factory del model para determinar valor de las var que puede que no vengan

    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')  // Si viene el posterPath se incluye en la respuesta sino no
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb)) // le pasamos un mapper para adecuar la res de la api a nuestra entity Movie
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {    // Método no abreviado para obtener una lista de Movies

    final response = await dio.get('/movie/now_playing',       // Obtenemos la respuesta de la api proporcionandole el endpoint final
        queryParameters: {                                     // y la página que queremos visualizar
          'page': page
        });

    final movieDBResponse = MovieDbResponse.fromJson(response.data); // Aplicamos el factory del model para determinar valor de las var que puede que no vengan

    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster') // Si viene el posterPath se incluye en la respuesta sino no
        .map(                                                  // Y le pasamos un mapper para adecuar la res de la api a nuestra entity Movie
          (moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular',          // Obtenemos la respuesta de la api proporcionandole el endpoint final
        queryParameters: {                                    // y la página que queremos visualizar
          'page': page
        });

    return _jsonToMovies(response.data);                      // Aquí usamos el método abreviado para ahorrar lineas de código
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated',        // Obtenemos la respuesta de la api proporcionandole el endpoint final
        queryParameters: {                                    // y la página que queremos visualizar
          'page': page
        });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming',         // Obtenemos la respuesta de la api proporcionandole el endpoint final
        queryParameters: {                                    // y la página que queremos visualizar
          'page': page
        });

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {

    final response = await dio.get( '/movie/$id' ); // La respuesta de la api es diferente de nuestra entidad Movie

    if( response.statusCode != 200 ) throw Exception('Movie with id: $id not found');

    final movieDetails = MovieDetails.fromJson( response.data); // Primero le aplicamos el factory para determinar valor de las var que puede que no vengan

    final Movie movie = MovieMapper.movieDetailsToEntity( movieDetails ); // Por último le pasamos un mapper para adecuar la res de la api a nuestra entity


    return movie;
  }
}
