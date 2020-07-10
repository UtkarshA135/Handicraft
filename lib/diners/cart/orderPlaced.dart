

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cottage_app/diners/storeComponents/store.dart';
import 'package:cottage_app/services/firebaseUserProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

class OrderPlacedPage extends StatefulWidget {
  const OrderPlacedPage({Key key}) : super(key: key);

  @override
  _OrderPlacedPageState createState() => _OrderPlacedPageState();
}

class _OrderPlacedPageState extends State<OrderPlacedPage> {
   Store store;
  FirebaseUser user;
  OrderPlacedPage(Store store){
this.store = store;
  }
  @override
  void initState() {
    user = Provider.of<FirebaseUserProvider>(context, listen: false).user;
    _placeOrder();
    super.initState();
  }

  _placeOrder() async {
    var uuid = Uuid();
    List  decodedCartItems = new List();
    Firestore.instance
        .collection('diners')
        .document('${this.user.uid}')
        .collection('cart').snapshots().listen((event) { 
          event.documents.forEach((element) async{
            decodedCartItems.add(element.data);
         //   print(element.data);
            
          // print(decodedCartItems);
           var sellerId = element.data['sellerId'];
        var storeId = element.data['storeId'];
        var items = element.data['items'];
        var timestamp =element.data['timestamp'];
        var key = uuid.v1();
        
        element.data['orderId'] = key;
        element.data['isDelivered'] =false;
        await Firestore.instance.collection('chefs').document(sellerId).collection('orders').document(key).setData(element.data);
       await  saveToBuyersOrdersCollection(user.uid,sellerId,storeId,key,items,timestamp);
          });
        });
        
    print(decodedCartItems);
 
 var value  =  await Firestore.instance
        .collection('diners')
        .document('${this.user.uid}')
        .collection('cart').getDocuments();
        for (DocumentSnapshot ds in value.documents){
      ds.reference.delete();
    }
  }
    saveToBuyersOrdersCollection(uid,sellerId,storeId,key,items,timestamp)
    async
    {
 var storeDetails = (await Firestore.instance.collection('stores').document(storeId).get()).data;
    var sellerDetails = (await Firestore.instance.collection('chefs').document(sellerId).get()).data;
    //console.log(sellerDetails)
    var ordersDoc = {
        'isDelivered' : false,
        'sellerName':sellerDetails['name'],
        'storeLocation':storeDetails['location'],
        'sellerPhno':sellerDetails['phno1'],
        'items':items,
        'timestamp':timestamp,
        'storeName':storeDetails['name'],
        'sellerId':sellerDetails['uid']
    };
    await  Firestore.instance.collection('diners').document(uid).collection('orders').document(key).setData(ordersDoc);
}

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Icon(
                  Icons.shopping_basket,
                  size: 80,
                  color: Colors.grey,
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text(
                'Your order has been placed',
                style: TextStyle(color: Colors.grey, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child:Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[ IconButton(
                  icon:Icon(Icons.arrow_back,
                  
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: ()=>Navigator.pop(context),
                ),
                Text('Go back',style: TextStyle(color: Colors.grey, fontSize: 16),)
                ],)
                ),
          ]),
    ));
  }
}
