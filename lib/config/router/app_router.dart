import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';


final appRouter = GoRouter(
  initialLocation: '/home/0', // Primera ruta que se renderiza HomeScreen
  routes: [

    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: ( context, state ) {
        final pageIndex = state.pathParameters['page'] ?? '0'; // Obtenemos el params asociado a la ruta

        return HomeScreen(pageIndex: int.parse(pageIndex),);   // Lo enviamos a HomeScreen convertido en Int
      },  
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

    GoRoute(
      path: '/',
      redirect:( _ , __) => '/home/0',
    )


  ]
);