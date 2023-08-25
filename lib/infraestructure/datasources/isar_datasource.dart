import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {

  late Future<Isar> db; // Instancia de nuestra bd

  IsarDatasource() { // Constructor que inicializa la bd
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory(); // Es necesario el path a nuestro schema de movies

    if (Isar.instanceNames.isEmpty) { // Si la instancia esta vacia.
      return await Isar.open(         // le damos contenido.
        [MovieSchema],                // con el schema.
        inspector: true,
        directory: dir.path,          // ubicado en esta dirección.
      );
    }
    return Future.value(Isar.getInstance()); // Si la instancia tiene contenido devolvemos esa instancia.
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async { // Función de que busca dentro de la bd(pelis favoritas) una película por id
    final isar = await db;

    final Movie? isFavoriteMovie = await isar.movies //  se encontró una película con el ID proporcionado en la base de datos
        .filter()
        .idEqualTo(movieId)
        .findFirst();
    return isFavoriteMovie != null; // La función devuelve true si isFavoriteMovie no es nulo
  }

  @override
  Future<void> toogleFavorite(Movie movie) async { // Borra o inserta una peli en bd(pelis favoritas)
    final isar = await db;

    final favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();
      
    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!)); // borrar
      return;
    }

    isar.writeTxnSync(() => isar.movies.putSync(movie)); // Insertar
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async { // Carga las películas de la bd(pelis favoritas)
    final isar = await db;

    return isar.movies
      .where()
      .offset(offset)
      .limit(limit)
      .findAll();
  }
}
