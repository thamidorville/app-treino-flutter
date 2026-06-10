import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entidades/exercicio.dart';
import '../../domain/entidades/treino.dart';
import '../controllers/treino_controller.dart';

class FormularioTreinoPagina extends StatefulWidget {
  final Treino? treino;

  const FormularioTreinoPagina({super.key, this.treino});

  @override
  State<FormularioTreinoPagina> createState() => _FormularioTreinoPaginaState();
}

class _FormularioTreinoPaginaState extends State<FormularioTreinoPagina> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _alunoNomeController;
  late final TextEditingController _alunoEmailController;

  final List<_ExercicioForm> _exercicios = [];

  bool get _editando => widget.treino != null;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.treino?.nome ?? '');
    _alunoNomeController =
        TextEditingController(text: widget.treino?.alunoNome ?? '');
    _alunoEmailController =
        TextEditingController(text: widget.treino?.alunoEmail ?? '');

    if (widget.treino != null) {
      for (final exercicio in widget.treino!.exercicios) {
        _exercicios.add(_ExercicioForm.deEntidade(exercicio));
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _alunoNomeController.dispose();
    _alunoEmailController.dispose();
    for (final ex in _exercicios) {
      ex.dispose();
    }
    super.dispose();
  }

  void _adicionarExercicio() {
    setState(() {
      _exercicios.add(_ExercicioForm());
    });
  }

  void _removerExercicio(int index) {
    setState(() {
      _exercicios[index].dispose();
      _exercicios.removeAt(index);
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_exercicios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um exercício.')),
      );
      return;
    }

    final controller = context.read<TreinoController>();

    final exercicios = _exercicios.asMap().entries.map((entry) {
      final index = entry.key;
      final ex = entry.value;
      return Exercicio(
        grupoMuscular: ex.grupoMuscularController.text.trim(),
        nome: ex.nomeController.text.trim(),
        series: int.tryParse(ex.seriesController.text.trim()) ?? 0,
        repeticoes: ex.repeticoesController.text.trim(),
        observacoes: ex.observacoesController.text.trim(),
        ordem: index + 1,
      );
    }).toList();

    if (_editando) {
      final treinoAtualizado = widget.treino!.copiarCom(
        nome: _nomeController.text.trim(),
        alunoNome: _alunoNomeController.text.trim(),
        alunoEmail: _alunoEmailController.text.trim(),
        exercicios: exercicios,
      );
      await controller.atualizarTreino(treinoAtualizado);
    } else {
      await controller.criarTreino(
        nome: _nomeController.text.trim(),
        alunoNome: _alunoNomeController.text.trim(),
        alunoEmail: _alunoEmailController.text.trim(),
        exercicios: exercicios,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Treino' : 'Novo Treino'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Treino',
                hintText: 'Ex: Treino A - Membros Inferiores',
              ),
              validator: (valor) =>
                  valor == null || valor.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _alunoNomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Aluno',
                hintText: 'Ex: Maria',
              ),
              validator: (valor) =>
                  valor == null || valor.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _alunoEmailController,
              decoration: const InputDecoration(
                labelText: 'E-mail do Aluno',
                hintText: 'Ex: maria@email.com',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) return 'Campo obrigatório';
                if (!valor.contains('@')) return 'E-mail inválido';
                return null;
              },
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exercícios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _adicionarExercicio,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._exercicios.asMap().entries.map((entry) {
              final index = entry.key;
              final ex = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Exercício ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removerExercicio(index),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: ex.grupoMuscularController,
                        decoration: const InputDecoration(
                          labelText: 'Grupo Muscular',
                          hintText: 'Ex: Quadríceps',
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: ex.nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Exercício',
                          hintText: 'Ex: Agachamento Livre',
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: ex.seriesController,
                              decoration: const InputDecoration(
                                labelText: 'Séries',
                                hintText: 'Ex: 4',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: ex.repeticoesController,
                              decoration: const InputDecoration(
                                labelText: 'Repetições',
                                hintText: 'Ex: 15, 12, 10',
                              ),
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: ex.observacoesController,
                        decoration: const InputDecoration(
                          labelText: 'Observações (opcional)',
                          hintText: 'Ex: Manter joelhos alinhados',
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _salvar,
                child: Text(_editando ? 'Atualizar Treino' : 'Salvar Treino'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExercicioForm {
  final TextEditingController grupoMuscularController;
  final TextEditingController nomeController;
  final TextEditingController seriesController;
  final TextEditingController repeticoesController;
  final TextEditingController observacoesController;

  _ExercicioForm({
    String grupoMuscular = '',
    String nome = '',
    String series = '',
    String repeticoes = '',
    String observacoes = '',
  })  : grupoMuscularController = TextEditingController(text: grupoMuscular),
        nomeController = TextEditingController(text: nome),
        seriesController = TextEditingController(text: series),
        repeticoesController = TextEditingController(text: repeticoes),
        observacoesController = TextEditingController(text: observacoes);

  factory _ExercicioForm.deEntidade(Exercicio exercicio) {
    return _ExercicioForm(
      grupoMuscular: exercicio.grupoMuscular,
      nome: exercicio.nome,
      series: exercicio.series.toString(),
      repeticoes: exercicio.repeticoes,
      observacoes: exercicio.observacoes,
    );
  }

  void dispose() {
    grupoMuscularController.dispose();
    nomeController.dispose();
    seriesController.dispose();
    repeticoesController.dispose();
    observacoesController.dispose();
  }
}
