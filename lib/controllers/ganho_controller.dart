import '../models/ganho.dart';

class GanhoController {
  List<Ganho> listaGanhos = [];

  int contadorId = 1;

  void adicionarGanho(String descricao, double valor, DateTime data) {
    listaGanhos.add(
      Ganho(id: contadorId++, descricao: descricao, valor: valor, data: data),
    );
  }

  List<Ganho> pegarGanhos() {
    return listaGanhos;
  }

  void atualizarGanho(int id, String descricao, double valor, DateTime data) {
    final index = listaGanhos.indexWhere((g) => g.id == id);

    if (index != -1) {
      listaGanhos[index].descricao = descricao;
      listaGanhos[index].valor = valor;
      listaGanhos[index].data = data;
    }
  }

  void deletarGanho(int id) {
    listaGanhos.removeWhere((g) => g.id == id);
  }
}
