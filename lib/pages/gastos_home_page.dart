import 'package:flutter/material.dart';
import '../controllers/gasto_controller.dart';
import 'gastos_form_page.dart';

class GastosHomePage extends StatefulWidget {
  const GastosHomePage({super.key});

  @override
  State<GastosHomePage> createState() => _GastosHomePageState();
}

class _GastosHomePageState extends State<GastosHomePage> {
  final GastoController controller = GastoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Despesas")),
      body: ListView.builder(
        itemCount: controller.listaGastos.length,
        itemBuilder: (context, index) {
          final gasto = controller.listaGastos[index];

          return ListTile(
            title: Text(gasto.descricao),
            subtitle: Text("R\$ ${gasto.valor.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                controller.deletarGasto(gasto.id);
                setState(() {});
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GastosFormPage(
                    controller: controller,
                    gastoParaEditar: gasto,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GastosFormPage(controller: controller),
            ),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
