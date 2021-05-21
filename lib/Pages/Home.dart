import 'package:applore_sample_app/Static/Loading.dart';
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

    if(MediaQuery.of(context).orientation == Orientation.landscape){
      isLandScape = true;
    }else{
      isLandScape = false;
    }
    double maxSize = MediaQuery.of(context).size.width;
    double minSize = MediaQuery.of(context).size.width * 0.85;


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
      body: Container(),
      // StreamBuilder<QuerySnapshot>(
      //     stream: firestore.collection("Products").doc(firebaseUser.uid).snapshots().map((event) => null),
      //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //       if (!snapshot.hasData) {
      //         return Loading();
      //       } else {
      //         return Expanded(
      //           child: ListView(
      //             shrinkWrap: true,
      //             children: snapshot.data.docs.map((DocumentSnapshot document) {
      //               return Padding(
      //                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      //                 child: Card(
      //                     color: Colors.deepPurple[600],
      //                     elevation: 20,
      //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      //                     child: ListTile(
      //                       hoverColor: Colors.white12,
      //                       onTap: () {
      //                        // Navigator.push(context, MaterialPageRoute(builder: (_) => Edit_Text(document)));
      //                       },
      //                       title: Padding(
      //                         padding: isLandScape? const EdgeInsets.fromLTRB(10, 25, 10, 25):const EdgeInsets.fromLTRB(0, 5, 5, 5),
      //                         child: Text(
      //                           document['text'],
      //                           maxLines: 5,
      //                           style: TextStyle(color: Colors.white,fontFamily: 'Sans',fontWeight: FontWeight.w500),
      //                         ),
      //                       ),
      //                     )),
      //               );
      //             }).toList(),
      //           ),
      //         );
      //       }
      //     }),
    );
  }
}