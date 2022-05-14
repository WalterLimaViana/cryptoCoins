import 'package:cryptocoins/models/posicao.dart';
import 'package:cryptocoins/repositories/conta_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';

class CarteiraPage extends StatefulWidget {
  CarteiraPage({Key? key}) : super(key: key);

  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  int index = 0;
  double totalCarteira = 0;
  double saldo = 0;
  late NumberFormat real;
  late ContaRepository conta;

  String graficoLabel = "";
  double graficoValor = 0;
  List<Posicao> carteira = [];

  @override
  Widget build(BuildContext context) {
    conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    saldo = conta.saldo;

    setTotalCarteira();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(top: 48, bottom: 8),
            child: Text(
              'Valor da Carteira',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Text(real.format(totalCarteira),
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5)),
          loadGrafico(),
        ]),
      ),
    );
  }

  setTotalCarteira() {
    final carteiraList = conta.carteira;
    setState(() {
      totalCarteira = conta.saldo;
      for (var posicao in carteiraList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }

  loadGrafico() {
    return (conta.saldo <= 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 110,
                    sections: loadCarteira(),
                    pieTouchData: PieTouchData(
                      touchCallback: (touch) => setState(() {
                        index = touch.touchedSection!.touchedSectionIndex;
                        setGraficoDados(index);
                      }),
                    ))),
              ),
              Column(
                children: [
                  Text(
                    graficoLabel,
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  Text(graficoLabel,
                      style: TextStyle(real.format(graficoValor),
                          style: TextStyle(fontSize: 28)))
                ],
              )
            ],
          );
  }
}
