import 'package:cryptocoins/models/moeda.dart';

class MoedaRepository {
  static List<Moeda> tabela = [
    Moeda(
      icone: 'assets/images/bitcoin.png',
      name: 'Bitcoin',
      sigla: 'BTC',
      preco: 164603.00,
    ),
    Moeda(
        icone: 'assets/images/ethereum.png',
        name: 'Ethereum',
        sigla: 'ETH',
        preco: 9716.00),
    Moeda(
        icone: 'assets/images/xrp.png', name: 'XRP', sigla: 'XRP', preco: 3.34),
    Moeda(
        icone: 'assets/images/cardano.png',
        name: 'Cardano',
        sigla: 'ADA',
        preco: 6.32),
    Moeda(
        icone: 'assets/images/usdcoin.png',
        name: 'USD Coin',
        sigla: 'USDC',
        preco: 5.02),
    Moeda(
        icone: 'assets/images/litecoin.png',
        name: 'Litecoin',
        sigla: 'LTC',
        preco: 669.93),
  ];
}
