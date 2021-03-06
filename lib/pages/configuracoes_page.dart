import 'dart:io';

import 'package:cryptocoins/configs/app_settings.dart';
import 'package:cryptocoins/pages/documentos_page.dart';
import 'package:cryptocoins/repositories/conta_repository.dart';
import 'package:cryptocoins/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfiguracoesPage extends StatefulWidget {
  ConfiguracoesPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  XFile? comprovante;
  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Configurações de Conta')),
      ),
      body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              ListTile(
                title: Text('Saldo'),
                subtitle: Text(
                  real.format(conta.saldo),
                  style: TextStyle(fontSize: 25, color: Colors.blueAccent),
                ),
                trailing:
                    IconButton(onPressed: updateSaldo, icon: Icon(Icons.edit)),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Escanear um documento'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocumentosPage(),
                      fullscreenDialog: true),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text('Enviar comprovante de depósito'),
                onTap: selecionarComprovante,
                trailing: comprovante != null
                    ? Image.file(File(comprovante!.path))
                    : null,
              ),
              Divider(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: OutlinedButton(
                        onPressed: () => context.read<AuthService>().logout(),
                        style: OutlinedButton.styleFrom(primary: Colors.red),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Sair do App',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              )
            ],
          )),
    );
  }

  selecionarComprovante() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => comprovante = file);
    } catch (e) {
      print(e);
    }
  }

  updateSaldo() {
    final form = GlobalKey<FormState>();
    final valor = TextEditingController();
    final conta = context.read<ContaRepository>();

    valor.text = conta.saldo.toString();

    AlertDialog dialog = AlertDialog(
      title: Text('Atualizar o Saldo'),
      content: Form(
          key: form,
          child: TextFormField(
            controller: valor,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            validator: (value) {
              if (value!.isEmpty) return 'Informe o valor do saldo';
              return null;
            },
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('CANCELAR')),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                conta.setSaldo(double.parse(valor.text));
                Navigator.pop(context);
              }
            },
            child: Text('SALVAR')),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
