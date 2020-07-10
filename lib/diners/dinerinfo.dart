import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

Future<int> registerBuyer(String name , String phoneNumber)async{
   
  int statusCode =1;
  
  FirebaseUser user = await getUser();
  
  
  SharedPreferences ref = await SharedPreferences.getInstance();
  List<double> location= await getLocation();
   Map<String,dynamic> dinerDetails = new Map();
   dinerDetails.addAll({
    'name':name,
    'location':location,
    'uid':user.uid,
    'phoneNo':phoneNumber,
  });
  await ref.setString("buyerLocation", location.toString()).catchError((err){
    print(err);
    statusCode= 3;
  });
  await Firestore.instance.collection('diners').document(user.uid).setData(dinerDetails).catchError((onError){statusCode =3;});


  UserUpdateInfo userUpdateInfo = UserUpdateInfo();
  userUpdateInfo.displayName = name;
  
  await user.updateProfile(userUpdateInfo).catchError((err){
    statusCode = 3;
    print(err);
  });

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
print('buyer ${[_locationData.latitude,_locationData.longitude]}');

return [_locationData.latitude,_locationData.longitude];
}


Future<bool> isUserExist() async {
    var user = await getUser();
    SharedPreferences ref = await SharedPreferences.getInstance();
    var location = await ref.get("buyerLocation");

  //  if(user.displayName!="" && user.displayName!=null && location !=null && location !=""){
      var userDoc = await  Firestore.instance.collection('diners').document(user.uid).get();
    print('diner exists');
    return userDoc.exists;
     
      
    }

   
  


Future<FirebaseUser> getUser()async{
  return await FirebaseAuth.instance.currentUser();
}
