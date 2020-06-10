import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medigestion_admin/src/models/user_model.dart';
import 'package:medigestion_admin/src/providers/patientUser_provider.dart';

class AddHistoriaPage extends StatefulWidget {
  final String patientId;
  AddHistoriaPage({this.patientId});
  @override
  _AddHistoriaPageState createState() => _AddHistoriaPageState();
}

class _AddHistoriaPageState extends State<AddHistoriaPage> {
  PatientProfile patientProfile = new PatientProfile();
  final form = GlobalKey<FormState>();
  User userModel;
  bool loading = true;

  bool checkBoxCardio =false;
  bool checkBoxPulmonar =false;
  bool checkBoxDigestivo =false;
  bool checkBoxDiabetes =false;
  bool checkBoxRenales =false;
  bool checkBoxQuirurgico =false;
  bool checkBoxAlergico =false;
  bool checkBoxTrasfusiones =false;
  bool checkBoxAlcohol =false;
  bool checkBoxTabaco =false;
  bool checkBoxDroga =false;
  bool checkBoxInmune =false;




  Map<String,dynamic> sendUserData = new Map();

   @override
  void initState() {
    super.initState(); 
    readPeerInformation();
  } 
  
  readPeerInformation() async{
    if(widget.patientId!=""){
      final user = await patientProfile.getFirebaseUserPatient(uid: widget.patientId);
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Añadir Historia Clinica'),
        centerTitle: true,
      ),
      body: new Form(
        key: form,
        child: _form()
      ),
    );
  }
   Widget _form() {
    return (!loading)?new Material(
       
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: new SingleChildScrollView(
          child: new Column(
          children: <Widget>[
            _crearTituloFicha(),
            _crearNombre(),
            _crearEdad(),
            _crearSexo(),
            _crearCuarto(),
            _crearSala(),
            _crearOcupacion(),
            _crearTituloAtecedentes(),
            _crearCardiovascular(),
            _crearPulmonar(),
            _crearDigestivo(),
            _crearDiabetes(),
            _crearRenales(),
            _crearQuirurgico(),
            _crearAlergico(),
            _crearTransfusiones(),
            _crearMedicamentos(),
            _crearTituloAtecedentesNoPatologicos(),
            _crearAlcohol(),
            _crearTabaco(),
            _crearDrogas(),
            _crearInmunizaciones(), 
            _crearOtros(),
            _crearTituloFamilia(),
            _crearAntecedentesFamilia(),

            new SizedBox(height: 25.0,)
            
          ],
        ) ,
      ),
    ): new Center(child: new CircularProgressIndicator(),);  
  }
Widget _crearTituloFamilia() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new Row(
        children: <Widget>[
          new Text(
                  'Antecedentes Familiares',
                  style: new TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }  


Widget _crearAntecedentesFamilia() {
      return new Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
        child: new TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          decoration: new InputDecoration(
            labelText: 'Antecedentes familiares',
            hintText: 'Ingresa antecedentes familiares',
            icon: new Icon(Icons.border_color),
            isDense: true
          ),
        onSaved: (value) => sendUserData['antecedentes'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
        ),
      );
  }


Widget _crearOtros() {
      return new Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
        child: new TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          decoration: new InputDecoration(
            labelText: 'Otros',
            hintText: 'Ingresa otros',
            prefixIcon: new Icon(Icons.border_color),
            isDense: true
          ),
        onSaved: (value) => sendUserData['otros'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
        ),
      );
  }



   Widget _crearInmunizaciones() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxInmune, 
        onChanged: (bool value){
          setState(() {
            checkBoxInmune = value;
            if(checkBoxInmune){
              sendUserData['inmune'] = "Positivo";
            }else{
              sendUserData['inmune'] = "Negativo";
            }
            print('${sendUserData['inmune']} inmune');
          });
        },
        title: new Text('Inmunizaciones'),
      )
    );
  }

 Widget _crearDrogas() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxDroga, 
        onChanged: (bool value){
          setState(() {
            checkBoxDroga = value;
            if(checkBoxDroga){
              sendUserData['droga'] = "Positivo";
            }else{
              sendUserData['droga'] = "Negativo";
            }
            print('${sendUserData['droga']} droga');
          });
        },
        title: new Text('Drogas'),
      )
    );
  }


  Widget _crearTabaco() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxTabaco, 
        onChanged: (bool value){
          setState(() {
            checkBoxTabaco = value;
            if(checkBoxTabaco){
              sendUserData['tabaco'] = "Positivo";
            }else{
              sendUserData['tabaco'] = "Negativo";
            }
            print('${sendUserData['tabaco']} tabaco');
          });
        },
        title: new Text('Tabaquismo'),
      )
    );
  }

Widget _crearAlcohol() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxAlcohol, 
        onChanged: (bool value){
          setState(() {
            checkBoxAlcohol = value;
            if(checkBoxAlcohol){
              sendUserData['alcohol'] = "Positivo";
            }else{
              sendUserData['alcohol'] = "Negativo";
            }
            print('${sendUserData['alcohol']} alcohol');
          });
        },
        title: new Text('Alcohol'),
      )
    );
  }







