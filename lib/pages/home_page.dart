import 'package:flutter/material.dart';
import '../controllers/ganho_controller.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GanhoController controller = GanhoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Ganhos")),
      body: ListView.builder(
        itemCount: controller.listaGanhos.length,
        itemBuilder: (context, index) {
          final ganho = controller.listaGanhos[index];

          return ListTile(
            title: Text(ganho.descricao),
            subtitle: Text("R\$ ${ganho.valor.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                controller.deletarGanho(ganho.id);
                setState(() {});
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FormPage(controller: controller, ganhoParaEditar: ganho),
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
              builder: (context) => FormPage(controller: controller),
            ),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
