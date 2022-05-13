import 'package:cryptocoins/meu_aplicativo.dart';
import 'package:cryptocoins/repositories/favoritas_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => FavoritasRepository(), child: MeuAplicativo()),
  );
}
