import 'dart:io';

import 'package:applore_sample_app/Model/Model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference Ref = FirebaseFirestore.instance.collection("Products");

  String pTitle, pImage, pDesc;
  Future<void> addProductToFb(String pTitle, File pImage, String pDesc) async {
    String downloadURL;

    final User firebaseUser = _auth.currentUser;



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

  Future<void> deleteProductFromFb(AsyncSnapshot snapshot,int index,BuildContext context,String docID){

    showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 20,
        title: Text("Delete",style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),),
        content: Text("Do you want to delete \"${snapshot.data.docs[index]['pTitle']}\"?"),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,10),
            child: ElevatedButton(onPressed: ()async{

              await Ref.doc(docID).delete().then((value) {
                BotToast.showText(text: "Deleted ${snapshot.data.docs[index]['pTitle']}");
                Navigator.pop(context);
              });

            }, child: Text("Yes"),style: ElevatedButton.styleFrom(elevation:0,primary: Colors.red),),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,10,10),
            child: ElevatedButton(onPressed: (){
                Navigator.pop(context);
            }, child: Text("No"),
            style: ElevatedButton.styleFrom(elevation:0,primary: Colors.green),
            ),
          )

        ],
      );
    });


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
