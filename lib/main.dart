import 'package:cryptocoins/configs/app_settings.dart';
import 'package:cryptocoins/configs/hive_config.dart';
import 'package:cryptocoins/meu_aplicativo.dart';
import 'package:cryptocoins/repositories/favoritas_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
      ],
      child: MeuAplicativo(),
    ),
  );
}
