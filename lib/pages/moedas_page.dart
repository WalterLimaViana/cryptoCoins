import 'package:cryptocoins/configs/app_settings.dart';
import 'package:cryptocoins/models/moeda.dart';
import 'package:cryptocoins/pages/moedas_detalhes_page.dart';
import 'package:cryptocoins/repositories/favoritas_repository.dart';
import 'package:cryptocoins/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  MoedasPage({Key? key}) : super(key: key);

  @override
  _MoedasPageState createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  late List<Moeda> tabela;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;
  late MoedaRepository moedas;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
        icon: Icon(Icons.language),
        itemBuilder: (context) => [
              PopupMenuItem(
                  child: ListTile(
                leading: Icon(Icons.swap_vert),
                title: Text('Usar $locale'),
                onTap: () {
                  context.read<AppSettings>().setLocale(locale, name);
                  Navigator.pop(context);
                },
              ))
            ]);
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: Center(child: Text('Crypto Coins')),
        actions: [changeLanguageButton()],
      );
    } else {
      return AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {
                selecionadas = [];
              });
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        toolbarTextStyle: TextTheme(
                headline6: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
            .bodyText2,
        titleTextStyle: TextTheme(
                headline6: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
            .headline6,
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MoedasDetalhesPage(
                  moeda: moeda,
                )));
  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // favoritas = Provider.of<FavoritasRepository>(context);
    favoritas = context.watch<FavoritasRepository>();
    moedas = context.watch<MoedaRepository>();
    tabela = moedas.tabela;
    readNumberFormat();
    return Scaffold(
        appBar: appBarDinamica(),
        body: RefreshIndicator(
          onRefresh: () => moedas.checkPrecos(),
          child: ListView.separated(
              itemBuilder: (BuildContext context, int moeda) {
                return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: (selecionadas.contains(tabela[moeda]))
                        ? CircleAvatar(
                            child: Icon(Icons.check),
                          )
                        : SizedBox(
                            child: Image.network(tabela[moeda].icone),
                            width: 40,
                          ),
                    title: Row(
                      children: [
                        Text(tabela[moeda].name,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500)),
                        if (favoritas.lista
                            .any((fav) => fav.sigla == tabela[moeda].sigla))
                          Icon(Icons.star, color: Colors.amber, size: 12)
                      ],
                    ),
                    trailing: Text(real.format(tabela[moeda].preco)),
                    selected: selecionadas.contains(tabela[moeda]),
                    selectedColor: Colors.indigo[50],
                    onLongPress: () {
                      setState(() {
                        selecionadas.contains(tabela[moeda])
                            ? selecionadas.remove(tabela[moeda])
                            : selecionadas.add(tabela[moeda]);
                      });
                    },
                    onTap: () {
                      mostrarDetalhes(tabela[moeda]);
                    });
              },
              padding: EdgeInsets.all(16),
              separatorBuilder: (_, ___) => Divider(),
              itemCount: tabela.length),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: selecionadas.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  favoritas.saveAll(selecionadas);
                  limparSelecionadas();
                },
                icon: Icon(Icons.star),
                label: Text('FAVORITAR',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    )))
            : null);
  }
}
