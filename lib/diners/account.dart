import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cottage_app/diners/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:cottage_app/services/authservice.dart';
class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
     Address storeaddress = new Address();
  FirebaseUser user;
   final FirebaseAuth _auth = FirebaseAuth.instance;
   var dinerDetails;
   String name;
   String phonenumber;
   String adddres;
    String dinerName;
    String phoneNo;
      var location;
   @override
  void initState() {
    // TODO: implement initState
     init();
   
    super.initState();
  }
  init()async{
user = await  _auth.currentUser();
 dinerDetails = await Firestore.instance.collection("diners").document(user.uid).get();
 setState(() {
   dinerName = dinerDetails.data['name'];
   location = dinerDetails.data['location'];
   phoneNo = dinerDetails.data['phoneNo'];
   
 });
 print(dinerName);
 print(phoneNo);
 print(location);
 await _getAddress(location);
 }
  _getAddress(List<dynamic> coordinates) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(coordinates[0], coordinates[1]));
    var firstresult = addresses.first;
    setState(() {
      storeaddress = firstresult;
    });
  
  }
  Future updateUserData( String name , String phonenumber,)
async
{
  return await Firestore.instance.collection("diners").document(user.uid).updateData({
    //'imageURL ': imageURL,
    'name' : name,
    'phoneNo' : phonenumber,
    
   // 'mylikes' : { uid : true},
   // 'likes' : { uid : true},
  
   } );
   
}
  @override
  Widget build(BuildContext context) {
  return dinerDetails != null ?
  Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.topRight,
            colors: [
            //  Colors.cyan[900],
              //Colors.cyan[],
             // Colors.cyan[700],
              Colors.cyan[600],
             // Colors.cyan[600],
              Colors.cyan,
              Colors.cyan[400],
              Colors.cyan[300],
              Colors.cyan[200],

              Colors.cyan[100],
            
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Manage Your Account", style: TextStyle(color: Colors.white, fontSize: 40,
                  fontFamily: "Lobster")
                  ,
                  )),
                  SizedBox(height: 10,),
                  FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        FadeAnimation(1.4, Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextFormField(
                                initialValue: dinerDetails.data['name'] !=null ? dinerDetails.data['name'] :"name" ,
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                  onChanged: (value){
                          setState(() {
                            name = value;
                          });
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextFormField(
                                 initialValue: 
                                dinerDetails.data["phoneNo"]!=null ? dinerDetails.data["phoneNo"] : "Phone Number",
                                  onChanged: (value) => phonenumber=value,
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            
                            ],
                          ),
                        )),
                       // SizedBox(height: 40,),
                        //FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                        /*SizedBox(height: 40,),
                        FadeAnimation(1.6, Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.orange[900]
                          ),
                          child: Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        )),
                        SizedBox(height: 50,),
                        FadeAnimation(1.7, Text("Continue with social media", style: TextStyle(color: Colors.grey),)),*/
                        SizedBox(height: 30,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeAnimation(1.8, Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.cyan[900],
                                ),
                                child: GestureDetector(
                               onTap: ()async{
                                 AuthService().signOut();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));

                               },
                                child:
                                Center(
                                  child: Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                               ) )),
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: FadeAnimation(1.9, Container(
                                height: 50,
                               
                               decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.cyan[900],
                                ),
                                
                              
                                //  borderRadius: BorderRadius.circular(50),
                                  //color: Colors.redAccent[700],
                                  
                               
                                child :GestureDetector(
                                   onTap: ()async{
                                 await updateUserData(name ?? dinerName,phonenumber?? phoneNo);
                                },
                                  child :
                                Center(
                                  child: Text("Update", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                ),
                              )),
                             ) )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ) :
   Center(child: CircularProgressIndicator()
    );
  }
}