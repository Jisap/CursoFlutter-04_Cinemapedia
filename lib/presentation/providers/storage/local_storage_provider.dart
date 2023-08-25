

import 'package:cinemapedia/infraestructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final localStorageRepositoryProvider = Provider((ref) {   // Se define el provider basado en la implementación de infraestructure
  return LocalStorageRepositoryImpl(IsarDatasource());
});
