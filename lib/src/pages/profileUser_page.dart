import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medigestion_admin/src/blocs/provider.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
import 'package:medigestion_admin/src/pages/home_page.dart';
import 'package:medigestion_admin/src/providers/profile_provider.dart';
import 'package:medigestion_admin/src/models/doctor_model.dart';

class ProfileUserPage extends StatefulWidget {
  static final routeName = 'userProfile';
  @override
  _ProfileUserPageState createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final profileProvider = new ProfileProvider();

  //ProductosBloc productosBloc;
  Doctor userModel;
  //final productoProvider = new ProductoProvider();
  UserBloc userBloc;
  File foto;

  bool _guardando = false;
  bool _cargando = false;
  bool _change = false;
  bool fotoState = false;

  FixedExtentScrollController scrollController = FixedExtentScrollController(
    initialItem: 0
  );
  int selectitem = 0; 

  String valueName;
  String valueLastName;
  List<bool> isFormEditingEmpty = [false,false,false,false];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.userBlocOf(context);
    return new StreamBuilder(
      stream: userBloc.userStream,
      builder:(BuildContext context, AsyncSnapshot<Doctor> snapshot) {
        if(snapshot.hasData){
            userModel = snapshot.data;
            print("Snapshot: ${snapshot.data.lastName}");
            print("Vista ProfileUser: ${userModel.email} - ${userModel.uid} - ${userModel.lastName}");
          return _createProfile(context);
        }else{
          return new Scaffold(
            body: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      },);
  }


  Widget _createProfile(BuildContext context){
    return  new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Perfil'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          new IconButton(
            icon: new Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: EdgeInsets.all(15.0),
          child: new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearApellido(),
                  _crearAbout(),
                  _crearAboutMe(),
                  _tipodeBoton(context),
                  _crearCargando()
                ],
              )),
        ),
      ),
    );
  }
  Widget _crearNombre() {
    return new TextFormField(
      initialValue: userModel.name,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(
        labelText: 'Nombre',
        suffixIcon: new Icon(Icons.face),
      ),
      onSaved: (value) => userModel.name = value,
      onChanged: (value) {
        _change=true;
         if(value.isEmpty){
           setState(() {
             isFormEditingEmpty[0] = true;
           });
         }else{
           setState(() {
             isFormEditingEmpty[0] =false;
           });
         }
         print('value NAME: $value');
      },
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese su nombre';
        } else {
          print('Entro validator nombre: NULL');
          return null;
        }
      },
    );
  }
Widget _crearApellido() {
    return new TextFormField(
      initialValue: userModel.lastName,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(
        labelText: 'Apellido',
        suffixIcon: new Icon(Icons.face),
      ),
      onSaved: (value) => userModel.lastName = value,
      onChanged: (value) {
        _change=true;
         if(value.isEmpty){
           setState(() {
             isFormEditingEmpty[1] = true;
           });
         }else{
           setState(() {
             isFormEditingEmpty[1] =false;
           });
         }
         print('value LastName: $value');
      },
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese su Apellido';
        } else {
          return null;
        }
      },
    );
  }
  Widget _crearAbout() {
    return new TextFormField(
      initialValue: userModel.about,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(
        labelText: 'Especializacion',
        suffixIcon: new Icon(Icons.bookmark),
      ),
      onSaved: (value) => userModel.about = value,
      onChanged: (value) {
        _change=true;
         if(value.isEmpty){
           print('¡¡¡¡Entro!!!!');
           setState(() {
             isFormEditingEmpty[2] = true;
           });
         }else{
           setState(() {
             isFormEditingEmpty[2] =false;
           });
         }
         print('value LastName: $value');
      },
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese su Apellido';
        } else {
          return null;
        }
      },
    );
  }
  Widget _crearAboutMe() {
    return new TextFormField(
      initialValue: userModel.aboutMe,
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      decoration: new InputDecoration(
        labelText: 'Biografia',
        suffixIcon: new Icon(Icons.bookmark),
      ),
      onSaved: (value) => userModel.aboutMe = value,
      onChanged: (value) {
        _change=true;
         if(value.isEmpty){
           setState(() {
             isFormEditingEmpty[3] = true;
           });
         }else{
           setState(() {
             isFormEditingEmpty[3] =false;
           });
         }
         print('value LastName: $value');
      },
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese su Apellido';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCargando() {
    if (_cargando) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new Container();
    }
  }
  Widget _tipodeBoton(BuildContext context){
    print(isFormEditingEmpty);
    print('Entro onPressed');
          //Caso en el que venga con informacion 
          if(userBloc.userLastValue.name     != null    && 
             userBloc.userLastValue.lastName != null    &&
             userBloc.userLastValue.photoUrl != null    &&
             userBloc.userLastValue.about    != null    &&
             userBloc.userLastValue.aboutMe  != null    && _change == true){
               //Caso en el que quiera cambiar informacion, con valores ya establecidos
            if(isFormEditingEmpty.contains(true)){
               print('ENtro 1 if');
               return _crearBotonNoHabilitado(context); 
            }else{print('asds'); return _crearBoton(context);}
          }else{
             if(isFormEditingEmpty.contains(true)){
                return _crearBotonNoHabilitado(context); 
              }else{
                if((_change == true && fotoState ==true || fotoState == true)){
                  return _crearBoton(context);
                }else{
                return _crearBotonNoHabilitado(context); 

                }
              }
          } 
  }
