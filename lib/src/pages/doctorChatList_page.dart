import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/pages/chat_page.dart';
import 'package:medigestion_admin/src/pages/profileDoctor_page.dart';
import 'package:medigestion_admin/src/providers/firebaseUser_provider.dart';
import 'package:medigestion_admin/src/search/search_delegate.dart';

import 'chat_page.dart';

class DoctorListPage extends StatefulWidget {
  static final String routeName = 'doctorList';
  DoctorListPage({Key key}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final firebaseUserProvider = new FirebaseUserProvider();
  String userId;
  String doctorId;
  //List<DocumentSnapshot> infoPatients;
@override
  void initState() {
    super.initState(); 
    firebaseUserProvider.getUser().then((doctorUser){
      doctorId = doctorUser.uid;
      print('INIT_State: $doctorId');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Haciendo algo');
    final doctorList = new Container(
      child: new StreamBuilder(
        stream: Firestore.instance
                         .collection('doctors')
                         .document(doctorId)
                         .collection('chattingWith')
                         .orderBy('timestamp', descending: true)
                         .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print('SNAPSHOT INICIAL: ${snapshot.data}');
          try {
          if(snapshot!=null){
            print('Entro aqui: $snapshot');
               if (snapshot.hasData) {
                print('snapshot2: $snapshot');
                return new ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildItem(context, snapshot.data.documents[index]),
                );     
              } else {
                print('Entro segundo else ${snapshot.connectionState} - error:${snapshot.error}');
                return new Center(
                    child: new CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ));
              }
        }else{
           return new Center(
                    child: new CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ));
              }
        
            
          } catch (e) {
            print('Entro aqui2');
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
        title: new Text('Pacientes'),
        centerTitle: true,
      ),
      body: doctorList,
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {
  
    return new GestureDetector(
        onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new ChatPage(
                          peerId: document['uid'],
                        )));
          },
        child: new Card(
          elevation: 10.0,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            child: new ListTile(
              leading: new Material(
                child: document['photoUrl'] != null
                  ? new CachedNetworkImage(
                    placeholder: (context, url) => new Container(
                    padding: EdgeInsets.all(15.0),
                    width: 50.0,
                    height: 50.0,
                    child: new CircularProgressIndicator(
                      strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                  imageUrl: document['photoUrl'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                )
              : new Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.blueGrey,
             ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
        ),
        title: new Text(
          document['name'],
          style: new TextStyle(fontWeight: (document['isRead']!=null &&document['isRead']==true)? FontWeight.normal : FontWeight.bold),
          ),
        subtitle:new Text(document['lastName'],
          style: new TextStyle(fontWeight: (document['isRead']!=null &&document['isRead']==true)? FontWeight.normal : FontWeight.bold),
        ),
      )
    )
  );

  }
}
