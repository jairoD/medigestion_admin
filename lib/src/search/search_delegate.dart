import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/pages/chat_page.dart';
import 'package:medigestion_admin/src/pages/profileDoctor_page.dart';

class DataSearch extends SearchDelegate {
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
        stream: Firestore.instance.collection('doctors').where("name", isEqualTo: query).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listaDoctores = snapshot.data.documents;
            return new ListView(
              children: listaDoctores.map((doctor) {
                return new ListTile(
                  leading: new FadeInImage(
                    placeholder: new AssetImage('assets/img/no-image.jpg'),
                    image: new NetworkImage(doctor['photoUrl']),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: new Text(doctor['name']),
                  subtitle: new Text(doctor['about']),
                  onTap: () {
                    close(context, null);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ProfilePage(
                                  doctorDocument: doctor,
                                )));
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
        stream: Firestore.instance.collection('doctors').where("name", isEqualTo: query).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listaDoctores = snapshot.data.documents;
            return new ListView(
              children: listaDoctores.map((doctor) {
                return new ListTile(
                  leading: new FadeInImage(
                    placeholder: new AssetImage('assets/img/no-image.jpg'),
                    image: new NetworkImage(doctor['photoUrl']),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: new Text(doctor['name']),
                  subtitle: new Text(doctor['about']),
                  onTap: () {
                    close(context, null);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ProfilePage(
                                  doctorDocument: doctor,
                                )));
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
