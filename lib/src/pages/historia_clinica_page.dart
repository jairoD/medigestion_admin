import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/blocs/provider.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
import 'package:medigestion_admin/src/pages/PdfPreviewScreen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

 class HistoriaClinicaPage extends StatefulWidget {
  static final String routeName = 'historiaClinica';
  String uid;
  HistoriaClinicaPage({this.uid=""});
  @override
  _HistoriaClinicaPageState createState() => _HistoriaClinicaPageState();
}

class _HistoriaClinicaPageState extends State<HistoriaClinicaPage> {
  final pdf = pw.Document();

  final String test= "Hola test PDF";


  writeOnPDf(DocumentSnapshot document){
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context){
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text("Historia clinica")
            ),
              pw.Table.fromTextArray(context: context, data: <List<String>>[
             
              <String>['Solicitud', 'Información'],
              <String>['Nombre', document['nombre']],
              <String>['Registro', document['nRegistro']],
              <String>['Sexo', document['sexo']],
              <String>['Edad', document['edad']],
              <String>['Cuarto', document['cuarto']],
              <String>['Sala', document['sala']],
              <String>['Ocupación', document['Ocupacion']],
              <String>['Motivo de Consulta', document['Motivo de consulta']],
              <String>['Antecedentes personales patologicos'],
              <String>['Cardiovasculares', document['aCardiovasculares']],
              <String>['Pulmonares', document['aPulmonares']],
              <String>['Digestivos', document['Digestivos']],
              <String>['Diabetes', document['Diabetes']],
              <String>['Renales', document['aRenales']],
              <String>['Quirurgicos', document['aQuirurgicos']],
              <String>['Alérgicos', document['alergicos']],
              <String>['Transfusiones', document['transfusiones']],
              <String>['Medicamentos especifique', document['medicamentos']],
              <String>['Antecedentes personales no patologicos'],
              <String>['Alcohol', document['pAlcohol']],
              <String>['Tabaquismo', document['pTabaquismo']],
              <String>['Drogas', document['pDrogas']],
              <String>['Inmunizaciones', document['pInmunizaciones']],
              <String>['Otros', document['Otros']],
              <String>['Antecedentes familia', document['antecedentesFamilia']],
              

            ],
            ),
          ];
        }
      )
    );  
  }

  Future savePDF() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = new File("$documentPath/example.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    
    final historiaCLinica = new Container(
      child: new StreamBuilder(
        stream: Firestore.instance.collection('users').document(widget.uid).collection(widget.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
              _buildItem(context,index,snapshot.data.documents[index])
            );
          } else {
            return new Center(
                child: new CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ));
          }
        },
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Historia Clinica'),
      ),
        body: historiaCLinica,
    );
  }

  Widget _buildItem(BuildContext context, int i, DocumentSnapshot document) {
    DateTime myDateTime = DateTime.parse(document['fecha'].toDate().toString());
    String formattedDateTime = DateFormat('yyyy/MM/dd').format(myDateTime);
    return new FadeInLeft(
        delay: new Duration(milliseconds: 100*i),
        child: new ListTile(
        title: new Text(formattedDateTime),
        subtitle: new Text('Dr.${document['doctorName']}'),
        trailing: new Icon(Icons.insert_drive_file),
        onTap:() async{
              writeOnPDf(document);
              await savePDF();
              Directory documentDirectory = await getApplicationDocumentsDirectory();

            String documentPath = documentDirectory.path;

            String fullPath = "$documentPath/example.pdf";

            Navigator.push(context, MaterialPageRoute(
              builder: (context) => PdfPreviewScreen(path: fullPath,)
            )); 
      
        }),
    );
  }
}