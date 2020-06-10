import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/pages/addHistoria.dart';
import 'package:medigestion_admin/src/pages/historia_clinica_page.dart';

class Modal{
  mainBottomSheet(BuildContext context, String uid){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Ver', Icons.assignment_ind, _action1,uid),
              _createTile(context, 'Añadir', Icons.add_comment, _action2,uid),
            ],
          );
        }
    );
  }

  ListTile _createTile(BuildContext context, String name, IconData icon, Function action, String uid){
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: (){
        Navigator.pop(context);
        action(context,uid);
      },
    );
  }

  _action1(BuildContext context, String uid){
     Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => new HistoriaClinicaPage(
                                  uid: uid ,
                                )));
  }

  _action2(BuildContext context,String uid){
    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => new AddHistoriaPage(
                                  patientId: uid ,
                                )));
  }

}