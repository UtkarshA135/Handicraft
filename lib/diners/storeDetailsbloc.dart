import 'package:cottage_app/diners/dinerinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:cottage_app/diners/storeComponents/store.dart';

class MyStorePageBLoc extends ChangeNotifier{
  FirebaseUser user;
  List<String> itemsCatalogue;
  bool showLoading = true;
  List<dynamic> location;
  Store store;
 String uid;
  MyStorePageBLoc(Store store){
    this.store =store;
    init();
  }

  init()async {
     this.uid =await  _getUser();
    await _getLocation();
     print(uid);
     showLoading = false;
      notifyListeners();
  }
  _getLocation()async {
     this.location = await getLocation();
  }
   Future<String> _getUser() async {
       user = await FirebaseAuth.instance.currentUser();
      return user != null ? user.uid : null;
    }
  _getlist()async {
      
        showLoading = false;
      notifyListeners();
  }

  Future<bool> add2cart(String itemName,double itemPrice, String url) async {
    print(this.store.id);
    var cartOfShop = await Firestore.instance
        .collection('diners')
        .document('${this.uid}')
        .collection('cart')
        .document('${this.store.id}')
        .get();
    
    if (cartOfShop.data == null) {
      Map<String, dynamic> t = new Map();
      t['storeName'] = this.store.name;
      t['storeId'] = this.store.id;
      t['sellerId'] =this.store.sellerId;
      t['items'] = [{'itemName':itemName,'itemPrice':itemPrice,'quantity':1,'url':url}];
      t['buyerName'] = user.displayName;
      t['buyerContact'] = user.phoneNumber;
      t['location']=location;
      t['timestamp'] = new DateTime.now();
      Firestore.instance
          .collection('diners')
          .document('${this.uid}')
          .collection('cart')
          .document('${this.store.id}')
          .setData(t);
    } else {
      List<dynamic> items = cartOfShop.data['items'];
      int index=items.indexWhere((item)=>item['itemName']==itemName);
      if(index==-1){
      items.add({'itemName':itemName,'itemPrice':itemPrice,'quantity':1,'url':url});}
      else{
        items[index]['quantity']++;
      }
      Map<String, dynamic> t = new Map();
      t['items'] = items;
      Firestore.instance
          .collection('diners')
          .document('${this.uid}')
          .collection('cart')
          .document('${this.store.id}')
          .updateData(t);
    }
    return true;
  }
  
}
