import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/ganho_controller.dart';
import '../controllers/gasto_controller.dart';
import 'form_page.dart';
import 'gastos_form_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GanhoController ganhoController = GanhoController();
  final GastoController gastoController = GastoController();

  double get totalGanhos => ganhoController.listaGanhos.fold(0.0, (s, g) => s + g.valor);
  double get totalGastos => gastoController.listaGastos.fold(0.0, (s, g) => s + g.valor);
  double get saldoAtual => totalGanhos - totalGastos;
  final NumberFormat moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    final corSaldo = saldoAtual >= 0 ? Colors.green : Colors.red;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 24),
                  const SizedBox(width: 12),
                  Container(
                    height: 26,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text('Seu saldo', style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              Text(
                moeda.format(saldoAtual).replaceAll('.', '#').replaceAll(',', '.').replaceAll('#', ','),
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: corSaldo),
              ),
              const SizedBox(height: 16),
              const Text('Adicionar', style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormPage(controller: ganhoController)),
                      ).then((_) => setState(() {}));
                    },
                    child: const Text('Ganhos'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GastosFormPage(controller: gastoController)),
                      ).then((_) => setState(() {}));
                    },
                    child: const Text('Despesas'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Transações', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            ..._transacoesOrdenadas().take(8).map(
                              (t) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(t.descricao),
                                    Text(
                                      t.isDespesa
                                          ? '- ${_formatar(t.valor)}'
                                          : _formatar(t.valor),
                                      style: TextStyle(color: t.isDespesa ? Colors.red : Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatar(double v) {
    return moeda
        .format(v)
        .replaceAll('.', '#')
        .replaceAll(',', '.')
        .replaceAll('#', ',');
  }

  List<_Transacao> _transacoesOrdenadas() {
    final ganhos = ganhoController.listaGanhos
        .map((g) => _Transacao(descricao: g.descricao, valor: g.valor, data: g.data, isDespesa: false));
    final gastos = gastoController.listaGastos
        .map((g) => _Transacao(descricao: g.descricao, valor: g.valor, data: g.data, isDespesa: true));
    final todos = [...ganhos, ...gastos];
    todos.sort((a, b) => b.data.compareTo(a.data));
    return todos;
  }
}

class _Transacao {
  final String descricao;
  final double valor;
  final DateTime data;
  final bool isDespesa;
  _Transacao({required this.descricao, required this.valor, required this.data, required this.isDespesa});
}
