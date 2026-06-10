import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entidades/treino.dart';
import '../models/treino_modelo.dart';

class TreinoDatasource {
  final CollectionReference _colecao =
      FirebaseFirestore.instance.collection('treinos');

  Future<String> criar(Treino treino) async {
    final modelo = TreinoModelo.deEntidade(treino);
    final doc = await _colecao.add(modelo.paraMap());
    return doc.id;
  }

  Future<List<Treino>> listarTodos() async {
    final snapshot = await _colecao
        .orderBy('criado_em', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TreinoModelo.deDocumento(doc))
        .toList();
  }

  Future<Treino?> buscarPorId(String id) async {
    final doc = await _colecao.doc(id).get();

    if (!doc.exists) return null;

    return TreinoModelo.deDocumento(doc);
  }

  Future<void> atualizar(Treino treino) async {
    if (treino.id == null) return;

    final modelo = TreinoModelo.deEntidade(treino);
    await _colecao.doc(treino.id).update(modelo.paraMap());
  }

  Future<void> excluir(String id) async {
    await _colecao.doc(id).delete();
  }
}
