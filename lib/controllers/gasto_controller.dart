import '../models/gasto.dart';

class GastoController {
  // Lista que vai armazenar as despesas
  List<Gasto> listaGastos = [];

  // Contador para gerar IDs
  int contadorId = 1;

  // CREATE
  void adicionarGasto(String descricao, double valor, DateTime data) {
    listaGastos.add(
      Gasto(id: contadorId++, descricao: descricao, valor: valor, data: data),
    );
  }

  // READ
  List<Gasto> pegarGastos() {
    return listaGastos;
  }

  // UPDATE
  void atualizarGasto(int id, String descricao, double valor, DateTime data) {
    final index = listaGastos.indexWhere((g) => g.id == id);

    if (index != -1) {
      listaGastos[index].descricao = descricao;
      listaGastos[index].valor = valor;
      listaGastos[index].data = data;
    }
  }

  // DELETE
  void deletarGasto(int id) {
    listaGastos.removeWhere((g) => g.id == id);
  }
}
