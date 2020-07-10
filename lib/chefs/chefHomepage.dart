import 'package:flutter/material.dart';
import 'package:cottage_app/chefs/all_diners_screen.dart';

import 'dart:async';
import 'package:cottage_app/chefs/chefinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cottage_app/chefs/itemManage.dart';
import 'package:cottage_app/chefs/orderpages.dart';
import 'package:cottage_app/models/chat.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manageStore.dart';

class ChefHomePage extends StatefulWidget {
  ChefHomePage({Key key}) : super(key: key);
  @override
  _ChefHomePageState createState() => _ChefHomePageState();
}

class _ChefHomePageState extends State<ChefHomePage>
    with SingleTickerProviderStateMixin {
  FirebaseUser user;
  TabController _tabController;
  String storeName;
  String storeId;
  bool isDataLoaded;
int _page = 0;
 GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
   // _tabController = new TabController(length: 2, vsync: this);
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
      var sellerDetails = await Firestore.instance
          .collection('chefs')
          .document(user.uid)
          .get();
      String storeid = sellerDetails.data['storeId'];
      this.storeId = storeid;
      var storeDetails =
          await Firestore.instance.collection('stores').document(storeid).get();
      setState(() {
        this.storeName = storeDetails.data['name'];
      });
      pref.setString("storename", storename);
    } else {
      setState(() {
        this.storeName = storename;
      });
    }
  }

  String phoneNumber;
  Future<void> resetUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Type', 'None');
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _phno = prefs.getString('Phone Number');
    if (_phno != null)
      return _phno;
    else
      return 'Does not exist';
  }
  void onTabTapped(int index) {
   setState(() {
     _page = index;
   });
 }
  @override
  Widget build(BuildContext context) {
         final List<Widget>pageOption = [
ManageStore(),OrdersPage(),AllUsersScreen()
];
    return Consumer<SellerDetailsProvider>(
      builder: (context, data, child) {
        if (data.isDataLoaded)
          return Scaffold(
          
             body: pageOption[_page],

        bottomNavigationBar: CurvedNavigationBar(
        
          backgroundColor:Colors.white,
          color: Colors.lightBlue[200],
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(Icons.store, size: 30,color: Colors.black,),
          //  Icon(Icons.library_add,size: 30,),
            Icon(Icons.shopping_basket, size: 30,color: Colors.black,),
            Icon(Icons.chat, size: 30,color: Colors.black,),
            
          ],
          onTap:  onTabTapped, // new
            
        ),
        
           
          );
        else
          return Scaffold(
            backgroundColor: Colors.lightGreen,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Hero(
                      tag: 'Seller',
                      child: Container(
                        height: 200,
                        child: Image.asset('assets/seller.png'),
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  CupertinoActivityIndicator(
                    radius: 25,
                  ),
                ])),
          );
      },
    );
  }
}

