import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cryptocoins/database/db_firestore.dart';
import 'package:cryptocoins/models/moeda.dart';
import 'package:cryptocoins/repositories/moeda_repository.dart';
import 'package:cryptocoins/services/auth_service.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _lista = [];
  // late LazyBox box;
  late FirebaseFirestore db;
  late AuthService auth;
  MoedaRepository moedas;

  FavoritasRepository({required this.auth, required this.moedas}) {
    _startRepository();
  }

  _startRepository() async {
    // await _openBox();
    await _startFirestore();
    await _readFavoritas();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  // _openBox() async {
  //   Hive.registerAdapter(MoedaHiveAdapter());
  //   box = await Hive.openLazyBox<Moeda>('moedas_favoritas');
  // }

  _readFavoritas() async {
    if (auth.usuario != null && _lista.isEmpty) {
      try {
        final snapshot = await db
            .collection('usuarios/${auth.usuario!.uid}/favoritas')
            .get();

        snapshot.docs.forEach((doc) {
          Moeda moeda = moedas.tabela
              .firstWhere((moeda) => moeda.sigla == doc.get('sigla'));
          _lista.add(moeda);
          notifyListeners();
        });
      } catch (e) {
        print('Sem id de usuário');
      }
    }
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) async {
      if (!_lista.any((atual) => atual.sigla == moeda.sigla)) {
        _lista.add(moeda);
        // box.put(moeda.sigla, moeda);
        await db
            .collection('usuarios/${auth.usuario!.uid}/favoritas')
            .doc(moeda.sigla)
            .set({
          'moeda': moeda.name,
          'sigla': moeda.sigla,
          'preco': moeda.preco,
        });
      }
    });
    notifyListeners();
  }

  remove(Moeda moeda) async {
    await db
        .collection('usuarios/${auth.usuario!.uid}/favoritas')
        .doc(moeda.sigla)
        .delete();
    _lista.remove(moeda);
    // box.delete(moeda.sigla);
    notifyListeners();
  }
}
