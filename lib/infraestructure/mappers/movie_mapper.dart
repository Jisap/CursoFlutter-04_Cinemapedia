

//El mapper lee diferentes modelos y crea una entidad

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/models/moviesb/movie_moviedb.dart';

class MovieMapper {

  static Movie movieDBToEntity( MovieMovieDB moviedb ) => Movie( // tranformamos lo que el api nos da y lo convertimos a nuestra definición de entidad Movie
    adult: moviedb.adult, 
    backdropPath:( moviedb.backdropPath  != '' ) 
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
      : 'https://orbis-alliance.com/wp-content/themes/consultix/images/no-image-found-360x260.png', 
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(), 
    id: moviedb.id, 
    originalLanguage: moviedb.originalLanguage, 
    originalTitle: moviedb.originalTitle, 
    overview: moviedb.overview, 
    popularity: moviedb.popularity, 
    posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
      : 'no-poster', 
    releaseDate: moviedb.releaseDate, 
    title: moviedb.title, 
    video: moviedb.video, 
    voteAverage: moviedb.voteAverage, 
    voteCount: moviedb.voteCount
  );
}