import 'package:cottage_app/models/orderCard.dart';
import 'package:cottage_app/models/orderData.dart';
import 'package:cottage_app/services/firebaseUserProvider.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

class PrevOrdersPage extends StatefulWidget {
  PrevOrdersPage({Key key}) : super(key: key);

  @override
  _PrevOrdersPageState createState() => _PrevOrdersPageState();
}

class _PrevOrdersPageState extends State<PrevOrdersPage> {
  FirebaseUser user;

  @override
  void initState() {
    user = Provider.of<FirebaseUserProvider>(context, listen: false).user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('Previous Orders',style: TextStyle(fontFamily: 'Lobster'),),backgroundColor: Colors.red[800],),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('diners')
              .document(user?.uid ?? "")
              .collection('orders')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> prevOrdersdocs=snapshot.data.documents;
              prevOrdersdocs.sort((a,b)=>-a.data['timestamp'].compareTo(b.data['timestamp']));
              List<OrderData> prevOrders = prevOrdersdocs
                  .map((doc) => OrderData.fromJson(doc))
                  .toList();
            List<String> orderids=prevOrdersdocs.map((doc)=>doc.documentID.toString()).toList();
              

              if (prevOrders.length == 0)
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.remove_shopping_cart,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        'No orders placed yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index >= prevOrders.length) return null;
                  return OrderCard(
                      order: prevOrders[index],
                      dist:0.0,
                      isSeller: false,
                      orderid: orderids[index],
                      user: user,);
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
