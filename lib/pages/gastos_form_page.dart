import 'package:flutter/material.dart';
import '../controllers/gasto_controller.dart';
import '../models/gasto.dart';

class GastosFormPage extends StatefulWidget {
  final GastoController controller;
  final Gasto? gastoParaEditar;

  GastosFormPage({required this.controller, this.gastoParaEditar});

  @override
  State<GastosFormPage> createState() => _GastosFormPageState();
}

class _GastosFormPageState extends State<GastosFormPage> {
  TextEditingController descricaoCtrl = TextEditingController();
  TextEditingController valorCtrl = TextEditingController();
  DateTime dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.gastoParaEditar != null) {
      descricaoCtrl.text = widget.gastoParaEditar!.descricao;
      valorCtrl.text = widget.gastoParaEditar!.valor.toString();
      dataSelecionada = widget.gastoParaEditar!.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gastoParaEditar == null
              ? "Adicionar Despesa"
              : "Editar Despesa",
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
                if (widget.gastoParaEditar == null) {
                  widget.controller.adicionarGasto(
                    descricaoCtrl.text,
                    double.parse(valorCtrl.text),
                    dataSelecionada,
                  );
                } else {
                  widget.controller.atualizarGasto(
                    widget.gastoParaEditar!.id,
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
