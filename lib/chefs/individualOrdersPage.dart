/*import 'package:maps/diners/dinerQRpage.dart';
import 'package:maps/models/orderData.dart';
import 'package:maps/chefs/ordersItemTable.dart';
import 'package:maps/services/generateBillpdf.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps/chefs/chefscanner.dart';

class IndividualOrderPage extends StatefulWidget {
  final OrderData orderData;
  final double distance;
  final bool isSeller;
  final String orderid;
  final FirebaseUser user;
  IndividualOrderPage(
      {Key key,
      this.orderData,
      this.distance = 0.0,
      this.isSeller = true,
      this.orderid,
      this.user})
      : super(key: key);

  @override
  _IndividualOrderPageState createState() =>
      _IndividualOrderPageState(orderData: orderData, distance: distance);
}

class _IndividualOrderPageState extends State<IndividualOrderPage> {
  final OrderData orderData;
  final double distance;
  double billamount = 0.0;
  _IndividualOrderPageState({this.orderData, this.distance});
  List<String> items = new List();

  @override
  void initState() {
    _calculatebillamount();
    super.initState();
  }

  _calculatebillamount() {
    var bill = 0.0;
    orderData.items
        .forEach((item) => {bill += (item['itemPrice'] * item['quantity'])});
    setState(() {
      billamount = bill;
    });
  }

  SliverToBoxAdapter _ProfileCard() {
    String messageText = 
         'Hi%20${orderData.buyerName}\n%20\nThis is regarding your Order with *${orderData.storeName}*\.%20\n\nYou%20have%20ordered%20\n\n${orderData.items.toString()}\n\n_\<Compose%20Message%20Here%20\>_';
       // : 'Hi%20${orderData.sellerName}\n%20\nThis is regarding my Order with *${orderData.storeName}*\.%20\n\nI%20have%20ordered%20\n\n${orderData.items.toString()}\n\nGive me updates on my order';

    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 11),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                        Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CircleAvatar(backgroundColor: Colors.white,
                              child: Image.asset('assets/foodie.jpg'),
                              radius: 50.0,
                            )),
                      /*  : Padding(
                            padding: EdgeInsets.only(left: 20),
                            child:  Image.asset('assets/food.jpg',cacheHeight: 75,),

                            ),*/
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                             "${orderData.buyerName}",
                                  //: "${orderData.storeName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),SizedBox(height: 5,),
                            Text(
                               "${orderData.buyerContact}",
                                  //: "${orderData.sellerContact}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: IconButton(
                            icon: Icon(Icons.message,color: Colors.red,),
                            onPressed: () {
                              _launchURL(
                                   'https://wa.me/${orderData.buyerContact}?text=${messageText}');
                                  //: 'https://wa.me/++91${orderData.sellerContact}?text=${messageText}');
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: IconButton(
                            icon: Icon(Icons.call,color: Colors.red,),
                            onPressed: () {
                              _launchURL(
                                   "tel:${orderData.buyerContact}"
                               //   : 'tel:${orderData.sellerContact}'
                               );
                            },
                          )),
                    ]),
              ],
            ),
          )),
    ));
  }

  SliverToBoxAdapter _OrderItemsTable() {
    DateTime orderTiming = orderData.timeoforder.toDate();

    return SliverToBoxAdapter(
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(children: <Widget>[
              SizedBox(
                height: 8,
              ),
              OrderItemsTable(
                itemListings: orderData.items,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.access_time,color: Colors.red,
                    ),
                    Text(
                      '  Order placed at ${orderTiming.hour}:${orderTiming.minute} on ${orderTiming.day}/0${orderTiming.month}',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ]),
              SizedBox(
                height: 15,
              ),
              Text(
                'Total Bill Amount : ₹ $billamount',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
              SizedBox(
                height: 8,
              ),
            ])));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  SliverToBoxAdapter _LocationCard() {
    return SliverToBoxAdapter(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CircleAvatar(backgroundColor: Colors.white,
                            child: Icon(
                              Icons.location_on,
                              size: 60,color: Colors.red[800],
                            ),
                            radius: 50.0,
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('${distance / 1000} km away')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton.icon(
                            label: Text('Show on maps',style: TextStyle(color: Colors.white),),
                            icon: Icon(Icons.map,color: Colors.white,),
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              _launchURL(
                                  'https://www.google.com/maps/search/?api=1&query=${orderData.userLocation[0]},${orderData.userLocation[1]}');
                            },
                          )),
                       Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: RaisedButton.icon(
                                label: Text('Navigate',style: TextStyle(color: Colors.white),),
                                icon: Icon(Icons.navigation,color: Colors.white,),
                                color: Colors.red[800],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                onPressed: () {
                                  _launchURL(
                                      "google.navigation:q=${orderData.userLocation[0]},${orderData.userLocation[1]}");
                                },
                              )),
                      /*    : Container(
                              height: 0,
                              width: 0,
                            ),*/
                    ]),
              ],
            ),
          )),
    );
  }

  SliverToBoxAdapter _OrderHandle() {
    return SliverToBoxAdapter(
      
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            height: 160,
            child : FittedBox(
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CircleAvatar(backgroundColor: Colors.white,
                            child: Icon(
                              Icons.shopping_cart,
                              size: 60,color: Colors.red[800],
                            ),
                            radius: 50.0,
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('Manage')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    
                           RaisedButton.icon(
                              label: Text('Send details to Delivery Agent',
                                  style: TextStyle(fontSize: 12,color: Colors.white)),
                              icon: Icon(Icons.send,color: Colors.white,),
                              color: Colors.red[800],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                
                              _launchURL( 'https://wa.me/?text=Deliver%20an%20order%20of%20Rs$billamount%20to%20Mr/Ms%20${orderData.buyerName}%20(\+${orderData.buyerContact})\n\nScan%20the%20QR-Code%20shown%20by%20the%20customer%20to%20complete%20your%20delivery');
                            

                              },
                            ),
                          
                      RaisedButton.icon(
                        icon: Icon(Icons.picture_as_pdf,color: Colors.white,),
                        label: Text(
                          'View Bill',
                          style: TextStyle(fontSize: 12,color: Colors.white),
                        ),
                        color: Colors.red[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          reportView(context, orderData,true,billamount);
                        },
                      ),
                      RaisedButton.icon(
                        label: Text(
                          'ORDER COMPLETED',//:'Mark as Delivered',
                          style: TextStyle(fontSize: 12,color: Colors.white),
                        ),
                        icon: Icon(Icons.check_circle_outline,color: Colors.white,),
                        color: Colors.red[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SellerQRScan()));
                              /*: Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => BuyerQRCodePage(
                                            orderid: widget.orderid,
                                            user: widget.user,
                                          )));*/
                        },
                      ),
                    ]),
              ],
            ),
          )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 
          '${orderData.buyerName}${orderData.userLocation[0]}${orderData.userLocation[1]}${orderData.timeoforder}',
           // : '${widget.orderid}',
        child: Scaffold(
          
            appBar: AppBar(
              title: Text(
                "Order Details",
                style: TextStyle(
                    fontFamily: 'Archia', fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.red[800],
              actions: <Widget>[],
              elevation: 0.0,
            ),
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                _ProfileCard(),
               _OrderItemsTable(),
                 _LocationCard() ,//: SliverToBoxAdapter(),
                _OrderHandle()
              ],
            )));
  }
}*/
import 'package:cottage_app/diners/dinerQRpage.dart';
import 'package:cottage_app/models/orderData.dart';
import 'package:cottage_app/chefs/ordersItemTable.dart';
import 'package:cottage_app/services/generatebillpdf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chefscanner.dart';

