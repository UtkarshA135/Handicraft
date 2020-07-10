import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cottage_app/diners/cart/orderPlaced.dart';
import 'package:cottage_app/services/authservice.dart';
import 'package:cottage_app/services/firebaseUserProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modeofpayment.dart';
import 'cartcard.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
   final AuthService _auth = AuthService();
  List<dynamic> cartItems = new List();
  FirebaseUser user;
  CollectionReference cartRef;
  @override
  void initState() {
    
    setState(() {
      this.user =
          Provider.of<FirebaseUserProvider>(context, listen: false).user;
    });

    super.initState();
    
  }

  CollectionReference getCartStream() {
  //  this.user = Provider.of<FirebaseUserProvider>(context, listen: false).user;
    return Firestore.instance
        .collection('diners')
        .document('${this.user.uid}')
        .collection('cart');
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'cartpage',
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Your Cart',
              style: TextStyle(color: Colors.black,
               fontWeight: FontWeight.bold,
           fontSize: 21.0,

              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Place Order',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => ModeOfPayment()));

                },
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 1.0,
          ),
          body: Builder(
            builder: (context) {
              CollectionReference ref = getCartStream();

              return StreamBuilder<QuerySnapshot>(
                  stream: ref.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.documents.length == 0) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 25),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    size: 70,
                                    color: Colors.grey,
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 10),
                                child: Text(
                                  'You have not added any items to cart',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]);
                      } else {
                        return  ListView.builder(
                          shrinkWrap: true,
                          //scrollDirection: Axis.horizontal ,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index > snapshot.data.documents.length)
                              return null;

                            return CartCard(
                              cartDetails: snapshot.data.documents[index],
                            );
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                      }
                    } else
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 70,
                                  color: Colors.grey,
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 10),
                              child: Text(
                                'Fetching the items in your cart',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]);
                  });
            },
          ),
          
        )
        
        );
  }
}/*
import 'package:flutter/material.dart';



class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[800],
          title:Center( 
            child:Text("Your Food Cart",style: TextStyle(color: Colors.black),),
            ),
        ),
      body: ListView(
        
        padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 20.0),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          OrderCard(),
          OrderCard(),
        ],
      ),
      bottomNavigationBar: _buildTotalContainer(),
   
    );
  }

  Widget   _buildTotalContainer() {
    return Container(
      height: 220.0,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Subtotal",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "23.0",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Discount",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "10.0",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tax",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "0.5",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Cart Total",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "26.5",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.red[900],   Colors.red[800],   Colors.red[700],   Colors.red[600],   Colors.red,   Colors.red[400],
                ],
                begin: Alignment.centerRight,
                end: Alignment(-1, -1)
                ),
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Center(
                child: Text(
                  "Proceed To Checkout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
class OrderCard extends StatefulWidget {
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 45.0,
              height: 73.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    InkWell(
                        onTap: () {},
                        child: Icon(Icons.keyboard_arrow_up,
                            color: Color(0xFFD3D3D3))),
                    Text(
                      "0",
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () {},
                        child: Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFD3D3D3))),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/foodie.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 2.0))
                  ]),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Pasta",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  "\u023B 3.0",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 25.0,
                  width: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Non-Veg",
                              style: TextStyle(
                                  color: Color(0xFFD3D3D3),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "x",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/