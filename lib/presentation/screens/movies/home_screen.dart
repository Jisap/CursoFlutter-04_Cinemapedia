

import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';
  final int pageIndex;                  // pageIndex nos indica que tab se ha seleccionado, por defecto el valor inicial es 0

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  final viewRoutes = const <Widget> [
    HomeView(),
    SizedBox(),
    FavoritesView() 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // Crea un widget basado en un [] mostrando un solo child del mismo
        index: pageIndex, // index del [stack] que se muestra. Valor inicial definido en el router
        children: viewRoutes, // stack[]
      ),
      bottomNavigationBar: CustomBottomNavigation( currentIndex: pageIndex ),
    );
  }
}

