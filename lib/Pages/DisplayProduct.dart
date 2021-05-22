import 'package:applore_sample_app/Static/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: Column(
      children: [
        CachedNetworkImage(
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
        Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Text(widget.snapshot.data.docs[widget.index]['pTitle']),
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Text(widget.snapshot.data.docs[widget.index]['pDesc']),
          ),
        )
      ],
    ));
  }
}
