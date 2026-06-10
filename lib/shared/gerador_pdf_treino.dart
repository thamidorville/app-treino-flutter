import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../domain/entidades/treino.dart';

class GeradorPdfTreino {
  static const _corPrimaria = PdfColors.deepPurple700;
  static const _corPrimariaClara = PdfColors.deepPurple50;
  static const _corAcento = PdfColors.amber700;
  static const _corTexto = PdfColors.grey900;
  static const _corTextoClaro = PdfColors.grey600;
  static const _corBorda = PdfColors.grey300;
  static const _corFundoLinha = PdfColors.grey50;

  static Future<void> gerarEVisualizar(Treino treino) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(treino),
              pw.SizedBox(height: 24),
              _buildInfoAluno(treino),
              pw.SizedBox(height: 28),
              _buildTituloSecao('EXERCICIOS'),
              pw.SizedBox(height: 12),
              _buildTabelaExercicios(treino),
              pw.Spacer(),
              _buildRodape(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'treino_${treino.alunoNome.toLowerCase().replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _buildHeader(Treino treino) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: pw.BoxDecoration(
        color: _corPrimaria,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'FICHA DE TREINO',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
              letterSpacing: 2,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            treino.nome.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoAluno(Treino treino) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _corPrimariaClara,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: _corBorda),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ALUNO(A)',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: _corTextoClaro,
                    letterSpacing: 1,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  treino.alunoNome,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: _corTexto,
                  ),
                ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'E-MAIL',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: _corTextoClaro,
                    letterSpacing: 1,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  treino.alunoEmail,
                  style: pw.TextStyle(
                    fontSize: 11,
                    color: _corTexto,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTituloSecao(String titulo) {
    return pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 20,
          decoration: pw.BoxDecoration(
            color: _corAcento,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Text(
          titulo,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: _corTexto,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTabelaExercicios(Treino treino) {
    return pw.Table(
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: _corBorda, width: 0.5),
        bottom: pw.BorderSide(color: _corBorda, width: 0.5),
        top: pw.BorderSide(color: _corBorda, width: 0.5),
        left: pw.BorderSide(color: _corBorda, width: 0.5),
        right: pw.BorderSide(color: _corBorda, width: 0.5),
      ),
      columnWidths: {
        0: const pw.FlexColumnWidth(0.4),
        1: const pw.FlexColumnWidth(1.8),
        2: const pw.FlexColumnWidth(2.5),
        3: const pw.FlexColumnWidth(0.8),
        4: const pw.FlexColumnWidth(1.2),
        5: const pw.FlexColumnWidth(2.5),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _corPrimaria),
          children: [
            _celulaHeader('#'),
            _celulaHeader('GRUPO'),
            _celulaHeader('EXERCICIO'),
            _celulaHeader('SERIES'),
            _celulaHeader('REPS'),
            _celulaHeader('OBS'),
          ],
        ),
        ...treino.exercicios.asMap().entries.map((entry) {
          final index = entry.key;
          final ex = entry.value;
          final corFundo = index.isEven ? _corFundoLinha : PdfColors.white;

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: corFundo),
            children: [
              _celula('${ex.ordem}', centralizado: true, bold: true),
              _celula(ex.grupoMuscular),
              _celula(ex.nome, bold: true),
              _celula('${ex.series}x', centralizado: true),
              _celula(ex.repeticoes, centralizado: true),
              _celula(ex.observacoes),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildRodape() {
    return pw.Column(
      children: [
        pw.Divider(color: _corBorda),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Gerado pelo App Treino',
              style: pw.TextStyle(fontSize: 9, color: _corTextoClaro),
            ),
            pw.Text(
              'Bons treinos!',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: _corPrimaria,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _celulaHeader(String texto) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: pw.Text(
        texto,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
          color: PdfColors.white,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _celula(
    String texto, {
    bool centralizado = false,
    bool bold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: pw.Text(
        texto,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: _corTexto,
        ),
        textAlign: centralizado ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }
}
