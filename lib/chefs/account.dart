import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cottage_app/chefs/chefinfo.dart';
import 'package:cottage_app/diners/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:cottage_app/services/authservice.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
class Chefaccount extends StatefulWidget {
  @override
  _ChefaccountState createState() => _ChefaccountState();
}

class _ChefaccountState extends State<Chefaccount> {
     Address storeaddress = new Address();
  FirebaseUser user;
   final FirebaseAuth _auth = FirebaseAuth.instance;
    String storeName = " ";
    String des =" ";
  String phoneNo = " ";
  String shopName;
  var sellerDetails;
  bool isDataLoaded = false;
  String storeId;
  String storeid ;
    String sellerName = " ";
  var storeDetails;
  // String adddres;
    String chefname;
    String description;
    String phoneNumber;
      var location;
   @override
  void initState() {
    // TODO: implement initState
     init();
   
    super.initState();
  }
    init() async {
    user = await getUser();
    isDataLoaded =
        Provider.of<SellerDetailsProvider>(context, listen: false).isDataLoaded;
    _loadStoreDetails();
  }
_loadStoreDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String storename = await pref.get("storename");
    if (storename == null) {
       sellerDetails = await Firestore.instance
          .collection('chefs')
          .document(user.uid)
          .get();
       storeid = sellerDetails.data['storeId'];
      this.storeId = storeid;
       storeDetails =
          await Firestore.instance.collection('stores').document(storeid).get();
      setState(() {
        this.storeName = storeDetails.data['name'];
        this.phoneNo = storeDetails.data['phno'];
        this.des = storeDetails.data['description'];
        this.sellerName = sellerDetails.data['name'];
      });
      pref.setString("storename", storename);
    } else {
      setState(() {
        this.storeName = storename;
      });
    }
  }
  Future updateUserData( String name , String phonenumber,String description , String shopname)
async
{
   await Firestore.instance.collection("chefs").document(user.uid).updateData({
    //'imageURL ': imageURL,
    'name' : chefname,
    'phno1' : phoneNumber,
    
   // 'mylikes' : { uid : true},
   // 'likes' : { uid : true},
  
   } );
  await Firestore.instance.collection("stores").document(storeid).updateData({
    //'imageURL ': imageURL,
    'description' : description,
    'name' : shopName,
    
   // 'mylikes' : { uid : true},
   // 'likes' : { uid : true},
  
   } );
   
}
  @override
  Widget build(BuildContext context) {
  return storeDetails != null ?
  Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.topRight,
            colors: [
              Colors.red[900],
              Colors.red[700],
              Colors.red,
              Colors.red[400],
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
                                initialValue: sellerName!=null ? sellerName:"name" ,
                                  decoration: InputDecoration(
                                    labelText: "Chef Name",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                  onChanged: (value){
                          setState(() {
                            chefname = value;
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
                                 phoneNo != null ? phoneNo : "Phone Number",
                                  onChanged: (value) => phoneNumber=value,
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                             Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextFormField(
                                 initialValue: 
                                 storeName != null ? storeName : "Store Name",
                                  onChanged: (value) => shopName=value,
                                  decoration: InputDecoration(
                                    labelText: "Kitchen Name",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                               Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextFormField(
                                 initialValue: 
                                 des != null ? des : "descrption",
                                  onChanged: (value) => description=value,
                                  decoration: InputDecoration(
                                    labelText: "Descrption",
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
                                  color: Colors.redAccent[700],
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
                                  color: Colors.redAccent[700],
                                ),
                                
                              
                                //  borderRadius: BorderRadius.circular(50),
                                  //color: Colors.redAccent[700],
                                  
                               
                                child :GestureDetector(
                                   onTap: ()async{
                                await updateUserData(chefname ?? sellerName,phoneNumber?? phoneNo, description ?? des , shopName?? storeName);
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

  