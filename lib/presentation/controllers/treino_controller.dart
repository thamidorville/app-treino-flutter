import 'package:flutter/material.dart';

import '../../domain/entidades/treino.dart';
import '../../domain/entidades/exercicio.dart';
import '../../data/datasources/treino_datasource.dart';

class TreinoController extends ChangeNotifier {
  final TreinoDatasource _datasource = TreinoDatasource();

  List<Treino> _treinos = [];
  List<Treino> get treinos => _treinos;

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  Future<void> carregarTreinos() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _treinos = await _datasource.listarTodos();
    } catch (e) {
      _erro = 'Erro ao carregar treinos: $e';
    }

    _carregando = false;
    notifyListeners();
  }

  Future<String?> criarTreino({
    required String nome,
    required String alunoNome,
    required String alunoEmail,
    required List<Exercicio> exercicios,
  }) async {
    _erro = null;

    try {
      final agora = DateTime.now();

      final treino = Treino(
        nome: nome,
        alunoNome: alunoNome,
        alunoEmail: alunoEmail,
        exercicios: exercicios,
        criadoEm: agora,
        atualizadoEm: agora,
      );

      final id = await _datasource.criar(treino);
      await carregarTreinos();
      return id;
    } catch (e) {
      _erro = 'Erro ao criar treino: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> atualizarTreino(Treino treino) async {
    _erro = null;

    try {
      final treinoAtualizado = treino.copiarCom(
        atualizadoEm: DateTime.now(),
      );

      await _datasource.atualizar(treinoAtualizado);
      await carregarTreinos();
    } catch (e) {
      _erro = 'Erro ao atualizar treino: $e';
      notifyListeners();
    }
  }

  Future<void> excluirTreino(String id) async {
    _erro = null;

    try {
      await _datasource.excluir(id);
      _treinos = _treinos.where((t) => t.id != id).toList();
      notifyListeners();
    } catch (e) {
      _erro = 'Erro ao excluir treino: $e';
      notifyListeners();
    }
  }
}
