import 'package:cryptocoins/database/db.dart';
import 'package:cryptocoins/models/moeda.dart';
import 'package:cryptocoins/models/posicao.dart';
import 'package:cryptocoins/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  List<Posicao> _carteira = [];
  double _saldo = 0;

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;
  ContaRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
    await _getCarteira();
  }

// pegar o saldo da conta
  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

// atualizar saldo da conta
  setSaldo(double valor) async {
    db = await DB.instance.database;
    db.update('conta', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }

  //método comprar:
  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      //Verificar se a moeda já foi comprada
      final posicaoMoeda = await txn.query(
        'carteira',
        where: 'sigla = ?',
        whereArgs: [moeda.sigla],
      );
      //se não tem a moeda em carteira
      if (posicaoMoeda.isEmpty) {
        await txn.insert('carteira', {
          'sigla': moeda.sigla,
          'moeda': moeda.name,
          'quantidade': (valor / moeda.preco).toString()
        });
      } //Já tem a moeda em carteira
      else {
        final atual = double.parse(posicaoMoeda.first['quantidade'].toString());
        await txn.update('carteira',
            {'quantidade': (atual + (valor / moeda.preco)).toString()},
            where: 'sigla = ?', whereArgs: [moeda.sigla]);
      }

      //Inserir a compra no historico
      await txn.insert('historico', {
        'sigla': moeda.sigla,
        'moeda': moeda.name,
        'quantidade': (valor / moeda.preco).toString(),
        'valor': valor,
        'tipo_operacao': 'compra',
        'data_operacao': DateTime.now().millisecondsSinceEpoch
      });

      //Atualizar o saldo
      await txn.update('conta', {'saldo': saldo - valor});
    });
    await _initRepository();
    notifyListeners();
  }

  _getCarteira() async {
    _carteira = [];
    List posicoes = await db.query('carteira');
    posicoes.forEach((posicao) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == posicao['sigla'],
      );
      _carteira.add(Posicao(
        moeda: moeda,
        quantidade: double.parse(posicao['quantidade']),
      ));
    });
    notifyListeners();
  }
}
