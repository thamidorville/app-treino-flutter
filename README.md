# App Treino

Aplicação web para personal trainers gerenciarem fichas de treino dos seus alunos, com geração de PDF estilizado para compartilhamento.

## Stack

- **Flutter** (Dart) - UI reativa
- **Firebase Firestore** (banco de dados NoSQL em nuvem)
- **Provider** - gerência de estado
- **pdf / printing** (geração de PDF)

## Funcionalidades

- Criar, editar e excluir treinos
- Adicionar exercícios com grupo muscular, séries, repetições e observações
- Persistência em tempo real no Firestore
- Geração de ficha de treino em PDF (layout profissional)
- Validação de formulário

## Arquitetura

Clean Architecture em 3 camadas:

```
lib/
├── domain/          Entidades de negócio (Treino, Exercicio)
├── data/            Models (DTOs), datasources (Firestore)
├── presentation/    Controllers, pages
└── shared/          Tema, utilitários (gerador PDF)
```

## Rodando localmente

```bash
flutter pub get
flutter run -d chrome
```

## Pré-requisitos

- Flutter SDK 3.44+
- Projeto Firebase configurado (Firestore ativado)
- Chrome
