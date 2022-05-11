import 'package:cryptocoins/models/moeda.dart';
import 'package:cryptocoins/pages/moedas_detalhes_page.dart';
import 'package:cryptocoins/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoedasPage extends StatefulWidget {
  MoedasPage({Key? key}) : super(key: key);

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Moeda> selecionadas = [];

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: Center(child: Text('Crypto Coins')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarDinamica(),
        body: ListView.separated(
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
                        child: Image.asset(tabela[moeda].icone), width: 40),
                title: Text(tabela[moeda].name,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
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
                onTap: mostrarDetalhes(tabela[moeda]),
              );
            },
            padding: EdgeInsets.all(16),
            separatorBuilder: (_, ___) => Divider(),
            itemCount: tabela.length),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: selecionadas.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {},
                icon: Icon(Icons.star),
                label: Text('FAVORITAR',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    )))
            : null);
  }
}
