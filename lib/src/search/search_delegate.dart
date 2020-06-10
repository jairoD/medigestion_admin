import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/pages/chat_page.dart';
import 'package:medigestion_admin/src/pages/profileDoctor_page.dart';
import 'package:medigestion_admin/src/utils/Modal.dart';

class DataSearch extends SearchDelegate {
   Modal modal = new Modal();
  
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  
  String seleccion = '';
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro Appbar( Ejmplo poder limpiarlo o cancelar la busqueda)
    return [
      new IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Es un Widget que aparece al izquierda del Appbar 
    return new IconButton(
        icon: new AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    if (query.isEmpty) {
      return new Container();
    }
    return new StreamBuilder(
        stream: Firestore.instance.collection('users').where("name", isEqualTo: query).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listaUsuarios = snapshot.data.documents;
            return new ListView(
              children: listaUsuarios.map((user) {
                return new ListTile(
                  leading: user['photoUrl'] != null
                  ? new CachedNetworkImage(
                    placeholder: (context, url) => new Container(
                    //padding: EdgeInsets.all(15.0),
                    width: 50.0,
                    height: 50.0,
                    child: new CircularProgressIndicator(
                      strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                  imageUrl: user['photoUrl'],
                  width: 50.0,
                  fit: BoxFit.cover,
                )
              : new Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.blueGrey,
             ),
                  title: new Text(user['name']),
                  subtitle: new Text(user['lastName']),
                  onTap: () {
                    close(context, null);
                    modal.mainBottomSheet(context,user['uid']);
                    
                  },
                );
              }).toList(),
            );
          } else {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return new Container();
    }
    return new StreamBuilder(
        stream: Firestore.instance.collection('users').where("name", isEqualTo: query).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listaUsuarios = snapshot.data.documents;
            return new ListView(
              children: listaUsuarios.map((user) {
                return new ListTile(
                  leading:user['photoUrl'] != null
                  ? new CachedNetworkImage(
                    placeholder: (context, url) => new Container(
                    //padding: EdgeInsets.all(15.0),
                    width: 50.0,
                    height: 50.0,
                    child: new CircularProgressIndicator(
                      strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                  imageUrl: user['photoUrl'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                )
              : new Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.blueGrey,
             ),
                  title: new Text(user['name']),
                  subtitle: new Text(user['lastName']),
                  onTap: () {
                    close(context, null);
                    modal.mainBottomSheet(context,user['uid']);
                  },
                );
              }).toList(),
            );
          } else {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        });
  }
}
