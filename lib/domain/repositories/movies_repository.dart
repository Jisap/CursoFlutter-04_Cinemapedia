


import '../entities/movie.dart';

abstract class MovieRepository {                        // Los repositorios llaman los datasources
  Future<List<Movie>> getNowPlaying({int page = 1});
}
