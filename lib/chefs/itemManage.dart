import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cottage_app/models/itemListingModel.dart';
import 'itemcategory.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class ItemManagePage extends StatefulWidget {
  // ItemManagePage(});

  @override
  _ItemManagePageState createState() => _ItemManagePageState();
}

class _ItemManagePageState extends State<ItemManagePage> {
  //create var for availablevegetables
  Stream<QuerySnapshot> availableItemsStream;

  List<ItemListingModel> availableItems = new List();
  String storeId;
  @override
  void initState() {
    super.initState();
    this.storeId =
        Provider.of<SellerDetailsProvider>(context, listen: false).store.id;
    this.availableItemsStream =
        Provider.of<SellerDetailsProvider>(context, listen: false)
            .availableItemStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
     // backgroundColour :
      title : Text("Set Your Product Card",
    style: TextStyle(
      fontFamily: "Lobster"
    ),
    
    ),
    
    centerTitle: true,
     backgroundColor: Colors.blue[800],),
    body :
     CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        CategoryComponent(
          categoryID: 1,
          categoryName: 'Embroidery',
        ),
        CategoryComponent(
          categoryID: 2,
          categoryName: 'Woodwork',
        ),
        CategoryComponent(
          categoryID: 3,
          categoryName: 'Pottery',
        ),
        CategoryComponent(
          categoryID: 4,
          categoryName: 'Ceramic',
        ),
        CategoryComponent(
          categoryID: 5,
          categoryName: 'Terracotta',
        ),
        CategoryComponent(
          categoryID: 6,
          categoryName: 'Weaving and Spinning',
        ),
      ],
     ) );
  }
}