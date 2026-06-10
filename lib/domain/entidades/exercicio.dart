class Exercicio {
  final String grupoMuscular;
  final String nome;
  final int series;
  final String repeticoes;
  final String observacoes;
  final int ordem;

  const Exercicio({
    required this.grupoMuscular,
    required this.nome,
    required this.series,
    required this.repeticoes,
    this.observacoes = '',
    required this.ordem,
  });

  Exercicio copiarCom({
    String? grupoMuscular,
    String? nome,
    int? series,
    String? repeticoes,
    String? observacoes,
    int? ordem,
  }) {
    return Exercicio(
      grupoMuscular: grupoMuscular ?? this.grupoMuscular,
      nome: nome ?? this.nome,
      series: series ?? this.series,
      repeticoes: repeticoes ?? this.repeticoes,
      observacoes: observacoes ?? this.observacoes,
      ordem: ordem ?? this.ordem,
    );
  }
}
