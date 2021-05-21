import 'dart:io';

import 'package:applore_sample_app/DatabaseService/DatabaseService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProduct extends StatefulWidget {
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  String pTitle, pDesc;
  File pImage;
  final picker = ImagePicker();

  Future getImage() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        pImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

  }



  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,20,15,20),
              child: Column(
                children: [
                  Text("Create Product"),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(labelText: 'Title'),
                    validator: (value) => value.isEmpty ? "  Please enter product name" : null,
                    onSaved: (value) => pTitle = value,
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () => getImage(),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Theme.of(context).unselectedWidgetColor),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Center(
                          child:  pImage == null
                              ? Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 80,
                                )
                              : Image.file(pImage)),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: TextField(
                      onChanged: (value) {
                        pDesc = value;
                      },
                      expands: true,
                      textAlign: TextAlign.start,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 3, color: Colors.deepPurple[200]),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 2, color: Colors.deepPurpleAccent),
                        ),
                        labelText: "Add notes",
                        alignLabelWithHint: true,
                        hintText: "Add notes",
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Sans', fontWeight: FontWeight.w500),
                      cursorColor: Colors.deepOrange[200],
                    ),
                  ),
                  Container(width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ElevatedButton(
                       child: Text("Submit",),
                      onPressed: (){
                        validateAndSave();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('$pTitle,$pImage,$pDesc');
      DatabaseService _db = new DatabaseService();
      _db.addProductToFb(pTitle, pImage, pDesc);
      return true;
    } else {
      print("Form invalid");
      return false;
    }
  }

  dynamic textInputDecoration = InputDecoration(
    labelStyle: TextStyle(
      color: Colors.blue,
    ),
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(width: 1, color: Colors.blue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(width: 1, color: Colors.black),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(),
    ),
  );
}
