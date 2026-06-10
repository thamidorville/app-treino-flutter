import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/treino_controller.dart';
import '../../shared/gerador_pdf_treino.dart';
import 'formulario_treino_pagina.dart';

class ListaTreinosPagina extends StatefulWidget {
  const ListaTreinosPagina({super.key});

  @override
  State<ListaTreinosPagina> createState() => _ListaTreinosPaginaState();
}

class _ListaTreinosPaginaState extends State<ListaTreinosPagina> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TreinoController>().carregarTreinos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final corPrimaria = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Meus Treinos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<TreinoController>(
        builder: (context, controller, child) {
          if (controller.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.erro != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                    const SizedBox(height: 12),
                    Text(
                      controller.erro!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.treinos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum treino cadastrado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque no + para criar o primeiro treino',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.treinos.length,
            itemBuilder: (context, index) {
              final treino = controller.treinos[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormularioTreinoPagina(treino: treino),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                treino.nome,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: corPrimaria.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${treino.exercicios.length} exerc.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: corPrimaria,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              treino.alunoNome,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                treino.alunoEmail,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                GeradorPdfTreino.gerarEVisualizar(treino);
                              },
                              icon: const Icon(Icons.picture_as_pdf, size: 18),
                              label: const Text('PDF'),
                              style: TextButton.styleFrom(
                                foregroundColor: corPrimaria,
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton.icon(
                              onPressed: () async {
                                if (treino.id == null) return;

                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Excluir treino?'),
                                    content: Text(
                                      'Tem certeza que deseja excluir "${treino.nome}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmar == true) {
                                  await controller.excluirTreino(treino.id!);
                                }
                              },
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text('Excluir'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FormularioTreinoPagina(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
