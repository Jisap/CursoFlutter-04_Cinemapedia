

import 'package:cinemapedia/infraestructure/models/moviesdb/credits_response.dart';

import '../../domain/entities/actor.dart';

class ActorMapper { // Modifica la resp de la api (Actor) para que se adapte a nuestra entity

  static Actor castToEntity( Cast cast ) => Actor (
    id: cast.id, 
    name: cast.name, 
    character: cast.character, 
    profilePath: cast.profilePath != null
    ? 'https://image.tmdb.org/t/p/w500${ cast.profilePath }'
    : 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.lkVN1WDlcV2jQCq-9LT7-wHaIJ%26pid%3DApi&f=1&ipt=0202eb5d410c606084465637535e1d94f1c7da59c0cccfc5e5394343f154b7d4&ipo=images',
  );
}