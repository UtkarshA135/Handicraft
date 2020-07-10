/*import 'package:maps/diners/dinerinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:maps/services/authservice.dart';
import 'package:maps/diners/storeComponents/store.dart';
import 'package:maps/diners/shopCard.dart';
class StoresPage extends StatefulWidget {
 final String phNo;
  StoresPage({Key key,this.phNo}) : super(key: key);
  @override
  _StoresPageState createState() => _StoresPageState(phNo:phNo);
}

class _StoresPageState extends State<StoresPage> {
  final CollectionReference storesRef  = Firestore.instance.collection("stores");
  String phNo;
  _StoresPageState({this.phNo});
  List<double> myLocation=[0.0,0.0];

  @override
  void initState() {
    // TODO: implement initState
    _getMyLocation();
    super.initState();
  }

  _getMyLocation()async {

    var mylocation = await getLocation();
    setState(() {
      myLocation = mylocation;
    });
  }
   double _calcDistance(List<dynamic> storeLoc){
      if(this.myLocation[0] == 0.0 && this.myLocation[1]==0.0){
        return 0.0;
      }
      else{
          final Distance distance = new Distance();
              
          // km = 423
          final double km = distance.as(LengthUnit.Kilometer,
          new LatLng(storeLoc[0],storeLoc[1]),new LatLng(this.myLocation[0],this.myLocation[1]));
          
          // // meter = 422591.551
          final double meter = distance(
              new LatLng(storeLoc[0],storeLoc[1]),new LatLng(this.myLocation[0],this.myLocation[1])
              );
          // if(meter>1000){
          //   return '$km Km';
          // }
          // else{
            return meter;

          // }

      }
    }

  @override
  Widget build(BuildContext context) {
      bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
        Color dynamicbgcolor =
        (!isDarkMode) ? Colors.grey[200] : Colors.black;
    return Container(
    //  backgroundColor: Colors.redAccent[900],
      /* appBar: AppBar(title:Text("Stores Near Me",
       
       ),
       centerTitle: true,
       backgroundColor: Colors.redAccent[900],
       actions: <Widget>[
         RaisedButton(
           child: Text('Sign Out'),
           onPressed: ()async{
                          AuthService().signOut();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));


         })
       ],
       
       ),
       
       
       */
       
      child: StreamBuilder<QuerySnapshot>(
        stream: storesRef.snapshots(),
        builder: (context,snapshot){
            if(snapshot.hasData)
              {
              final List<StoreCard> docs = snapshot.data.documents.map(
                (doc)=>
                StoreCard(
                  store:Store(
                      name: doc['name'],
                      distance:  _calcDistance(doc['location']),
                      description: doc['description']??"" ,
                      contact: doc['phno'],
                      id:doc['id'],
                      sellerId: doc['sellerId'],
                      location: doc['location']
                  )  
                )
              ).toList();
             // docs.removeWhere((doc)=>doc.store.distance>2099.0);
              docs.sort((a,b)=>a.store.distance.compareTo(b.store.distance));
              
              return ListView(children: docs,physics: BouncingScrollPhysics(),);
            }
            else return Center(child: CupertinoActivityIndicator());
            

        },),

    );
  }
}

*/
import 'package:alan_voice/alan_voice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cottage_app/chefs/manageStore.dart';
import 'package:cottage_app/diners/previousOrders.dart';
import 'package:cottage_app/models/about.dart';
import 'package:cottage_app/services/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cottage_app/diners/dinerinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:cottage_app/models/payments.dart';
import 'package:cottage_app/services/authservice.dart';
import 'package:cottage_app/diners/storeComponents/store.dart';
import 'package:cottage_app/diners/shopCard.dart';
import 'package:flutter/material.dart';
import 'package:cottage_app/diners/feedback.dart';
import 'package:cottage_app/diners/storePage.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wiredash/wiredash.dart';
import 'filters.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'account.dart';
import 'package:cottage_app/diners/about.dart';
import 'notification.dart';
import 'feedback.dart';
import 'pastorder.dart';
import 'package:cottage_app/diners/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cottage_app/screens/HomeScreen.dart';

import 'constants.dart';



class StoresPage extends StatefulWidget {
 final String phNo;
  StoresPage({Key key,this.phNo}) : super(key: key);
  @override
  _StoresPageState createState() => _StoresPageState(phNo:phNo);
}

