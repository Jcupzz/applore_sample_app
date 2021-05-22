import 'package:applore_sample_app/AuthenticationService.dart';
import 'package:applore_sample_app/DatabaseService/DatabaseService.dart';
import 'package:applore_sample_app/Pages/DisplayProduct.dart';
import 'package:applore_sample_app/Static/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot documentSnapshot;
  bool isLandScape = false;
  String docID;

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
        backgroundColor: Colors.white,
        elevation: 10,
        onPressed: () {
          Navigator.pushNamed(context, '/CreateProduct');
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.black,
              size: 24,
            ),
            onSelected: (result) async {
              switch (result) {
                case 0:
                  showSignOutConfirmation();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    value: 0,
                    child: Text(
                      "SignOut",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'Poppins'),
                    )),
              ];
            },
          )
        ],
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: Text("Products", style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
      ),
      body:
      SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: StreamBuilder<QuerySnapshot>(
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
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5,),
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot);
                        return GestureDetector(
                          onLongPress: () {
                            DatabaseService databaseService = new DatabaseService();
                            docID = snapshot.data.docs[index].id;
                            print("DARA"+docID.toString());
                            databaseService.deleteProductFromFb(snapshot, index,context,docID);
                          },
                          onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>DisplayProduct(snapshot, index)));
                            },
                          child: Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child:
                                      kIsWeb?
                                          Image.network(snapshot.data.docs[index]['pImage'],):
                                  CachedNetworkImage(
                                    imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
                                    imageUrl: snapshot.data.docs[index]['pImage'],
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.zero,
                                            bottomRight: Radius.zero,
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
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
                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  child: Text(
                                    snapshot.data.docs[index]['pTitle'],
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Text(
                                    snapshot.data.docs[index]['pDesc'],
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  void showSignOutConfirmation() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 20,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(
              "SignOut",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            content: Text(
              "Are you sure?",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 18),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  dynamic isLoggedOut = await context.read<AuthenticationService>().signOut();
                  if (isLoggedOut.toString() == "Signed out") {
                    Navigator.pushReplacementNamed(context, "/Register");
                  }
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }
}
