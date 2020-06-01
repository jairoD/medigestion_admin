import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medigestion_admin/src/models/doctor_model.dart';
import 'package:medigestion_admin/src/providers/firebaseUser_provider.dart';

class ProfileProvider{
final  firebaseUserProvider = new FirebaseUserProvider();
Map<String, dynamic> doctor = new Map();
String linkFirebase;
Future<bool> handleInfo(Doctor user) async{
  doctor['uid']        = user.uid;
  doctor['email']      = user.email;
  doctor['name']       = user.name;
  doctor['lastName']   = user.lastName; 
  doctor['available']  = user.available;
  doctor['about']      = user.about;
  doctor['aboutMe']    = user.aboutMe;
  firebaseUserProvider.updateUserProfile(doctor);
  return true;
}

Future<String> uploadFile(File imageFile, String uid) async {
    String fileName = 'PROFILE:$uid-${DateTime.now().millisecondsSinceEpoch.toString()}';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      Firestore.instance.collection('doctors').document(uid).updateData({'photoUrl':downloadUrl});
      linkFirebase = downloadUrl;
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'No se pudo subir imagen');
    });
    return linkFirebase;
  }


}