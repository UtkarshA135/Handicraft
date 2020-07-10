import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cottage_app/services/firebaseUserProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qr/qr.dart';

class BuyerQRCodePage extends StatelessWidget {
  final String orderid;
  FirebaseUser user;

  BuyerQRCodePage({this.orderid = '0', this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Delivery Confirmation',
          style: TextStyle(fontFamily: 'Archia'),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('diners')
              .document(user?.uid ?? "")
              .collection("orders")
              .document(orderid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var thisOrder = snapshot.data.data;

              if (thisOrder['isDelivered']) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            child: Icon(
                              Icons.check_circle,
                              size: 80,
                              color: Colors.grey,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          child: Text(
                            'You have paid for and accepted delivery of this Order',
                            style: TextStyle(color: Colors.grey, fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                );
              } else
                return Center(
                    child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      'Once you receive the goods and make the payment, ask the person to scan the QR Code and open the URL/tap on confirm to complete the order.',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                    PrettyQr(
                        image: AssetImage('assets/kiranaseva.png'),
                        typeNumber: 10,
                        size: 200,
                        data:
                            'https://us-central1-covid-19-50e92.cloudfunctions.net/onOrderComplete?orderId=${orderid}&buyerId=${user.uid}&sellerId=${thisOrder['sellerId']}',
                        errorCorrectLevel: QrErrorCorrectLevel.M,
                        roundEdges: true)
                  ],
                ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
