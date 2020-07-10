import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:cottage_app/chefs/chef.dart';
import 'package:cottage_app/diners/storeComponents/store.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

final CollectionReference userCollection = Firestore.instance.collection('chefs');
Future<int> registerSeller(String shopname,String phno1,String sellername,String phno2,String shopDesc)async{
   
  int statusCode =1;
  String sk = shopname.substring(0,1);
  FirebaseUser user = await getUser();

  //create a new user
  Map<String,dynamic> sellerDetails = new Map();
  List<double> location= await getLocation();

  var uuid = Uuid();
  var shopId = uuid.v1();
  sellerDetails.addAll({
    'name':sellername,
    'phno1':phno1,
    'uid':user.uid,
    'phno2':phno2,
    'storeId':shopId,
    
  });
  
  await Firestore.instance.collection('chefs').document(user.uid).setData(sellerDetails).catchError((onError){statusCode =3;});

  // create a new store
  Map<String,dynamic> store = new Map();
  store.addAll({
    'name':shopname,
    'id':shopId,
    'description':shopDesc,
    'phno':phno1,
    'sellerId':user.uid,
    'location':location,
    'searchKey':sk,
     'cuisines': FieldValue.arrayUnion(["American"]),
     'urls': FieldValue.arrayUnion(['https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU']),
  });

  await Firestore.instance.collection('stores').document(shopId).setData(store).catchError((onError){statusCode =3;});
  
  return statusCode;
}
Future<List<double>> getLocation() async {
  Location location = new Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

_serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    return [0,0];
  }
}

_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
     _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
          _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) {
              _permissionGranted = await location.requestPermission();

            }
        }
  }
}

_locationData = await location.getLocation();
print('seller ${[_locationData.latitude,_locationData.longitude]}');
return [_locationData.latitude,_locationData.longitude];
}



Future<bool> isUserExist() async {
    var user = await getUser();
    var userDoc = await  Firestore.instance.collection('chefs').document(user.uid).get();
    print('chef exists');
    return userDoc.exists;
}

Future<FirebaseUser> getUser()async{
  return await FirebaseAuth.instance.currentUser();
}
