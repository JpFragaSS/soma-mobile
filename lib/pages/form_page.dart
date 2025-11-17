import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../controllers/ganho_controller.dart';
import '../models/ganho.dart';
import '../widgets/brl_currency_input_formatter.dart';

class FormPage extends StatefulWidget {
  final GanhoController controller;
  final Ganho? ganhoParaEditar;

  const FormPage({super.key, required this.controller, this.ganhoParaEditar});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController descricaoCtrl = TextEditingController();
  TextEditingController valorCtrl = TextEditingController();
  DateTime dataSelecionada = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final double minValor = 0.01;
  final double maxValor = 1000000.0;

  @override
  void initState() {
    super.initState();

    if (widget.ganhoParaEditar != null) {
      descricaoCtrl.text = widget.ganhoParaEditar!.descricao;
      final nf = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
      valorCtrl.text = nf.format(widget.ganhoParaEditar!.valor).trim();
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
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
          children: [
            TextFormField(
              controller: descricaoCtrl,
              decoration: InputDecoration(labelText: "Descrição"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Informe a descrição';
                return null;
              },
            ),

            TextFormField(
              controller: valorCtrl,
              decoration: InputDecoration(labelText: "Valor", prefixText: 'R\$ '),
              keyboardType: TextInputType.number,
              inputFormatters: [BrlCurrencyInputFormatter()],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Informe o valor';
                final parsed = double.tryParse(v.replaceAll('.', '').replaceAll(',', '.')) ??
                    double.tryParse(v);
                if (parsed == null) return 'Valor inválido';
                if (parsed < minValor) return 'Mínimo permitido: R\$ ${minValor.toStringAsFixed(2)}';
                if (parsed > maxValor) return 'Máximo permitido: R\$ ${maxValor.toStringAsFixed(2)}';
                return null;
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () {
                if (_formKey.currentState?.validate() != true) return;
                final valor = double.parse(
                  valorCtrl.text.replaceAll('.', '').replaceAll(',', '.'),
                );
                if (widget.ganhoParaEditar == null) {
                  widget.controller.adicionarGanho(
                    descricaoCtrl.text.trim(),
                    valor,
                    dataSelecionada,
                  );
                } else {
                  widget.controller.atualizarGanho(
                    widget.ganhoParaEditar!.id,
                    descricaoCtrl.text.trim(),
                    valor,
                    dataSelecionada,
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
  }
}
