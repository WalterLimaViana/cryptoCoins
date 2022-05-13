import 'package:cryptocoins/repositories/favoritas_repository.dart';
import 'package:cryptocoins/widgets/moeda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Moedas Favoritas')),
      ),
      body: Container(
        color: Colors.blueAccent.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(12),
        child: Consumer<FavoritasRepository>(
          builder: (context, favoritas, child) {
            return favoritas.lista.isEmpty
                ? ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Ainda não há moedas favoritas'))
                : ListView.builder(
                    itemCount: favoritas.lista.length,
                    itemBuilder: (_, index) {
                      return MoedaCard(moeda: favoritas.lista[index]);
                    });
          },
        ),
      ),
    );
  }
}
