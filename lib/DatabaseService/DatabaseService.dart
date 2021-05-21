import 'dart:io';

import 'package:applore_sample_app/Model/Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String pTitle, pImage, pDesc;
  Future<void> addProductToFb(String pTitle, File pImage, String pDesc) async {
    String downloadURL;

    final User firebaseUser = _auth.currentUser;


    CollectionReference Ref = FirebaseFirestore.instance.collection("Products");

    downloadURL = await uploadFile(pImage.path);



    if (!(downloadURL == 'Error')) {
      Model model = new Model(pTitle: pTitle, pDesc: pDesc, pImage: downloadURL, pUid: firebaseUser.uid.toString(),pTime: DateTime.now().toString());
      Ref.add(model.toJson()).then((value) {
        return "Done";
      }).catchError((onError) {
        return "Error";
      });
    }
  }

  Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    String downloadURL;
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('pImage')
          .child("${DateTime.now().millisecondsSinceEpoch}")
          .putFile(file)
          .then((val) async {
        downloadURL = await val.ref.getDownloadURL();
      });
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "Error";
    }
  }
}
