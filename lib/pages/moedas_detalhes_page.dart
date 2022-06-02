import 'package:cryptocoins/configs/app_settings.dart';
import 'package:cryptocoins/models/moeda.dart';
import 'package:cryptocoins/repositories/conta_repository.dart';
import 'package:cryptocoins/widgets/grafico_historico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;
  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedasDetalhesPageState createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  late NumberFormat real;
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double quantidade = 0;
  late ContaRepository conta;
  Widget grafico = Container();
  bool graficoLoaded = false;

  getGrafico() {
    if (!graficoLoaded) {
      grafico = GraficoHistorico(moeda: widget.moeda);
      graficoLoaded = true;
    }
    return grafico;
  }

  comprar() async {
    if (_form.currentState!.validate()) {
      //salvar a compra
      await conta.comprar(widget.moeda, double.parse(_valor.text));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra realizada com sucesso')));
    }
  }

  vender() async {
    if (_form.currentState!.validate()) {
      //salvar a venda
      await conta.vender(widget.moeda, double.parse(_valor.text));

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Venda realizada com sucesso')));
    }
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();
    conta = Provider.of<ContaRepository>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.moeda.name)),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image.network(
                        widget.moeda.icone,
                        scale: 2.5,
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                    Text(
                      real.format(widget.moeda.preco),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        color: Colors.grey[800],
                      ),
                    )
                  ],
                ),
              ),
              getGrafico(),
              (quantidade > 0)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: Text(
                          '$quantidade ${widget.moeda.sigla}',
                          style: TextStyle(fontSize: 20, color: Colors.teal),
                        ),
                        margin: EdgeInsets.only(bottom: 24),
                        padding: EdgeInsets.all(12),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                      ),
                    )
                  : Container(margin: EdgeInsets.only(bottom: 24)),
              Form(
                  key: _form,
                  child: TextFormField(
                    controller: _valor,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor',
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                        suffix: Text('reais', style: TextStyle(fontSize: 14))),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o valor da compra';
                      } else if (double.parse(value) < 50) {
                        return 'Compra minima é R\$50,00';
                      } else if (double.parse(value) > conta.saldo) {
                        return 'Você não possui saldo suficiente!';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        quantidade = (value.isEmpty)
                            ? 0
                            : double.parse(value) / widget.moeda.preco;
                      });
                    },
                  )),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 24),
                child: ElevatedButton(
                    onPressed: comprar,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_circle_down_sharp),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child:
                              Text('Comprar', style: TextStyle(fontSize: 20)),
                        )
                      ],
                    )),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 24),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    onPressed: vender,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_circle_up_outlined),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Vender', style: TextStyle(fontSize: 20)),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  readNumberFormat() {
    final loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }
}
