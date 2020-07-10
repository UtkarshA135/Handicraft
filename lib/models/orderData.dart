import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  final String buyerContact;
  final String buyerName;
  final String sellerID;
  final String storeID;
  final String storeName;
  final List<dynamic> items;
  final List<dynamic> userLocation;
  final Timestamp timeoforder;
  final String sellerName;
  final String sellerContact;
  final List<dynamic> storeLocation;
  final bool isDelivered;
  OrderData(
  this.buyerContact,
  this.buyerName,
  this.sellerID,
  this.storeID,
  this.storeName,
  this.items,
  this.userLocation,
  this.timeoforder,
  this.sellerName,
  this.sellerContact,
  this.storeLocation,
  this.isDelivered,
  
  );

  factory OrderData.fromJson(dynamic json){
  return OrderData(
    
  json['buyerContact'],
  json['buyerName'],
  json['sellerID'],
  json['storeID'],
  json['storeName'],
  json['items'],
  json['location'],
  json['timestamp'],
  json['sellerName'],
  json['sellerPhno'],
  json['storeLocation'],
  json['isDelivered'],
  
  );
}
}

