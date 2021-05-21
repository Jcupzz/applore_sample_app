import 'package:applore_sample_app/Static/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot documentSnapshot;
  bool isLandScape = false;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      isLandScape = true;
    } else {
      isLandScape = false;
    }
    double maxSize = MediaQuery.of(context).size.width;
    double minSize = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/CreateProduct');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Products"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection("Products").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    child: Container(
                      color: Colors.blue,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        padding: EdgeInsets.all(10),
                        itemBuilder: (BuildContext context, int index) {
                          print(document.data());
                          return Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: document['pImage'],
                                  imageBuilder:
                                      (context, imageProvider) =>
                                      Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  placeholder: ((context, s) =>
                                      Center(
                                        child:
                                        CircularProgressIndicator(),
                                      )),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(document['pTitle']),
                              Text(document['pDesc'],maxLines: 2,),
                            ],
                          );
                        },
                        itemCount: snapshot.data.docs.length,
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
