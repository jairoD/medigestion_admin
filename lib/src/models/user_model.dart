import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

Map<String, dynamic> userToJson(User data, String timestamp) => data.toJson(timestamp);

class User {
    String uid;
    String email;
    String name;
    String lastName;
    String photoUrl;
    String timestamp;
    String available;
    Timestamp birthday;
    String gender;

    User({
        this.uid,
        this.email,
        this.name     = "",
        this.lastName = "",
        this.photoUrl,
        this.timestamp,
        this.available,
        this.birthday,
        this.gender
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid        : json["uid"],
        email      : json["email"],
        name       : json["name"],
        lastName   : json["lastName"],
        photoUrl   : json["photoUrl"],
        timestamp  : json["timestamp"],
        available  : json["available"],
        birthday   : json["birthday"],
        gender     : json["gender"],


    );

    Map<String, dynamic> toJson(String timestamp) => {
        "uid"       : uid,
        "email"     : email,
        "name"      : name,
        "lastName"  : lastName,
        "photoUrl"  : photoUrl,
        "timestamp" : timestamp,
    };
}