class IndividualOrderPage extends StatefulWidget {
  final OrderData orderData;
  final double distance;
  final bool isSeller;
  final String orderid;
  final FirebaseUser user;
  IndividualOrderPage(
      {Key key,
      this.orderData,
      this.distance = 0.0,
      this.isSeller = true,
      this.orderid,
      this.user})
      : super(key: key);

  @override
  _IndividualOrderPageState createState() =>
      _IndividualOrderPageState(orderData: orderData, distance: distance);
}

class _IndividualOrderPageState extends State<IndividualOrderPage> {
  final OrderData orderData;
  final double distance;
  double billamount = 0.0;
  _IndividualOrderPageState({this.orderData, this.distance});
  List<String> items = new List();

  @override
  void initState() {
    _calculatebillamount();
    super.initState();
  }

  _calculatebillamount() {
    var bill = 0.0;
    orderData.items
        .forEach((item) => {bill += (item['itemPrice'] * item['quantity'])});
    setState(() {
      billamount = bill;
    });
  }

  SliverToBoxAdapter _ProfileCard() {
    String messageText = (widget.isSeller)
        ? 'Hi%20${orderData.buyerName}\n%20\nThis is regarding your Order with *${orderData.storeName}*\.%20\n\nYou%20have%20ordered%20\n\n${orderData.items.toString()}\n\n_\<Compose%20Message%20Here%20\>_'
        : 'Hi%20${orderData.sellerName}\n%20\nThis is regarding my Order with *${orderData.storeName}*\.%20\n\nI%20have%20ordered%20\n\n${orderData.items.toString()}\n\nGive me updates on my order';

    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 11),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    (widget.isSeller)
                        ? Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              child: Image.asset('assets/userDefault.png'),
                              radius: 50.0,
                            ))
                        : Padding(
                            padding: EdgeInsets.only(left: 20),
                            child:  Image.asset('assets/grocerystoreclipart.png',cacheHeight: 75,),
                              
                            ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              (widget.isSeller)
                                  ? "${orderData.buyerName}"
                                  : "${orderData.storeName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(
                              (widget.isSeller)
                                  ? "${orderData.buyerContact}"
                                  : "${orderData.sellerContact}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: IconButton(
                            icon: Icon(Icons.message,color: Colors.red[800],),
                            onPressed: () {
                              _launchURL((widget.isSeller)
                                  ? 'https://wa.me/${orderData.buyerContact}?text=${messageText}'
                                  : 'https://wa.me/++91${orderData.sellerContact}?text=${messageText}');
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: IconButton(
                            icon: Icon(Icons.call,color: Colors.red[800],),
                            onPressed: () {
                              _launchURL((widget.isSeller)
                                  ? "tel:${orderData.buyerContact}"
                                  : 'tel:${orderData.sellerContact}');
                            },
                          )),
                    ]),
              ],
            ),
          )),
    ));
  }

  SliverToBoxAdapter _OrderItemsTable() {
    DateTime orderTiming = orderData.timeoforder.toDate();

    return SliverToBoxAdapter(
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(children: <Widget>[
              SizedBox(
                height: 8,
              ),
              OrderItemsTable(
                itemListings: orderData.items,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.access_time,color: Colors.red,
                    ),
                    Text(
                      '  Order placed at ${orderTiming.hour}:${orderTiming.minute} on ${orderTiming.day}/0${orderTiming.month}',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ]),
              SizedBox(
                height: 15,
              ),
              Text(
                'Total Bill Amount : Rs $billamount',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
              SizedBox(
                height: 8,
              ),
            ])));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  SliverToBoxAdapter _LocationCard() {
    return SliverToBoxAdapter(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CircleAvatar(
                            child: Icon(
                              Icons.location_on,
                              size: 60,
                            ),
                            radius: 50.0,
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('${distance / 1000} km away')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton.icon(
                            label: Text('Show on maps'),
                            icon: Icon(Icons.map),
                            color: Colors.tealAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              _launchURL(
                                  'https://www.google.com/maps/search/?api=1&query=${orderData.userLocation[0]},${orderData.userLocation[1]}');
                            },
                          )),
                      (widget.isSeller)
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: RaisedButton.icon(
                                label: Text('Navigate'),
                                icon: Icon(Icons.navigation),
                                color: Colors.tealAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                onPressed: () {
                                  _launchURL(
                                      "google.navigation:q=${orderData.userLocation[0]},${orderData.userLocation[1]}");
                                },
                              ))
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ]),
              ],
            ),
          )),
    );
  }

  SliverToBoxAdapter _OrderHandle() {
    return SliverToBoxAdapter(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CircleAvatar(backgroundColor: Colors.white,
                            child: Icon(
                              Icons.shopping_cart,color: Colors.red[800],
                              size: 60,
                            ),
                            radius: 50.0,
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('Manage')),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      (widget.isSeller)
                          ? RaisedButton.icon(
                              label: Text('Send details to Delivery Agent',
                                  style: TextStyle(fontSize: 12)),
                              icon: Icon(Icons.send),
                              color: Colors.red[800],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                
                              _launchURL( 'https://wa.me/?text=Deliver%20an%20order%20of%20Rs$billamount%20to%20Mr/Ms%20${orderData.buyerName}%20(\+${orderData.buyerContact})\n\nScan%20the%20QR-Code%20shown%20by%20the%20customer%20to%20complete%20your%20delivery');
                            

                              },
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      RaisedButton.icon(
                        icon: Icon(Icons.picture_as_pdf,color: Colors.white,),
                        label: Text(
                          'View Bill',
                          style: TextStyle(fontSize: 12,color: Colors.white),
                        ),
                        color: Colors.red[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          reportView(context, orderData,widget.isSeller,billamount);
                        },
                      ),
                      RaisedButton.icon(
                        label: Text(
                          (orderData.isDelivered)?'ORDER COMPLETED':'Mark as Delivered',
                          style: TextStyle(fontSize: 12,color: Colors.white),
                        ),
                        icon: Icon(Icons.check_circle_outline,color: Colors.white,),
                        color: Colors.red[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          (widget.isSeller)
                              ? Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SellerQRScan()))
                              : Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => BuyerQRCodePage(
                                            orderid: widget.orderid,
                                            user: widget.user,
                                          )));
                        },
                      ),
                    ]),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: (widget.isSeller)
            ? '${orderData.buyerName}${orderData.userLocation[0]}${orderData.userLocation[1]}${orderData.timeoforder}'
            : '${widget.orderid}',
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Order Details",
                style: TextStyle(
                    fontFamily: 'Archia', fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.red[800],
              actions: <Widget>[],
              elevation: 0.0,
            ),
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                _ProfileCard(),
                _OrderItemsTable(),
                (widget.isSeller) ? _LocationCard() : SliverToBoxAdapter(),
                _OrderHandle()
              ],
            )));
  }
}

