import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medigestion_admin/src/pages/chat_page.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot doctorDocument;

  ProfilePage({Key key, @required this.doctorDocument}) : super(key: key);

  @override
  _ProfilePageState createState() =>
      _ProfilePageState(doctorDocument: doctorDocument);
}

class _ProfilePageState extends State<ProfilePage> {
  DocumentSnapshot doctorDocument;

  _ProfilePageState({Key key, @required this.doctorDocument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 54, 101, 1.0),
        elevation: 0.0,
        //brightness: Brightness.light,
        //iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 320.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                alignment: Alignment.topCenter, // where to position the child
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          begin: FractionalOffset(0.0, 0.6),
                          end: FractionalOffset(0.0, 1.0),
                          colors: [
                            Color.fromRGBO(52, 54, 101, 1.0),
                            Color.fromRGBO(35, 37, 57, 1.0),
                          ]),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 30)),
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        //backgroundImage: AssetImage('assets/person.jpg'),
                        backgroundImage: NetworkImage(doctorDocument['photoUrl']),
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Text(
                        'Dr. ${doctorDocument['name']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  child: Material(
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 5,
                            color: Colors.white,
                            style: BorderStyle.solid)),
                    color: Color.fromRGBO(35, 37, 57, 1.0),
                    child: Container(
                        width: 70,
                        height: 70,
                        child: Center(
                            child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new ChatPage(
                                      peerId: doctorDocument.documentID,
                                    )));
                          },
                          backgroundColor: Color.fromRGBO(35, 37, 57, 1.0),
                          child: Icon(
                            Icons.chat,
                            size: 30,
                          ),
                        ))),
                  ),
                  right: 0,
                  left: 0,
                  top: 260)
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${doctorDocument['about']}',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                  'Consectetur culpa sint elit do amet excepteur commodo sit exercitation. Ipsum adipisicing voluptate laborum ea ex esse ullamco in elit Lorem. Magna aute adipisicing eiusmod minim cillum Lorem consequat consectetur eiusmod aliquip.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue[800],
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: [
                          Color.fromRGBO(64, 93, 230, 1),
                          Color.fromRGBO(88, 81, 219, 1),
                          Color.fromRGBO(131, 58, 180, 1),
                          Color.fromRGBO(193, 53, 132, 1),
                          //
                          Color.fromRGBO(225, 48, 108, 1),
                          Color.fromRGBO(247, 119, 55, 1),
                          Color.fromRGBO(253, 29, 29, 1),

                          Color.fromRGBO(245, 96, 64, 1),

                          Color.fromRGBO(247, 119, 55, 1),
                          Color.fromRGBO(252, 175, 69, 1),
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.white,
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.twitter,
                      color: Color.fromRGBO(29, 161, 242, 1),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
