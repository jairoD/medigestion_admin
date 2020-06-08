import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
import 'package:medigestion_admin/src/models/user_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'myCitaForm.dart';

class MyCalendar extends StatefulWidget {
  static final String routeName = 'myCalendar';
  final FirebaseUser user;
  MyCalendar({Key key, this.user}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  User userModel;
  //final productoProvider = new ProductoProvider();
  UserBloc userBloc;
  //dia actual
  DateTime currentDate = new DateTime(new DateTime.now().year,
      new DateTime.now().month, new DateTime.now().day, 12, 12, 12, 12, 12);
  //key global
  GlobalKey myKey = GlobalKey();
  //documento medico seleccionado
  DocumentSnapshot medicoSelected;
  //medico id en el drop
  String namae = '';
  //dia seleccionado de calendario
  String dia = new DateTime(new DateTime.now().year, new DateTime.now().month,
          new DateTime.now().day, 12, 12, 12, 12, 12)
      .toString();
  //keys de tiles en horario
  List<GlobalKey> keys = [
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey()
  ];
  //position
  Offset position;
  //posicion y de las opciones
  List<double> dy;
  CalendarController _calendarController;
  List<String> opciones = ['Agendar cita', 'Cancelar cita', 'Agregar a espera'];
  //horario por defecto
  List<String> horario = [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ];
  String value = '0';
  //citas actuales
  List<DocumentSnapshot> citasActuales;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
    super.initState();
    citasActuales = new List();
    Firestore.instance
        .collection('citas')
        .where('dia', isEqualTo: dia)
        .where('medicoUID', isEqualTo: widget.user.uid)
        .getDocuments()
        .then((value) {
      setState(() {
        citasActuales = value.documents;
      });
    });
    dy = new List();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  getSizeAndPosition() {
    RenderBox box = myKey.currentContext.findRenderObject();
    position = box.localToGlobal(Offset.zero);

    for (var i = 0; i < horario.length; i++) {
      GlobalKey example = keys[1];
      RenderBox box = example.currentContext.findRenderObject();
      position = box.localToGlobal(Offset.zero);
      setState(() {
        dy.add(position.dy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: myKey,
        appBar: new AppBar(),
        body: new CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: TableCalendar(
                startDay: DateTime.now(),
                locale: 'en_US',
                initialCalendarFormat: CalendarFormat.week,
                availableCalendarFormats: const {CalendarFormat.week: 'a'},
                calendarController: _calendarController,
                onDaySelected: (DateTime day, List events) {
                  setState(() {
                    dia = new DateTime(
                            day.year, day.month, day.day, 12, 12, 12, 12, 12)
                        .toString();
                  });
                  getAllCitas(dia);
                  //print('Dia actual: ${currentDate}');
                  //print('Dia seleccionado: ${dia}');
                },
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              bool aux = exists(horario[index]);
              DocumentSnapshot document;
              for (var item in citasActuales) {
                if (item.data['hora'] == horario[index]) {
                  document = item;
                }
              }
              return new Column(
                children: <Widget>[
                  ListTile(
                    key: keys[index],
                    enabled: true,
                    leading: int.parse(horario[index]) < 10
                        ? new Text(
                            '0${horario[index]}:00 a. m.',
                            style: new TextStyle(
                                color: aux
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        : new Text(
                            '${horario[index]}:00 a. m.',
                            style: new TextStyle(
                                color: aux
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                    trailing: aux
                        ? new IconButton(
                            icon: new Icon(
                              Icons.navigate_next,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              print('${horario[index]}');
                              
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyCitaForm(
                                            info: document,
                                          ))).then((value) {
                                getAllCitas(dia);
                              });
                              
                            })
                        : null,
                    title: aux
                        ? new Text(
                            'Tiene cita asignada',
                            style: new TextStyle(
                                color: aux
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        : new Text(
                            '',
                            style: new TextStyle(
                                color: aux
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  new Divider()
                ],
              );
            }, childCount: horario.length))
          ],
        ));
  }

  bool exists(String hora) {
    for (var item in citasActuales) {
      if (item['hora'] == hora) {
        return true;
      }
    }
    return false;
  }

  bool owner(User user) {
    for (var item in citasActuales) {
      if (item['pacienteUid'] == user.uid) {
        print('horario seleccionado: ' + item['pacienteUid']);
        //print(user.uid);
        return true;
      }
    }
    return false;
  }

  getAllCitas(String filt) {
    Firestore.instance
        .collection('citas')
        .where('dia', isEqualTo: filt)
        .where('medicoUID', isEqualTo: widget.user.uid)
        .getDocuments()
        .then((value) {
      print(value.documents.length);
      setState(() {
        citasActuales = value.documents;
      });
    });
  }
}
