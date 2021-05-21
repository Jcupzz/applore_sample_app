import 'package:applore_sample_app/Static/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
        elevation: 20,
        centerTitle: true,
        title: Text("Products",style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection("Products").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              return Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 5),
                  itemBuilder: (BuildContext context, int index) {
                    print(snapshot);
                    return Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data.docs[index]['pImage'],
                              imageBuilder: (context, imageProvider) => Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
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
                            padding: const EdgeInsets.fromLTRB(10,5,10,0),
                            child: Text(snapshot.data.docs[index]['pTitle'],maxLines: 1,),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,10,10),
                            child: Text(
                              snapshot.data.docs[index]['pDesc'],
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                ),
              );
            }
          }),
    );
  }
}
