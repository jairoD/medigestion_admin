import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/blocs/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
import 'package:medigestion_admin/src/models/user_model.dart';

class MyCitaForm extends StatefulWidget {
  final DocumentSnapshot info;
  MyCitaForm({Key key, this.info}) : super(key: key);

  @override
  _MyCitaFormState createState() => _MyCitaFormState();
}

class _MyCitaFormState extends State<MyCitaForm> {
  DateTime aux;
  //ProductosBloc productosBloc;
  User userModel;
  //final productoProvider = new ProductoProvider();
  UserBloc userBloc;
  bool enabled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aux = DateTime.parse(widget.info['dia']);
  }

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.userBlocOf(context);
    return new StreamBuilder(
      stream: userBloc.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Scaffold(
            appBar: new AppBar(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Center(
                    child: new Text('Informacion de la cita',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Paciente: ${snapshot.data.name} ${snapshot.data.lastName}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text(
                      int.parse(widget.info['hora']) >= 12
                          ? 'Hora de la cita: ${widget.info['hora']} p. m.'
                          : 'Hora de la cita: ${widget.info['hora']} a. m.',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text(
                      'Dia de la cita: ${(aux.day)}-${(aux.month)}-${(aux.year)}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Medico: ${widget.info['medicofullName']}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Especialidad: ${widget.info['medicoEspecialidad']}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Center(
                    child: new FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: enabled == true
                            ? () {
                                setState(() {
                                  enabled = false;
                                });
                                Firestore.instance
                                    .collection('citas')
                                    .document(widget.info.documentID)
                                    .delete()
                                    .then((value) {
                                  setState(() {
                                    enabled = true;
                                  });
                                  Fluttertoast.showToast(msg: 'Cita cancelada');
                                  Navigator.pop(context);
                                }).catchError((e) {
                                  Fluttertoast.showToast(
                                      msg: 'Error al cancelar cita.');
                                  setState(() {
                                    enabled = true;
                                  });
                                });
                              }
                            : null,
                        child: enabled == true
                            ? new Text(
                                'Cancelar Cita',
                                style: new TextStyle(color: Colors.white),
                              )
                            : CircularProgressIndicator()),
                  )
                ],
              ),
            ),
          );
        } else {
          return new Scaffold(
            body: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
