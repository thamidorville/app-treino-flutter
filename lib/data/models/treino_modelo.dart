import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entidades/treino.dart';
import '../../domain/entidades/exercicio.dart';
import 'exercicio_modelo.dart';

class TreinoModelo extends Treino {
  const TreinoModelo({
    super.id,
    required super.nome,
    required super.alunoNome,
    required super.alunoEmail,
    required super.exercicios,
    required super.criadoEm,
    required super.atualizadoEm,
  });

  factory TreinoModelo.deDocumento(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;

    return TreinoModelo(
      id: doc.id,
      nome: map['nome'] ?? '',
      alunoNome: map['aluno_nome'] ?? '',
      alunoEmail: map['aluno_email'] ?? '',
      exercicios: _mapearExercicios(map['exercicios']),
      criadoEm: (map['criado_em'] as Timestamp).toDate(),
      atualizadoEm: (map['atualizado_em'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> paraMap() {
    return {
      'nome': nome,
      'aluno_nome': alunoNome,
      'aluno_email': alunoEmail,
      'exercicios': exercicios
          .map((e) => ExercicioModelo.deEntidade(e).paraMap())
          .toList(),
      'criado_em': Timestamp.fromDate(criadoEm),
      'atualizado_em': Timestamp.fromDate(atualizadoEm),
    };
  }

  factory TreinoModelo.deEntidade(Treino entidade) {
    return TreinoModelo(
      id: entidade.id,
      nome: entidade.nome,
      alunoNome: entidade.alunoNome,
      alunoEmail: entidade.alunoEmail,
      exercicios: entidade.exercicios,
      criadoEm: entidade.criadoEm,
      atualizadoEm: entidade.atualizadoEm,
    );
  }

  static List<Exercicio> _mapearExercicios(dynamic lista) {
    if (lista == null) return [];
    return (lista as List)
        .map((item) => ExercicioModelo.deMap(item as Map<String, dynamic>))
        .toList();
  }
}
