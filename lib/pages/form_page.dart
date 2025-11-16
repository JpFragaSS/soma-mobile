import 'package:flutter/material.dart';
import '../controllers/ganho_controller.dart';
import '../models/ganho.dart';

class FormPage extends StatefulWidget {
  final GanhoController controller;
  final Ganho? ganhoParaEditar;

  FormPage({required this.controller, this.ganhoParaEditar});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController descricaoCtrl = TextEditingController();
  TextEditingController valorCtrl = TextEditingController();
  DateTime dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.ganhoParaEditar != null) {
      descricaoCtrl.text = widget.ganhoParaEditar!.descricao;
      valorCtrl.text = widget.ganhoParaEditar!.valor.toString();
      dataSelecionada = widget.ganhoParaEditar!.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ganhoParaEditar == null ? "Adicionar Ganho" : "Editar Ganho",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descricaoCtrl,
              decoration: InputDecoration(labelText: "Descrição"),
            ),

            TextField(
              controller: valorCtrl,
              decoration: InputDecoration(labelText: "Valor"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () {
                if (widget.ganhoParaEditar == null) {
                  widget.controller.adicionarGanho(
                    descricaoCtrl.text,
                    double.parse(valorCtrl.text),
                    dataSelecionada,
                  );
                } else {
                  widget.controller.atualizarGanho(
                    widget.ganhoParaEditar!.id,
                    descricaoCtrl.text,
                    double.parse(valorCtrl.text),
                    dataSelecionada,
                  );
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
