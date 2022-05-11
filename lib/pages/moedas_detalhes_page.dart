import 'package:cryptocoins/models/moeda.dart';
import 'package:flutter/material.dart';

class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;
  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedasDetalhesPageState createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.moeda.name)),
        ),
        body: Column(
          children: [
            Divider(),
            Row(
              children: [
                Image.asset(
                  widget.moeda.icone,
                  width: 40,
                ),
              ],
            )
          ],
        ));
  }
}
