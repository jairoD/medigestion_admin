import 'dart:convert';

Doctor doctorFromJson(String str) => Doctor.fromJson(json.decode(str));

String doctorToJson(Doctor data) => json.encode(data.toJson());

class Doctor {
    String uid;
    String name;
    String lastName;
    String email;
    String timestamp;
    String about;
    String aboutMe;
    String available;
    String photoUrl;

    Doctor({
        this.uid,
        this.name,
        this.lastName,
        this.email,
        this.timestamp,
        this.about,
        this.aboutMe,
        this.available,
        this.photoUrl,
    });

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        uid: json["uid"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        timestamp: json["timestamp"],
        about: json["about"],
        aboutMe: json["aboutMe"],
        available: json["available"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "lastName": lastName,
        "email": email,
        "timestamp": timestamp,
        "about": about,
        "aboutMe": aboutMe,
        "available": available,
        "photoUrl": photoUrl,
    };
}