import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: ( context, state ) => const HomeScreen(),  
      routes: [
        GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['id'] ?? 'no-id'; // Obtención del id de la ruta
              return MovieScreen(movieId: movieId);
            }),
      ]
    ),

    
  ]
);