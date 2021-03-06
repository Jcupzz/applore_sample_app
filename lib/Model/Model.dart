// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

//Model welcomeFromJson(String str) => Model.fromJson(json.decode(str));

//String welcomeToJson(Model data) => json.encode(data.toJson());

class Model {
  Model({
    this.pTitle,
    this.pImage,
    this.pDesc,
    this.pTime,
    this.pUid
  });

  String pTitle;
  String pImage;
  String pDesc;
  String pTime;
  String pUid;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    pTitle: json["pTitle"],
    pImage: json["pImage"],
    pDesc: json["pDesc"],
    pTime: json["pTime"],
    pUid: json["pUid"]
  );

  Map<String, dynamic> toJson() => {
    "pTitle": pTitle,
    "pImage": pImage,
    "pDesc": pDesc,
    "pTime": pTime,
    "pUid":pUid,
  };
}
