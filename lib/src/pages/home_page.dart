import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/blocs/provider.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
import 'package:medigestion_admin/src/models/doctor_model.dart';
import 'package:medigestion_admin/src/pages/botones_page.dart';
import 'package:medigestion_admin/src/pages/login_page.dart';
import 'package:medigestion_admin/src/providers/firebaseUser_provider.dart';

class HomePage extends StatelessWidget {
  static final String routeName = 'home';
  // final productosProvider = new ProductoProvider();

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    final loginBLoc = Provider.of(context);
    final userBloc =  Provider.userBlocOf(context);
    final firebaseUserProvider = new FirebaseUserProvider();
    print('entro');
    return Scaffold(
      /*appBar: new AppBar(
        title: new Text('Home'),
        leading:
            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){
              firebaseUserProvider.signOut();}
            ),
      ),*/
      body: _handleCurrentView(loginBLoc,firebaseUserProvider, userBloc),
     // floatingActionButton: _crearBoton(context),
    );
  }

  Widget _handleCurrentView(LoginBloc loginBloc, FirebaseUserProvider firebaseUserProvider, UserBloc userBloc){
    return new StreamBuilder(
      stream: loginBloc.isSignedIn,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         if(snapshot.hasData){
             firebaseUserProvider.getUser().then((user){
                Firestore.instance.collection('doctors').document(user.uid).get().then((userDocument){
                  print('APELLIDO: ${userDocument.data['lastName']}');
                    userBloc.updateProfile(
                      Doctor.fromJson({
                        'uid'        : userDocument.data['uid'],
                        'email'      : userDocument.data['email'],
                        'name'       : userDocument.data['name'],
                        'lastName'   : userDocument.data['lastName'],
                        'photoUrl'   : userDocument.data['photoUrl'],
                        'available'  : userDocument.data['available'],
                        'about'      : userDocument.data['about'],
                        'aboutMe'    : userDocument.data['aboutMe']   
                      })
                    );
                });
             });
             return new BotonesPage();
         }else{
           print('¡SALIO!');
           print(snapshot.data);
           return new LoginPage();
         } 
      }
      );
  }
}
