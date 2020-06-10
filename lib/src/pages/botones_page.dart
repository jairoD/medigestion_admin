import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medigestion_admin/src/blocs/provider.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
import 'package:medigestion_admin/src/models/doctor_model.dart';
import 'package:medigestion_admin/src/pages/chat_page.dart';
import 'package:medigestion_admin/src/pages/doctorChatList_page.dart';
import 'package:medigestion_admin/src/pages/formulaMedica_page.dart';
import 'package:medigestion_admin/src/pages/profileUser_page.dart';
import 'package:medigestion_admin/src/pages/reviewDoctor_page.dart';
import 'package:medigestion_admin/src/providers/firebaseUser_provider.dart';

import 'myCalendar_page.dart';

class BotonesPage extends StatefulWidget {
  static final String routeName = 'botones';

  @override
  _BotonesPageState createState() => _BotonesPageState();
}

class _BotonesPageState extends State<BotonesPage> {
  UserBloc userBloc;
  FirebaseUser myUser;
  List<Color> colorDisabledList = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.orange
  ];

  List<Color> colorAvailableList = [
    Colors.blue,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.orange
  ];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    FirebaseUserProvider().getUser().then((value) {
      setState(() {
        myUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.userBlocOf(context);
    final firebaseUserProvider = new FirebaseUserProvider();

    return new StreamBuilder(
      stream: userBloc.userStream,
      builder: (BuildContext context, AsyncSnapshot<Doctor> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor)),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data.available == "1") {
            return createMainView(
                context, firebaseUserProvider, colorAvailableList);
          } else {
            return createMainView(
                context, firebaseUserProvider, colorDisabledList);
          }
        } else {
          return new Container();
        }
      },
    );
  }

  Widget createMainView(BuildContext context,
      FirebaseUserProvider firebaseUserProvider, List<Color> colores) {
    return new Scaffold(
        body: new Center(
          child: _selectedIndex == 0
              ? new Stack(
                  children: <Widget>[
                    _fondoApp(),
                    new SingleChildScrollView(
                      child: new Column(
                        children: <Widget>[
                          _titulos(),
                          _botonesRedondeados(context, colores),
                        ],
                      ),
                    )
                  ],
                )
              : _selectedIndex == 1
                  ? new MyCalendar(user: myUser,)
                  : new ReviewDoctor()
        ),
        bottomNavigationBar: _bottomNavigationBar(context),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.exit_to_app),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            firebaseUserProvider.signOut();
          },
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _fondoApp() {
    final gradiente = new Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              begin: FractionalOffset(0.0, 0.6),
              end: FractionalOffset(0.0, 1.0),
              colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0),
          ])),
    );

    final cajaRosa = Transform.rotate(
        angle: -pi / 5.0,
        child: new Container(
          height: 360.0,
          width: 360.0,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(80.0),
              gradient: new LinearGradient(colors: [
                Color.fromRGBO(236, 98, 188, 1.0),
                Color.fromRGBO(241, 142, 172, 1.0),
              ])),
        ));

    return new Stack(
      children: <Widget>[
        gradiente,
        new Positioned(top: -100.0, child: cajaRosa)
      ],
    );
  }

  Widget _titulos() {
    //firebaseUserProvider.getUser().then((value) => print('email botones: ${value.email}'));
    return new SafeArea(
      child: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              'Hola Mundo!',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            new SizedBox(
              height: 10.0,
            ),
            new Text(
              'Gestiona tus citas de una manera mas rapida',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Color.fromRGBO(55, 57, 84, 1.0),
          primaryColor: Colors.pinkAccent,
          textTheme: Theme.of(context).textTheme.copyWith(
              caption:
                  new TextStyle(color: Color.fromRGBO(116, 117, 152, 1.0)))),
      child: new BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          fixedColor: Colors.pink,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  size: 30.0,
                ),
                title: new Container()),
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.calendar_today,
                  size: 30.0,
                ),
                title: new Container()),
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.assignment,
                  size: 30.0,
                ),
                title: new Container()),
          ]),
    );
  }

  Widget _botonesRedondeados(BuildContext context, List<Color> colores) {
    return new Table(
//Los children seran los elementos que esten en posicion horizontal
      children: <TableRow>[
        //Los tableRow seran las filas
        new TableRow(children: <Widget>[
          _crearBotonRedondeado(context, colores[0], Icons.message, 'Chat',
              DoctorListPage.routeName),
          _crearBotonRedondeado(context, colores[1], Icons.assignment,
              'General', ChatPage.routeName),
        ]),
        new TableRow(children: <Widget>[
          _crearBotonRedondeado(context, colores[2], Icons.assignment,
              'Formula', FormulaMedicaPage.routeName),
          _crearBotonRedondeado(context, colores[3], Icons.account_circle,
              'Perfil', ProfileUserPage.routeName),
        ]),
      ],
    );
  }

  Widget _crearBotonRedondeado(BuildContext context, Color color,
      IconData icono, String texto, String ruta) {
    final botonRendondeado = new ClipRect(
      child: new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: new Container(
          height: 180.0,
          margin: EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
              color: Color.fromRGBO(62, 66, 107, 0.7),
              borderRadius: BorderRadius.circular(20.0)),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new SizedBox(
                height: 5.0,
              ),
              new CircleAvatar(
                backgroundColor: color,
                radius: 35.0,
                child: new Icon(
                  icono,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              new Text(
                texto,
                style: new TextStyle(color: color),
              ),
              new SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
    if (texto == "Perfil") {
      return new GestureDetector(
          child: botonRendondeado,
          onTap: () => Navigator.pushNamed(
                context,
                ruta,
              ));
    } else {
      return new GestureDetector(
          child: botonRendondeado,
          onTap: (userBloc.userLastValue.available == "1")
              ? () {
                  setState(() {
                    Navigator.pushNamed(
                      context,
                      ruta,
                    );
                  });
                }
              : () {
                  Fluttertoast.showToast(msg: "Ingresa datos de perfil");
                });
    }
  }
}
