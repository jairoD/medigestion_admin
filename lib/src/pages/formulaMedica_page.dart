import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medigestion_admin/src/blocs/provider.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
import 'package:medigestion_admin/src/models/user_model.dart';
import 'package:medigestion_admin/src/pages/home_page.dart';
import 'package:medigestion_admin/src/providers/firebaseUser_provider.dart';
import 'package:medigestion_admin/src/providers/patientUser_provider.dart';
import '../providers/mailProvider.dart';
class FormulaMedicaPage extends StatefulWidget {
  static final String routeName = 'formulaMedica';
  final String patientId;
  FormulaMedicaPage({this.patientId=""});
  @override
  _FormulaMedicaPageState createState() => _FormulaMedicaPageState(patientId: patientId);
}

class _FormulaMedicaPageState extends State<FormulaMedicaPage> {
  String patientId;
  _FormulaMedicaPageState({this.patientId});
  //TextEditingController _inputTitleController = new TextEditingController();
  //TextEditingController _inputTextController = new TextEditingController();
  final form = GlobalKey<FormState>();
  UserBloc userBloc;
  String title;
  String text;
  MailProvider mailProvider     = new MailProvider();
  PatientProfile patientProfile = new PatientProfile();
  FirebaseUserProvider firebaseUserProvider = new FirebaseUserProvider();
  Map<String,dynamic> sendUserData = new Map();
  String drName;
  User userModel;
  bool loading = true;
   @override
  void initState() {
    super.initState(); 
    readPeerInformation();
  } 
  
  readPeerInformation() async{
    if(patientId!=""){
      final user = await patientProfile.getFirebaseUserPatient(uid: patientId);
      setState(() {
      userModel = user;
      loading = false;
      });
    }else{
      setState(() {
      userModel = new User();
      loading = false;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.userBlocOf(context);
    return new Scaffold(
      appBar: new AppBar(
        //automaticallyImplyLeading: false,
              elevation: 0,
              title: new Text('Formula Medica'),
              backgroundColor: Color.fromRGBO(241, 142, 172, 1.0),
              centerTitle: true,
      ),
      body: new Form(
        key: form,
        child: _form()
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.send),
        backgroundColor: Color.fromRGBO(52, 54, 101, 1.0), 
         onPressed: _sendDataToServer
      ),
    );
  }

  Widget _form() {
    return (!loading)?new Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: new SingleChildScrollView(
          child: new Column(
          children: <Widget>[
            
            _crearEmail(),
            _crearNombre(),
            _crearEdad(),
            _crearDireccion(),
            _crearNumeroDeSolicitudes(),
            _crearTexto(),

          ],
        ) ,
      ),
    ): new Center(child: new CircularProgressIndicator(),);  
  }
Widget _crearEmail() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        initialValue: userModel.email,
        decoration: new InputDecoration(
          labelText: 'Email',
          hintText: 'Ingresa email',
          icon: new Icon(Icons.email),
          isDense: true
        ),
        onSaved: (value) => sendUserData['email'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  }
  Widget _crearNombre() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        initialValue: userModel.name+''+userModel.lastName,
        decoration: new InputDecoration(
          labelText: 'Nombre Completo',
          hintText: 'Ingresa nombre completo',
          icon: new Icon(Icons.person),
          isDense: true
        ),
        onSaved: (value) => sendUserData['name'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  }


    Widget _crearEdad() {
      final birthday = userModel.birthday!=null ?
                       DateTime.now().year-userModel.birthday.toDate().year
                       :"";
      return new Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: new TextFormField(
          initialValue:birthday.toString(),
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(
            labelText: 'Edad',
            hintText: 'Ingresar edad',
            icon: new Icon(Icons.cake),
            isDense: true
          ),
        onSaved: (value) => sendUserData['age'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
        ),
      );
  }

  Widget _crearTexto() {
      return new Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
        child: new TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          decoration: new InputDecoration(
            labelText: 'Observaciones',
            hintText: 'Ingresa observaciones',
            icon: new Icon(Icons.border_color),
            isDense: true
          ),
        onSaved: (value) => sendUserData['comments'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
        ),
      );
  }

  Widget _crearNumeroDeSolicitudes() {
      return new Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: new TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(
            labelText: 'Resurtir medicamento',
            hintText: 'Resurtir medicamento',
            icon: new Icon(Icons.format_list_numbered),
            isDense: true
          ),
        onSaved: (value) => sendUserData['numberRequest'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
        ),
      );
  }

  Widget _crearDireccion() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Direccion paciente',
          hintText: 'Ingresa direccion paciente',
          icon: new Icon(Icons.location_on),
          isDense: true
        ),
        onSaved: (value) => sendUserData['address'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  }

  
  void _sendDataToServer() async{
    try {
      //print(sendUserData);
      var valid = form.currentState.validate();
      print("valid: $valid");
      if (valid) form.currentState.save();
      final resp =  await mailProvider.sendEmail(sendUserData, userBloc.userLastValue.name, userBloc.userLastValue.lastName);
      //Fluttertoast.showToast(msg: 'Formula medica enviada');
      Navigator.pushNamed(context, HomePage.routeName);
      print('response: $resp');
    } catch (e) {
      print('error: $e');
    }
  }
}
