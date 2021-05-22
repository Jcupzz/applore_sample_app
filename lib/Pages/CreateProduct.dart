import 'dart:io';

import 'package:applore_sample_app/DatabaseService/DatabaseService.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Product",style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold,color: Colors.black),),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(labelText: 'Title'),
                    validator: (value) => value.isEmpty ? "  Please enter product name" : null,
                    onSaved: (value) => pTitle = value,
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,0,0,0),
                    child: Text("Image",style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold,color: Colors.black),),
                  ),
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
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,0,0,0),
                    child: Text("Description",style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold,color: Colors.black),),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: TextFormField(
                      validator: (value)=>value.isEmpty?"  Please enter description" : null,
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
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                       hintText: "  Enter description of product...",
                        hintStyle: Theme.of(context).textTheme.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                      cursorColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary:Colors.black,onPrimary: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                       child: Text("Submit",style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold,color: Colors.white),),
                      onPressed: (){
                        validateAndSave();
                      },
                    ),
                  ),
                  SizedBox(height: 10,)
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
      if(pImage == null){
        BotToast.showText(text: "Please select an image");
      }
      else{
        _db.addProductToFb(pTitle, pImage, pDesc);
        final added = SnackBar(
            content: Text('Adding product'),
            );
        ScaffoldMessenger.of(context).showSnackBar(added);
        Navigator.pop(context);
      }
      return true;
    } else {
      print("Form invalid");
      return false;
    }
  }

  dynamic textInputDecoration = InputDecoration(
    labelStyle: TextStyle(
      color: Colors.black,
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