var bannerItems = ["", "", "", ""];
var bannerImage = [
  "assets/bamboo.jpg",
  "assets/leather.jpg",
  "assets/zardozi.jpg",
  "assets/silk.jpg",
  "assets/doll.jpeg"
];
class _StoresPageState extends State<StoresPage> {
   Address storeaddress = new Address();
  FirebaseUser user;
   final FirebaseAuth _auth = FirebaseAuth.instance;
   var dinerDetails;
    String dinerName;
    String phoneNo;
      var location;
   var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
           setState(() {
                tempSearchStore.add(queryResultSet[i]);
 });
        }
      });
    } else {
      tempSearchStore = [];
       queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) ==  true) {
            if (element['name'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }

      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }

  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValue = 'Sort';
  List<String> dropdownItems = <String>[
    'Sort',
    'Distance',
    'Popularity',
    'Ratings: High to Low',
    'Cost: High to Low',
    'Cost: Low to High'
  ];

  int i = 2;
  final CollectionReference storesRef  = Firestore.instance.collection("stores");
  String phNo;
  _StoresPageState({this.phNo});
  List<double> myLocation=[0.0,0.0];
  Future<void> resetUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Type', 'None');
  }
  @override
  void initState() {
    // TODO: implement initState
    init();
    _getMyLocation();
    super.initState();
      AlanVoice.addButton("0dd0a79aea6e9ec9c229ea1a93f5a6552e956eca572e1d8b807a3e2338fdd0dc/stage", buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);
  }
 init() async{
 user = await  _auth.currentUser();
 dinerDetails = await Firestore.instance.collection("diners").document(user.uid).get();
 setState(() {
   dinerName = dinerDetails.data['name'];
   location = dinerDetails.data['location'];
   phoneNo = dinerDetails.data['phoneNo'];
 });
_getAddress(location);
 }
  _getAddress(List<dynamic> coordinates) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(coordinates[0], coordinates[1]));
    var firstresult = addresses.first;
    setState(() {
      storeaddress = firstresult;
    });
  }
  _getMyLocation()async {

    var mylocation = await getLocation();
    setState(() {
      myLocation = mylocation;
    });
  }
   double _calcDistance(List<dynamic> storeLoc){
      if(this.myLocation[0] == 0.0 && this.myLocation[1]==0.0){
        return 0.0;
      }
      else{
          final Distance distance = new Distance();
              
          // km = 423
          final double km = distance.as(LengthUnit.Kilometer,
          new LatLng(storeLoc[0],storeLoc[1]),new LatLng(this.myLocation[0],this.myLocation[1]));
          
          // // meter = 422591.551
          final double meter = distance(
              new LatLng(storeLoc[0],storeLoc[1]),new LatLng(this.myLocation[0],this.myLocation[1])
              );
          // if(meter>1000){
          //   return '$km Km';
          // }
          // else{
            return meter;

          // }

      }
    }

  @override
  Widget build(BuildContext context) {
     var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
    final drawerHeader =/* UserAccountsDrawerHeader(
      accountName: Text(dinerName!=null ? dinerName : "Name"),
      accountEmail: Text(phoneNo!=null ? phoneNo : "Null"),
      decoration: BoxDecoration(
        color: Colors.redAccent[700],
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/foodie.jpg"),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
            title: Text('My Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Account()),
              );
            }),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        ListTile(
            title: Text('Switch to Chef mode'),
            onTap: ()async {
  await resetUserType();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>HomeScreen()));

            } //=> Navigator.of(context).push(_NewPage(2)),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        ListTile(
          title: Text('Previous Orders'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrevOrdersPage()),
            );
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        ListTile(
          title: Text('Notifications'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        ListTile(
          title: Text('Feedback'),
          onTap: () {
            Wiredash.of(context).show();
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        ListTile(
          title: Text('About'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Credits()),
            );
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () async{
             AuthService().signOut();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));
             signOutGoogle();


          },
        ),
      ],
    );*/
   

    Drawer(
        child: SingleChildScrollView(
                  child: Column(
    children: <Widget>[
      Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.cyan[900],
              Colors.cyan[800],
              Colors.cyan,
              Colors.cyan[200],
            ]),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                         "assets/woodwork.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  dinerName!=null ? dinerName : "Name",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  phoneNo!=null ? phoneNo : "Null",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
      ),
      ListTile(
          leading: Icon(Icons.person),
          title: Text(
            'My Account',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Account()),
              );
          },
      ),
      Divider(),
      ListTile(
          leading: Icon(Icons.arrow_back_ios),
          title: Text(
            'Switch',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          onTap: ()async {
             await resetUserType();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>HomeScreen()));

          },
      ),
      Divider(),
      ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrevOrdersPage()),
            );
          },
          leading: Icon(Icons.arrow_drop_down_circle),
          title: Text(
            'My Previous Orders',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
      ),
      Divider(),
      ListTile(
          onTap: () {
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          },
          leading: Icon(Icons.notifications),
          title: Text(
            'Notifications',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
      ),
      Divider(),
      ListTile(
          onTap: () {
             Wiredash.of(context).show();
          },
          leading: Icon(Icons.feedback),
          title: Text(
            'FeedBack',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
      ),
      Divider(),
      ListTile(
          onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Credits()),
            );
          },
          leading: Icon(Icons.description),
          title: Text(
            'About',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
      ),
      Divider(),
      ListTile(
          onTap: () async{
             AuthService().signOut();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));
             signOutGoogle();
          },
          leading: Icon(Icons.lock),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
      ),
    ],
          ),
        ),
      );

    return dinerDetails!=null ?
    Scaffold(
      key: scaffoldKey,
      endDrawer: drawerHeader,
      body:Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SingleChildScrollView(child: Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: height,
          width: width * .42,
          color: Colors.lightBlueAccent.withOpacity(.1),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Container(
          height: width * .7,
          width: width * .8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
            color: Colors.lightBlueAccent.withOpacity(.6),
          ),
        ),
      ),
      Positioned(
        top: height * .13,
        left: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50.0,
                width: 350.0,
                margin: EdgeInsets.symmetric(vertical: 1),
                padding: EdgeInsets.symmetric(
                    horizontal: 15, vertical: 5 // 5 top and bottom
                    ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (val) {
                     initiateSearch(val);
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: 'Explore Indian Golden Industry',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(4),
                          child: Container(
                height: 50.0,
                width: 350.0,
                margin: EdgeInsets.symmetric(vertical: 1),
                padding: EdgeInsets.symmetric(
                    horizontal: 15, vertical: 5 // 5 top and bottom
                    ),
                decoration: BoxDecoration(
                 // color: Colors.white.withOpacity(0.8),
                  //borderRadius: BorderRadius.circular(12),
                ),
                child: 
                
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.redAccent[700],
                              ),
                              Flexible(
                                child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                             child: new Text(
                                
                                   
                                    storeaddress.addressLine != null ? storeaddress.addressLine :"My Location",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold ),
                                    textAlign: TextAlign.center,
                                  ),)
                                ),
                              
                            ]),
            
            ))
          ],
        ),
      ),
      Positioned(top: 300.0, child: banner(context)),
      Padding(padding: 
      EdgeInsets.only(top: 400),
      child: Padding(
    padding: EdgeInsets.symmetric(vertical: 60),
    child: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
              children: <Widget>[
                //SearchBox(onChanged: (value) {}),
                // CategoryList(),
                SizedBox(height: kDefaultPadding / 2),
                Expanded(
        child: Stack(
          children: <Widget>[
            // Our background
           Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: storesRef.snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData)
                  {
                    final List<StoreCard> docs = tempSearchStore.map(
                            (doc)=>
                            StoreCard(
                                store:Store(
                                    name: doc['name'],
                                    distance:  _calcDistance(doc['location']),
                                    description: doc['description']??"" ,
                                    contact: doc['phno'],
                                    id:doc['id'],
                                    sellerId: doc['sellerId'],
                                    location: doc['location']
                                )
                            )
                    ).toList();
                    // docs.removeWhere((doc)=>doc.store.distance>2099.0);
                    docs.sort((a,b)=>a.store.distance.compareTo(b.store.distance));

                    return ListView(children: docs,physics: BouncingScrollPhysics(),);
                  }
                  else return Center(child: CupertinoActivityIndicator());


                },),
            )
          ],
        ),
                ),
              ],
            ),
      ),
    ),
  )
      )
    ],
  )),
               // Padding(padding: EdgeInsets.symmetric(vertical: 200)),
              ],
            ),
          ),
        ],
      ),
    ): Center(
      child: CircularProgressIndicator()
    );
  }
}



