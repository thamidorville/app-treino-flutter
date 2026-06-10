import '../../domain/entidades/exercicio.dart';

class ExercicioModelo extends Exercicio {
  const ExercicioModelo({
    required super.grupoMuscular,
    required super.nome,
    required super.series,
    required super.repeticoes,
    super.observacoes,
    required super.ordem,
  });

  factory ExercicioModelo.deMap(Map<String, dynamic> map) {
    return ExercicioModelo(
      grupoMuscular: map['grupo_muscular'] ?? '',
      nome: map['nome'] ?? '',
      series: map['series'] ?? 0,
      repeticoes: map['repeticoes'] ?? '',
      observacoes: map['observacoes'] ?? '',
      ordem: map['ordem'] ?? 0,
    );
  }

  Map<String, dynamic> paraMap() {
    return {
      'grupo_muscular': grupoMuscular,
      'nome': nome,
      'series': series,
      'repeticoes': repeticoes,
      'observacoes': observacoes,
      'ordem': ordem,
    };
  }

  factory ExercicioModelo.deEntidade(Exercicio entidade) {
    return ExercicioModelo(
      grupoMuscular: entidade.grupoMuscular,
      nome: entidade.nome,
      series: entidade.series,
      repeticoes: entidade.repeticoes,
      observacoes: entidade.observacoes,
      ordem: entidade.ordem,
    );
  }
}
