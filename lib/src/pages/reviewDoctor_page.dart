import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/search/search_delegate.dart';
 
 
class ReviewDoctor extends StatelessWidget {
  static final routeName = "reviewDoctor";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Buscar Paciente'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.search), onPressed: () {
              showSearch(
                  context: context,
                  delegate: new DataSearch(),
                  //query: 'Hola Mundo'
              );
            }),
          ]
        ),
    );
  }

}