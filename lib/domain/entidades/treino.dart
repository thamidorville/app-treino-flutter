import 'exercicio.dart';

class Treino {
  final String? id;
  final String nome;
  final String alunoNome;
  final String alunoEmail;
  final List<Exercicio> exercicios;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  const Treino({
    this.id,
    required this.nome,
    required this.alunoNome,
    required this.alunoEmail,
    required this.exercicios,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  Treino copiarCom({
    String? id,
    String? nome,
    String? alunoNome,
    String? alunoEmail,
    List<Exercicio>? exercicios,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Treino(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      alunoNome: alunoNome ?? this.alunoNome,
      alunoEmail: alunoEmail ?? this.alunoEmail,
      exercicios: exercicios ?? this.exercicios,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}
