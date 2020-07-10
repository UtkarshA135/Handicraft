import 'package:cottage_app/models/orderData.dart';
import 'package:cottage_app/chefs/individualOrdersPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cottage_app/chefs/perorder.dart';
class OrderCard extends StatelessWidget {
  final OrderData order;
  final double dist;
  final bool isSeller;
  final String orderid;
  final FirebaseUser user;
  OrderCard(
      {this.order,
      this.dist = 0.0,
      this.isSeller = true,
      this.orderid = '0',
      this.user});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: (isSeller)
            ? '${order.buyerName}${order.userLocation[0]}${order.userLocation[1]}${order.timeoforder}'
            : '${orderid}',
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: ListTile(
                  title: Text(
                    (isSeller) ? order.buyerName : order.storeName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text((isSeller)
                      ? "${dist / 1000} km away  \n${order.items.length} items requested\n"
                      : "${order.items.length} items requested\n${order.isDelivered ? 'Delivered' : 'Not yet Delivered'}"),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      isSeller ? Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => PerOrder(
                                    orderData: order,
                                    distance: dist,
                                    isSeller: isSeller,
                                    user: user,
                                    orderid: orderid,
                                  ))):

                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => IndividualOrderPage(
                                    orderData: order,
                                    distance: dist,
                                    isSeller: isSeller,
                                    user: user,
                                    orderid: orderid,
                                  )));
                    },
                  ),
                  isThreeLine: true,
                  onTap: () {
                    isSeller ?  Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => PerOrder(
                                    orderData: order,
                                    distance: dist,
                                    isSeller: isSeller,
                                    user: user,
                                    orderid: orderid,
                                  ))):
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => IndividualOrderPage(
                                  orderData: order,
                                  distance: dist,
                                  isSeller: isSeller,
                                  user: user,
                                  orderid: orderid,
                                )));
                  },
                ))));
  }
}
