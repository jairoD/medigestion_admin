import 'package:flutter/cupertino.dart';
import 'package:medigestion_admin/src/models/user_model.dart';
import 'package:medigestion_admin/src/providers/firebaseUser_provider.dart';

class PatientProfile{

  FirebaseUserProvider firebaseUserProvider = new FirebaseUserProvider();
  
  Future<User> getFirebaseUserPatient({@required String uid}) {
    return  firebaseUserProvider.getPatientProfile(uid: uid);
  }

}