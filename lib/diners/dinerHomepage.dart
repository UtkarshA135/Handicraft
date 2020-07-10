import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cottage_app/chefs/orderpages.dart';
import 'package:cottage_app/diners/all_chefs_screen.dart';
import 'package:cottage_app/diners/cart.dart';
import 'package:cottage_app/diners/previousOrders.dart';
import 'package:cottage_app/diners/storePage.dart';
import 'package:cottage_app/services/authservice.dart';
import 'package:theme_provider/theme_provider.dart';
import 'chat.dart';
import 'package:cottage_app/models/feedback.dart';
import 'package:cottage_app/diners/cart/cartPage.dart';
import 'homemade.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class DinerHomePage extends StatefulWidget {
  @override
  _DinerHomePageState createState() => _DinerHomePageState();
}

class _DinerHomePageState extends State<DinerHomePage> {
   final AuthService _auth = AuthService();
   int _page = 0;
 GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
     final List<Widget>pageOption = [
StoresPage(),CartPage(),AllUsersScreen()
];
    return Scaffold(
      //appBar: ,
     
     body: pageOption[_page],

        bottomNavigationBar: CurvedNavigationBar(
        
          backgroundColor: Colors.white,
          color: Colors.lightBlue[200],
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(Icons.list, size: 30,color: Colors.black,),
            Icon(Icons.shopping_cart, size: 30,color: Colors.black,),
            Icon(Icons.chat, size: 30,color: Colors.black,),
            
          ],
          onTap:  onTabTapped, // new
            
        ),
        
        );
  }
        void onTabTapped(int index) {
   setState(() {
     _page = index;
   });
  }
}