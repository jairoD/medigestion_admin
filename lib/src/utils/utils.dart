import 'package:flutter/material.dart';
bool isNumeric(String str){
  if(str.isEmpty) return false;
  final n = num.tryParse(str);
  return (n == null)? false: true;
}

void mostrarAlerta (BuildContext context, String mensaje){
   showDialog(
     context: context,
     builder: (context) {
       return new AlertDialog(
         title: new Text('Informmacion incorrecta'),
         content: new Text(mensaje),
         actions: <Widget>[
           new FlatButton(
             onPressed: ()=> Navigator.of(context).pop(), 
             child: new Text('Ok')
             )
         ],
       );

     },
     
     );
}