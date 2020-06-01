import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medigestion_admin/src/pages/formulaMedica_page.dart';
import 'package:medigestion_admin/src/providers/firebaseUser_provider.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  static final String routeName = 'chat';

  final String peerId;

  ChatPage({Key key, @required this.peerId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(peerId: peerId);
}

class _ChatPageState extends State<ChatPage> {
  String peerId;
  _ChatPageState({Key key, @required this.peerId});

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  final firebaseUserProvider = new FirebaseUserProvider();

  File imageFile;
  String imageUrl;
  bool isLoading;
  String groupChatId;
  String userId;
  //String peerId = 'jBb2PpSSKUeWiIF39xwi3jh6QWW2';
  var listMessage;

  @override
  void initState() {
    super.initState();
    groupChatId = '';
    readLocal();
    //userId = getUserId().toString();
  }

  Future<void> onSendMessage(String content, type) async {
    FirebaseUser user = await firebaseUserProvider.getUser();
    if (content.trim() != '') {
      textEditingController.clear();
      firebaseUserProvider.onSendMessage(
          content: content,
          type: type,
          groupChatId: groupChatId,
          id: user.uid,
          peerId: peerId
      );
      print('peerId: $peerId -- doctorId: ${user.uid}');
      firebaseUserProvider.isRead(patientId: peerId, doctorId: user.uid);
      // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: 'Nada que enviar');
    }
  }

  Future<void> getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future<void> uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'No es una imagen');
    });
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] == userId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] != userId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> readLocal() async {
    FirebaseUser user = await firebaseUserProvider.getUser();
    if (user.uid.hashCode <= peerId.hashCode) {
      groupChatId = '${user.uid}-$peerId';
    } else {
      groupChatId = '$peerId-${user.uid}';
    }

    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Chat',
          style: new TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _chatScreen(context),
    );
  }

  Widget _chatScreen(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Column(
          children: <Widget>[
            //Listara los mensajes
            buildListMessage(context),

            //Tendra los botones de enviar mensaje e imagenes
            buildInput(context),
          ],
        ),
      ],
    );
  }

  Widget buildInput(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Colors.greenAccent, width: 0.5)),
          color: Colors.white),
      child: new Row(
        children: <Widget>[
           Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.assignment),
                onPressed: (){
                  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new FormulaMedicaPage(
                                      patientId: peerId,
                                    )));
                },
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          //Boton imagen 
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          ),//Boton imagen 
         
          //Escribir mensaje
          new Flexible(
              child: new Container(
            child: new TextField(
              style: new TextStyle(color: Theme.of(context).primaryColor),
              controller: textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: 'Escribir mensaje...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              focusNode: focusNode,
            ),
          )),
          //Buton para enviar mensaje a FireStore
          new Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget buildListMessage(BuildContext context) {
    return new Flexible(
        child: groupChatId == ''
            ? new CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              )
            : new StreamBuilder(
                stream: Firestore.instance
                    .collection('messages')
                    .document(groupChatId)
                    .collection(groupChatId)
                    .orderBy('timestamp', descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    listMessage = snapshot.data.documents;
                    return new ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data.documents[index]),
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return new Center(
                        child: new CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)));
                  }
                },
              ));
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    firebaseUserProvider.getUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });

    if (document['idFrom'] == userId) {
      //Mensajes por la derecha
      return new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //Texto
          document['type'] == 0
              ? new Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  child: new Text(
                    document['content'],
                    style: new TextStyle(color: Colors.white),
                  ),
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              //Imagen
              : document['type'] == 1 ? new Container(
                  child: new FlatButton(
                    child: new Material(
                      child: new CachedNetworkImage(
                        placeholder: (context, url) => new Container(
                          padding: EdgeInsets.all(70.0),
                          width: 200.0,
                          height: 200.0,
                          child: new CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor)),
                          decoration: new BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                       errorWidget: (context, url, error) => new Material(
                          child: Image.asset(
                            'assets/img/img_not_available.jpeg',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0),
                )
                : new SizedBox(height: 0.0,)
        ],
      );
    } else {
      //Mensajes por la izquierda
      return new Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                //Texto
                document['type'] == 0
                    ? new Container(
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        child: new Text(
                          document['content'],
                          style: new TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : new Container(
                        child: new FlatButton(
                          child: new Material(
                            child: new CachedNetworkImage(
                              placeholder: (context, url) => new Container(
                                padding: EdgeInsets.all(70.0),
                                width: 200.0,
                                height: 200.0,
                                child: new CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)),
                                decoration: new BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Material(
                                child: Image.asset(
                                  'assets/img/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document['content'],
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.all(0),
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      )
              ],
            )
          ],
        ),
      );
    }
  }
}
