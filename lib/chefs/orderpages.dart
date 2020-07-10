import 'package:cottage_app/models/orderCard.dart';
import 'package:cottage_app/models/orderData.dart';
import 'package:cottage_app/services/firebaseUserProvider.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  FirebaseUser user;

  List<double> _myLocation = [0.0, 0.0];

  _getMyLocation() async {
    List<double> myLocation =
        Provider.of<SellerDetailsProvider>(context, listen: false)
            .store
            .location;

    setState(() {
      this._myLocation = myLocation;
    });
    print(this._myLocation);
  }

  double _calcDistance(List<dynamic> buyerLocation) {
    if (this._myLocation[0] == 0.0 && this._myLocation[1] == 0.0) {
      return 0.0;
    } else {
      final Distance distance = new Distance();
      // km = 423
      final double km = distance.as(
          LengthUnit.Kilometer,
          new LatLng(buyerLocation[0], buyerLocation[1]),
          new LatLng(this._myLocation[0], this._myLocation[1]));

      final double meter = distance(
          new LatLng(buyerLocation[0], buyerLocation[1]),
          new LatLng(this._myLocation[0], this._myLocation[1]));
      return meter;
    }
  }

  @override
  void initState() {
    user = Provider.of<FirebaseUserProvider>(context, listen: false).user;
    _getMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child :
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 3.0,
        title:Text("My Orders",style:TextStyle(
          color : Colors.white,
          fontFamily: "Pacifico",
          fontSize: 25.0,
          fontWeight: FontWeight.bold
        )),
        centerTitle:true,

      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('chefs')
              .document(user?.uid ?? "")
              .collection("orders")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
               List<DocumentSnapshot> prevOrdersdocs=snapshot.data.documents;
              List<OrderData> currentOrders = snapshot.data.documents
                  .map((doc) => OrderData.fromJson(doc))
                  .toList();

              List<String> orderids=  prevOrdersdocs.map((doc)=>doc.documentID.toString()).toList();
              

              if (currentOrders.length == 0)
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
                currentOrders
                  .sort((a, b) => -a.timeoforder.compareTo(b.timeoforder));
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index >= currentOrders.length) return null;
                  if (currentOrders[index].isDelivered==true) return Container(height: 0,);
                  return OrderCard(
                      order: currentOrders[index],
                      dist: _calcDistance(currentOrders[index].userLocation,),
                      isSeller: true,
                      user: user,
                      orderid: orderids[index]
                      );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }
}
