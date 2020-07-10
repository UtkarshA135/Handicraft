
import 'package:cottage_app/chefs/itemcategory.dart';
import 'package:cottage_app/chefs/orderpages.dart';
import 'package:cottage_app/diners/constants.dart';
import 'package:cottage_app/diners/storePage.dart';
import 'package:cottage_app/models/ItemListingModel.dart';
import 'package:cottage_app/services/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cottage_app/diners/about.dart';
import 'dart:io';
import 'package:cottage_app/screens/HomeScreen.dart';
import 'package:cottage_app/services/authservice.dart';
import 'package:geocoder/geocoder.dart';
import 'package:wiredash/wiredash.dart';
import 'package:cottage_app/models/about.dart';
import 'package:cottage_app/models/feedback.dart';
import 'package:cottage_app/models/notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'chefinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cottage_app/chefs/account.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'package:cottage_app/services/chefsDetailProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:multi_media_picker/multi_media_picker.dart';
import 'dart:io';

import 'chefaccount.dart';
class ManageStore extends StatefulWidget {
  @override
  _ManageStoreState createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
   FirebaseUser user;
  TabController _tabController;
   Address storeaddress = new Address();
  String storeName = " ";
  String phoneNo = " ";
  List<String> cuisineslist =  List<String>();
  List imgurls =  List();
  String sellerName = " ";
  String storeId;
   var location;
  bool isDataLoaded;
     var sellerDetails;
      String storeid ;
      var storeDetails ;
       var scaffoldKey = GlobalKey<ScaffoldState>();
    List<bool> choicesChipcuisine = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  var bannerItems = ["", "", "", ""];
var bannerImage = [
  "assets/bamboo.jpg",
  "assets/leather.jpg",
  "assets/zardozi.jpg",
  "assets/silk.jpg",
  "assets/doll.jpeg"
];
  static const cuisine = ['American',
    'Belizean ',
     'Chinese',
     'Canadian',
     'Japaneese',
    'Indian',
    'Italian',
    'Mexican',
    'Texan',];
    List<File> _imgs;
    List<String> imgUrls = List ();
    Stream<QuerySnapshot> availableItemsStream;

  List<ItemListingModel> availableItems = new List();

    Future<void> resetUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Type', 'None');
  }
  _onImageButtonPressed(ImageSource source, {bool singleImage = false}) async {
    var imgs;
    imgs = await MultiMediaPicker.pickImages(source: source, singleImage: singleImage);
    setState(() {
       _imgs = imgs;
    });
  }
   @override
  void initState() {
    init();
    super.initState();}
     init() async {
    user = await getUser();
    isDataLoaded =
        Provider.of<SellerDetailsProvider>(context, listen: false).isDataLoaded;
    await _loadStoreDetails();
    await choice();
    await _getAddress(location);
      this.storeId =
        Provider.of<SellerDetailsProvider>(context, listen: false).store.id;
    this.availableItemsStream =
        Provider.of<SellerDetailsProvider>(context, listen: false)
            .availableItemStream;
  }
  _getAddress(List<dynamic> coordinates) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(coordinates[0], coordinates[1]));
    var firstresult = addresses.first;
    setState(() {
      storeaddress = firstresult;
    });
  }
  choice() async {
for(int i =0 ; i< cuisineslist.length ; i++)
{
  for(int j = 0; j< cuisine.length ; j++)
  {
    if(cuisineslist[i].compareTo(cuisine[j])==0)
    {
      choicesChipcuisine[j] = true;
      print(choicesChipcuisine[j]);
    }
  }
}
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
        this.imgurls = storeDetails['urls'];
       // this.cuisineslist = storeDetails['cuisines'];
        this.sellerName = sellerDetails.data['name'];
        this.location = storeDetails['location'];
      });
      pref.setString("storename", storename);
    } else {
      setState(() {
        this.storeName = storename;
        print(storeName);
      });
    }
  }

     uploadToFirebase() {
   
      _imgs.forEach((image) => {uploadImage(image)});

    } 
   Future  uploadImage (image) async{
     
   
final StorageReference postImgref = FirebaseStorage.instance.ref().child('Post Images');
var timeKey = new DateTime.now();
final StorageUploadTask uploadTask = postImgref.child(timeKey.toString()+'.jpg').putFile(image);
var imgurl = await(await uploadTask.onComplete).ref.getDownloadURL();
 String url = imgurl.toString();
print(url);
 setState(() {
      imgUrls.add(url);
    });
   await Firestore.instance.collection('stores').document(storeid).updateData({
        "urls": FieldValue.arrayUnion([url]),
   });
    print(imgUrls);
  }
 
  @override
    var images = ['assets/chefs.jpg','assets/foodie..jpg'];
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
     final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(sellerName),
      accountEmail: Text(phoneNo),
      decoration: BoxDecoration(
        color: Colors.redAccent[700],
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/chefs.jpg"),
      ),
    );
    final drawerItems   = Drawer(
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
                  sellerName!=null ? sellerName : "Name",
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
                MaterialPageRoute(builder: (context) => Chefaccount()),
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
              MaterialPageRoute(builder: (context) => OrdersPage()),
            );
          },
          leading: Icon(Icons.arrow_drop_down_circle),
          title: Text(
            'My Orders',
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
    return  SafeArea(
   

      child: Scaffold(
        key: scaffoldKey,
        endDrawer:drawerItems,
        body: storeDetails!=null?
        Stack(
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
                child: Text(
               storeName,
                  style: TextStyle(color: Colors.black,
                  fontFamily: "Lobster",
                  fontSize: 22
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
                SizedBox(height :15),
            Text("Set up your store",
            style: TextStyle(
              fontFamily:"Lobster",
              fontSize: 22,
              fontWeight : FontWeight.bold
            ),
            ),
                Expanded(
        child: Stack(
          children: <Widget>[
            // Our background
            
           Expanded(
              child: CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
     
        CategoryComponent(
          categoryID: 1,
          categoryName: 'Embroidery',
        ),
        CategoryComponent(
          categoryID: 2,
          categoryName: 'Woodwork',
        ),
        CategoryComponent(
          categoryID: 3,
          categoryName: 'Pottery',
        ),
        CategoryComponent(
          categoryID: 4,
          categoryName: 'Ceramic',
        ),
        CategoryComponent(
          categoryID: 5,
          categoryName: 'Terracotta',
        ),
        CategoryComponent(
          categoryID: 6,
          categoryName: 'Weaving and Spinning',
        ),
      ],
     ) 
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
        )
     :Center(
       child : CircularProgressIndicator(),
     )
    ),
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