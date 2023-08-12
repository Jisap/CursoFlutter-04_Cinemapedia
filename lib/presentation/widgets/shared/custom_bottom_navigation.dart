import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {

  final int currentIndex;

  const CustomBottomNavigation({
    super.key, 
    required this.currentIndex
  });

  void onItemTapped( BuildContext context, int index){ // Si se presiona una tab cambiamos la ruta -> router -> HomeScreen -> obtiene params -> view
    switch(index){
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap:(value) => onItemTapped(context, value), // al pulsar obtenemos un value correspondiente a la posición en items[]
      elevation: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max),label: 'Inicio',),
        BottomNavigationBarItem(icon: Icon(Icons.label_outline), label: 'Categorias'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
      ]
    );
  }
}