Widget banner(BuildContext context) {
  var screenWidth = MediaQuery.of(context).size.width;

  PageController controller =
      PageController(viewportFraction: 0.8, initialPage: 1);

  List<Widget> banners = new List<Widget>();

  for (int x = 0; x < bannerItems.length; x++) {
    var bannerView = Padding(
      padding: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: screenWidth,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          spreadRadius: 1.0)
                    ]),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image.asset(
                  bannerImage[x],
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black])),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      bannerItems[x],
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    Text(
                      "More than 40% Off",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    banners.add(bannerView);
  }

  return Container(
    width: screenWidth,
    height: screenWidth * 9 / 16,
    child: PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      children: banners,
    ),
  );
  
} 
/*Widget body(BuildContext context) {
  return  Padding(
    padding: EdgeInsets.symmetric(vertical: 60),
    child: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
              children: <Widget>[
                //SearchBox(onChanged: (value) {}),
                // CategoryList(),
                SizedBox(height: kDefaultPadding / 2),
                Expanded(
        child: Stack(
          children: <Widget>[
            // Our background
           Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: storesRef.snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData)
                  {
                    final List<StoreCard> docs = tempSearchStore.map(
                            (doc)=>
                            StoreCard(
                                store:Store(
                                    name: doc['name'],
                                    distance:  _calcDistance(doc['location']),
                                    description: doc['description']??"" ,
                                    contact: doc['phno'],
                                    id:doc['id'],
                                    sellerId: doc['sellerId'],
                                    location: doc['location']
                                )
                            )
                    ).toList();
                    // docs.removeWhere((doc)=>doc.store.distance>2099.0);
                    docs.sort((a,b)=>a.store.distance.compareTo(b.store.distance));

                    return ListView(children: docs,physics: BouncingScrollPhysics(),);
                  }
                  else return Center(child: CupertinoActivityIndicator());


                },),
            )
          ],
        ),
                ),
              ],
            ),
      ),
    ),
  );
}*/
/* Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  children: [
                    ClipPath(
                      clipper: MyClip(),
                      child: Container(
                        height: 200.0,
                        color: Colors.redAccent[700],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      "Welcome to Local Kitchen!",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                          fontFamily: 'Pacifico'),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.menu),
                                    color: Colors.white,
                                    iconSize: 30,
                                    onPressed: () =>
                                        scaffoldKey.currentState.openEndDrawer(),
                                  )
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                height: 45.0,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 34.0, vertical: 30.0),
                                child: TextField(
                                        onChanged: (val) {
                initiateSearch(val);},
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: "Search for the best home kitchens",
                                    hintStyle: TextStyle(color: Colors.grey[700]),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 14.0),
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.search,
                                      size: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      child: FlatButton(
                        onPressed: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.redAccent[700],
                              ),
                              Flexible(
                                child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                             child: new Text(
                                
                                   
                                    storeaddress.addressLine != null ? storeaddress.addressLine :"My Location",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15, ),
                                    textAlign: TextAlign.center,
                                  ),)
                                ),
                              
                            ]),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[200],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.redAccent[700],
                                ),
                                iconSize: 36,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: dropdownItems
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Container(
                              child: RaisedButton(
                                elevation: 1,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Filter()),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Text('Filter',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey)),
                                    Icon(
                                      Icons.grain,
                                      color: Colors.redAccent[700],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FlatButton(
                              color: Colors.transparent,
                              child: Icon(Icons.brightness_6),
                                onLongPress: (){
                                  Navigator.of(context).push(MaterialPageRoute<void>(
                                      builder: (BuildContext context) {
                                        return Scaffold(
                                          body: const WebView(
                                            initialUrl: 'https://playsnake.org/',
                                            javascriptMode: JavascriptMode.unrestricted,
                                          ),
                                        );

                                      }
                                  ));
                                }, onPressed: () {  },


                            )]),
                    ),
                    Container(
                      height: 200,
                      width: 350,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: [
                          'assets/First.jpg',
                          'assets/Second.jpg',
                          'assets/Ind1.png',
                          'assets/Amer1.png',
                          'assets/Mex1.png',
                          'assets/Th1.png'
                        ].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Image.asset('$i'),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[200],
            ),*/
           /* Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: storesRef.snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData)
                  {
                    final List<StoreCard> docs = tempSearchStore.map(
                            (doc)=>
                            StoreCard(
                                store:Store(
                                    name: doc['name'],
                                    distance:  _calcDistance(doc['location']),
                                    description: doc['description']??"" ,
                                    contact: doc['phno'],
                                    id:doc['id'],
                                    sellerId: doc['sellerId'],
                                    location: doc['location']
                                )
                            )
                    ).toList();
                    // docs.removeWhere((doc)=>doc.store.distance>2099.0);
                    docs.sort((a,b)=>a.store.distance.compareTo(b.store.distance));

                    return ListView(children: docs,physics: BouncingScrollPhysics(),);
                  }
                  else return Center(child: CupertinoActivityIndicator());


                },),
            )
          ],
        ),

      ),
    )
  }
}*/


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps/diners/search.dart';

void main() => runApp(new StoresPage());

class StoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
           setState(() {
                tempSearchStore.add(queryResultSet[i]);
 });
        }
      });
    } else {
      tempSearchStore = [];
       queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) ==  true) {
            if (element['name'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }

      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Firestore search'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList())
        ]));
  }
}

Widget buildResultCard(data) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: Container(
      child: Center(
        child: Text(data['name'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
        )
      )
    )
  );
}*/