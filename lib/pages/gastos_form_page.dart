import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../controllers/gasto_controller.dart';
import '../models/gasto.dart';
import '../widgets/brl_currency_input_formatter.dart';

class GastosFormPage extends StatefulWidget {
  final GastoController controller;
  final Gasto? gastoParaEditar;

  const GastosFormPage({
    super.key,
    required this.controller,
    this.gastoParaEditar,
  });

  @override
  State<GastosFormPage> createState() => _GastosFormPageState();
}

class _GastosFormPageState extends State<GastosFormPage> {
  TextEditingController descricaoCtrl = TextEditingController();
  TextEditingController valorCtrl = TextEditingController();
  DateTime dataSelecionada = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final double minValor = 0.01;
  final double maxValor = 1000000.0;

  @override
  void initState() {
    super.initState();

    if (widget.gastoParaEditar != null) {
      descricaoCtrl.text = widget.gastoParaEditar!.descricao;
      final nf = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
      valorCtrl.text = nf.format(widget.gastoParaEditar!.valor).trim();
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
                if (widget.gastoParaEditar == null) {
                  widget.controller.adicionarGasto(
                    descricaoCtrl.text.trim(),
                    valor,
                    dataSelecionada,
                  );
                } else {
                  widget.controller.atualizarGasto(
                    widget.gastoParaEditar!.id,
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