Widget _crearTituloAtecedentesNoPatologicos() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new Row(
        children: <Widget>[
          new Text(
                  'Antecedentes personales no patologicos',
                  style: new TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }  

Widget _crearMedicamentos() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        //initialValue: userModel.gender,
        decoration: new InputDecoration(
          labelText: 'Medicamentos',
          hintText: 'Ingresa medicamentos',
          //icon: new Icon(Icons.local_hospital),
          prefixIcon:new Icon(Icons.local_hospital) ,
          isDense: true
        ),
        onSaved: (value) => sendUserData['medicamentos'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  } 
  Widget _crearTransfusiones() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxTrasfusiones, 
        onChanged: (bool value){
          setState(() {
            checkBoxTrasfusiones = value;
            if(checkBoxTrasfusiones){
              sendUserData['transfusion'] = "Positivo";
            }else{
              sendUserData['transfusion'] = "Negativo";
            }
            print('${sendUserData['transfusion']} Trasfusiones');
          });
        },
        title: new Text('Trasfusiones'),
      )
    );
  }

Widget _crearAlergico() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxAlergico, 
        onChanged: (bool value){
          setState(() {
            checkBoxAlergico = value;
            if(checkBoxAlergico){
              sendUserData['alergico'] = "Positivo";
            }else{
              sendUserData['alergico'] = "Negativo";
            }
            print('${sendUserData['alergico']} Alergico');
          });
        },
        title: new Text('Alérgicos'),
      )
    );
  }


Widget _crearQuirurgico() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxQuirurgico, 
        onChanged: (bool value){
          setState(() {
            checkBoxQuirurgico = value;
            if(checkBoxQuirurgico){
              sendUserData['quirurgico'] = "Positivo";
            }else{
              sendUserData['quirurgico'] = "Negativo";

            }
            print('${sendUserData['quirurgico']} Quirurgicos');
          });
        },
        title: new Text('Quirúrgicos'),
      )
    );
  }


Widget _crearRenales() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxRenales, 
        onChanged: (bool value){
          setState(() {
            checkBoxRenales = value;
            if(checkBoxRenales){
              sendUserData['renales'] = "Positivo";
            }else{
              sendUserData['renales'] = "Negativo";
            }

            print('${sendUserData['renales']} Renales');
          });
        },
        title: new Text('Renales'),
      )
    );
  }
  Widget _crearDiabetes() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxDiabetes, 
        onChanged: (bool value){
          setState(() {
            checkBoxDiabetes = value;

            if(checkBoxDiabetes){
              sendUserData['diabetes'] = "Positivo";
            }else{
              sendUserData['diabetes'] = "Negativo";
            }
  
            print('${sendUserData['diabetes']} Diabetes');
          });
        },
        title: new Text('Diabetes'),
      )
    );
  }

  Widget _crearDigestivo() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxDigestivo, 
        onChanged: (bool value){
          setState(() {
            checkBoxDigestivo = value;

            if(checkBoxDigestivo){
              sendUserData['digestivo'] = "Positivo";
            }else{
              sendUserData['digestivo'] = "Negativo";
            }

            print('${sendUserData['digestivo']} Digestivo');
          });
        },
        title: new Text('Digestivo'),
      )
    );
  }



   Widget _crearPulmonar() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxPulmonar, 
        onChanged: (bool value){
          setState(() {
            checkBoxPulmonar = value;
            if(checkBoxPulmonar){
              sendUserData['pulmonar'] = "Positivo";
            }else{
              sendUserData['pulmonar'] = "Negativo";
            }

            print('${sendUserData['pulmonar']} Pulmon');
          });
        },
        title: new Text('Pulmonares'),
      )
    );
  }
  Widget _crearCardiovascular() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new CheckboxListTile(
        value: checkBoxCardio, 
        onChanged: (bool value){
          setState(() {
            checkBoxCardio = value;
            if(checkBoxCardio){
              sendUserData['cardiovascular'] = "Positivo";
            }else{
              sendUserData['cardiovascular'] = "Negativo";

            }
            print("${sendUserData['cardiovascular']} cardio");
          });
        },
        title: new Text('Cardiovascular'),
      )
    );
  }  
  Widget _crearTituloFicha() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new Row(
        children: <Widget>[
          new Text(
                  'Ficha de identificación',
                  style: new TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }  
  Widget _crearTituloAtecedentes() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new Row(
        children: <Widget>[
          new Text(
                  'Antecedentes personales patologicos',
                  style: new TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }  
Widget _crearOcupacion() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        //initialValue: userModel.gender,
        decoration: new InputDecoration(
          labelText: 'Ocupacion',
          hintText: 'Ingresa ocupacion',
          icon: new Icon(Icons.business_center),
          isDense: true
        ),
        onSaved: (value) => sendUserData['ocupacion'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  }  
  Widget _crearSala() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        //initialValue: userModel.gender,
        decoration: new InputDecoration(
          labelText: 'Sala',
          hintText: 'Ingresa sala',
          icon: new Icon(Icons.room),
          isDense: true
        ),
        onSaved: (value) => sendUserData['sala'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  }  
Widget _crearCuarto() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        //initialValue: userModel.gender,
        decoration: new InputDecoration(
          labelText: 'Cuarto',
          hintText: 'Ingresa cuarto',
          icon: new Icon(Icons.airline_seat_flat),
          isDense: true
        ),
        onSaved: (value) => sendUserData['cuarto'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  }  
Widget _crearSexo() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        initialValue: userModel.gender,
        decoration: new InputDecoration(
          labelText: 'Sexo',
          hintText: 'Ingresa sexo',
          icon: new Icon(Icons.wc),
          isDense: true
        ),
        onSaved: (value) => sendUserData['sexo'] = value,
        validator: (value) => (value!=null) ? null : 'no es valido',
      ),
    );
  }
   Widget _crearNombre() {
    return new Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: new TextFormField(
        initialValue: userModel.name+' '+userModel.lastName,
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
}