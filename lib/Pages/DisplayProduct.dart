import 'package:applore_sample_app/Static/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DisplayProduct extends StatefulWidget {
  AsyncSnapshot snapshot;
  int index;

  DisplayProduct(this.snapshot, this.index);

  @override
  _DisplayProductState createState() => _DisplayProductState();
}

class _DisplayProductState extends State<DisplayProduct> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  widget.snapshot.data.docs[widget.index]['pTitle'],
                  style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: CachedNetworkImage(
                imageUrl: widget.snapshot.data.docs[widget.index]['pImage'],
                imageBuilder: (context, imageProvider) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: ((context, s) => Center(
                      child: CircularProgressIndicator(),
                    )),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25,10,20,0),
              child: Text("Description",style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10,0,10,30),
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.snapshot.data.docs[widget.index]['pDesc'],style: Theme.of(context).textTheme.bodyText2,),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
