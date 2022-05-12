import 'package:cryptocoins/pages/favoritas_page.dart';
import 'package:cryptocoins/pages/moedas_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pc,
          children: [
            MoedasPage(),
            FavoritesPage(),
          ],
          onPageChanged: setPaginaAtual,
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              backgroundColor: Colors.lightBlue.withOpacity(0.1),
              indicatorColor: Colors.lightBlue,
              labelTextStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          child:
              //outra opção de Navigation Bar, como o usado pelo google
              // NavigationBar(
              //   selectedIndex: paginaAtual,
              //   onDestinationSelected: (int i) => setState(() => paginaAtual = i),
              //   destinations: const [
              //     NavigationDestination(
              //       icon: Icon(Icons.list_sharp),
              //       label: 'Todas',
              //       selectedIcon: Icon(Icons.list),
              //     ),
              //     NavigationDestination(
              //         icon: Icon(Icons.star_border_outlined),
              //         label: 'Favoritas',
              //         selectedIcon: Icon(Icons.star))
              //   ],
              // ),

              BottomNavigationBar(
            currentIndex: paginaAtual,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todas'),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Favoritas',
              )
            ],
            onTap: (pagina) {
              pc.animateToPage(pagina,
                  duration: Duration(microseconds: 400), curve: Curves.ease);
            },
          ),
        ));
  }
}
