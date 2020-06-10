import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreviewScreen extends StatelessWidget {
  static final routeName = "pdfPage";
  final String path;

  PdfPreviewScreen({this.path});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
      ),
      path: path,
    );
  }
}