import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/controllers/treino_controller.dart';
import 'presentation/pages/lista_treinos_pagina.dart';
import 'shared/tema.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TreinoController(),
      child: MaterialApp(
        title: 'App Treino',
        debugShowCheckedModeBanner: false,
        theme: AppTema.tema,
        home: const ListaTreinosPagina(),
      ),
    );
  }
}