Widget _crearBotonNoHabilitado(BuildContext context) {
    return new RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed:null,
        icon: new Icon(Icons.save),
        label: new Text('Guardar'));
  }
  Widget _crearBoton(BuildContext context) {
    return new RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed:(_guardando) ? null : ()=> _submit(context),
        icon: new Icon(Icons.save),
        label: new Text('Guardar'));
  }

  void _submit(BuildContext context) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _guardando = true;
      _cargando = true;
    });

    if (foto != null) {
      userModel.photoUrl = await userBloc.subirFoto(foto, userModel.uid);
    }
    userModel.available = "1";
    userBloc.agregarUsuario(userModel);
    //userBloc.updateProfile(userModel);
    setState(() {
      _cargando = false;
    });
    
    //mostrarSnackbar('Registro guardado');
    //Lo mando al HomePage cosa de que actualice enseguida el stream del User y no usar el updateProfile de la linea 158 ya que en el home lo hara
    Navigator.pushNamed(context, HomePage.routeName);
  }


  void mostrarSnackbar(String mensaje) {
    final snackbar = new SnackBar(
      content: new Text(mensaje),
      duration: new Duration(seconds: 2),
      shape:
          new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

   _mostrarFoto() {
    if (userModel.photoUrl != null) {

      return new Material(
        child: new CachedNetworkImage(
          placeholder: (context, url) => new Container(
            child:new CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor:AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor) ,
            ),
            width: 300.0,
            height: 300.0,
            padding: EdgeInsets.all(20.0),
          ),
          imageUrl: userModel.photoUrl,
          width: 300.0,
          height: 300.0,
          fit: BoxFit.cover,          
        ),
        borderRadius: BorderRadius.all(Radius.circular(45.0)),
        clipBehavior: Clip.hardEdge,
      );
      /* return new FadeInImage(
        image: new NetworkImage(userModel.photoUrl),
        placeholder: new AssetImage('assets/img/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      ); */
    } else {
      if (foto != null) {
        return new Material(
          child: Image.file(
            foto,
            fit: BoxFit.cover,
            height: 300.0,
            width: 300.0,
          ),
         borderRadius: BorderRadius.all(Radius.circular(45.0)),
        clipBehavior: Clip.hardEdge,
        );
      }
      return Image.asset('assets/img/no-image2.png');
    }
  } 

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource fuente) async {
    foto = await ImagePicker.pickImage(source: fuente);
    print("FOTO: $foto");
    if (foto != null) {
      userModel.photoUrl = null;
      fotoState = true;
    }
    setState(() {});
  }


}