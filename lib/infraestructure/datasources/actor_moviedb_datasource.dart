

import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviesdb/credits_response.dart';
import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';

class ActorMovieDbDatasource extends ActorsDatasource{

  final dio = Dio(BaseOptions(
      // Estructura base de la petición http a la api
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-Es'
      }));
  
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    
    final response = await dio.get('/movie/$movieId/credits');  // Respuesta de la api

    final castResponse = CreditsResponse.fromJson(response.data); // Adecuación de la respuesta a valores null

    List<Actor> actors = castResponse.cast.map((cast) => ActorMapper.castToEntity(cast)).toList(); // Adecuación de la respuesta al modelo

    return actors; // Retornamos la lista de actores de la película
  }

}