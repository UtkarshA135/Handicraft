import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
//import 'package:covidate/models/users.dart';
import 'chatscreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neumorphic/neumorphic.dart';


class AllUsersScreen extends StatefulWidget {
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
   FirebaseUser user;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> usersList;
  final CollectionReference _collectionReference =
      Firestore.instance.collection("diners");
  final FirebaseAuth _auth = FirebaseAuth.instance;
 inputData() async  {
     user =  await _auth.currentUser();
    final uid = user.uid;
      _subscription = _collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        usersList = datasnapshot.documents;
        print("Users List ${usersList.length}");
      });
    });
   
    // here you write the codes to input the data into firestore
  }
  @override
  void initState()  {
    super.initState();
      inputData();

  
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
        //final users = Provider.of<List<Cards>>(context) ;
 
   // final String currentuser = user?.uid;
     
    
    return Scaffold(
    backgroundColor: Colors.white,
        appBar: AppBar(
        //  elevation: 3.0,brightness: Brightness.dark,
        elevation: 10.0,
          backgroundColor:  Colors.blue[200],
          centerTitle: true,
        title: Center(child: Text('CHATS',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Lobster"
        ),
        )),
          // title: Text("All Users"),
        ),
        body: usersList != null
             ? (usersList.length==0?
              Container(
             color: Color(0xEDD8E2),
              // color: Color(0xfadcf8),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Sorry!',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: ScreenUtil().setSp(100.0),
                      fontFamily: 'Lobster'
                    )
                  ),
                  SizedBox(height: 20.0),
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU'),
                  SizedBox(height: 30.0),
                  Text('No Diners yet :(',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(60.0),
                    letterSpacing: 1.1,
                    color: Colors.black45,
                  )
                  )
                ],
              ),
            )
           : Padding(
        padding: EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
        child:   Container(
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: ((context, index) {
                      
                 if(user.uid == usersList[index].data['uid'])
                    {
                      return Container();
                    }
                else
                    {  print(usersList[index].data['name']);
                      print(usersList[index].data['uid']);
                     return /*NeuCard(
                       
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(5.0),
                      curveType: CurveType.concave,
                       bevel: 12,
                       decoration: NeumorphicDecoration(
                       color: Colors.white,
                         borderRadius: BorderRadius.circular(8)
                       ),
                          child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: usersList[index].data['url']!= null ?
                              NetworkImage(usersList[index].data['url']): AssetImage('assets/foodie.jpg')
                      ),
                      title:usersList[index].data['name'] != null ?Text(usersList[index].data['name'],
                       style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )): Text('Chef name',
                           style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                         
                      subtitle: usersList[index].data['phno1']!=null ?Text(usersList[index].data['phno1'],
                          style: TextStyle(
                            color: Colors.grey,
                          )): Text('Hi there !!'),
                      onTap: (() {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                   name: usersList[index].data['name'],
                                    photoUrl:'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU' ,
                                    receiverUid:usersList[index].data[
                                        'uid']
                                   )));
                      }),
                    
                          ),
                          );*/
                          GestureDetector(
            onTap: (() {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                   name: usersList[index].data['name'],
                                    photoUrl:'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU' ,
                                    receiverUid:usersList[index].data[
                                        'uid']
                                   )));
                      }),
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child:Card(
              color: Colors.grey[200],
              elevation: 6.0,
              child:Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      // shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,

                        ),
                      ],
                    ),

                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: usersList[index].data['url']!= null ?
                              NetworkImage(usersList[index].data['url']): AssetImage("assets/bamboo.jpg"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65-90.0,
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  usersList[index].data['name'] != null ?(usersList[index].data['name']):"CraftsMan Name ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            usersList[index].data['phno1']!=null ?usersList[index].data['phno1']:" Hi There",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
            ),
          );
                     }} )
                )
             )))
                      : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
