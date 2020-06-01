import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http; 

class MailProvider{
  String _url = 'http://192.168.0.10:3000/v1/mail/';

  Future<bool> sendEmail(Map<String,dynamic> dataFromUserProfile, String nombreDoctor, String apellidoDoctor) async{
    print('ENtro');
    final resp = await http.post(
      _url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'}, 
      body: {
        "doctorName"    :"$nombreDoctor $apellidoDoctor",
        "subject"       :"Formula medica $nombreDoctor $apellidoDoctor",
        "email"         :dataFromUserProfile['email'],
        "name"          :dataFromUserProfile['name'],
        "age"           :dataFromUserProfile['age'], 
        "address"       :dataFromUserProfile['address'],
        "numberRequest" :dataFromUserProfile['numberRequest'],
        "comments"      :dataFromUserProfile['comments'],
        "day"           :DateTime.now().day.toString(),
        "month"         :DateTime.now().month.toString(),
        "year"          :DateTime.now().year.toString(),    
      }
    );
    final decodedData = json.decode(resp.body);
    return decodedData['success'];
  }


}

