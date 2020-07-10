import 'package:cottage_app/models/itemBuying.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cottage_app/models/itemListingModel.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';

class buyerCategoryComponent extends StatefulWidget {
  final String storeID;
  final int categoryID;
  var scaffoldkey;
  final String heading;
  buyerCategoryComponent({
    Key key,
    this.categoryID = 1,
    this.storeID,
    this.scaffoldkey,
    this.heading,
  }) : super(key: key);

  @override
  _buyerCategoryComponentState createState() =>
      _buyerCategoryComponentState(categoryID: categoryID, storeID: storeID);
}

class _buyerCategoryComponentState extends State<buyerCategoryComponent> {
  final String storeID;
  final int categoryID;
  _buyerCategoryComponentState({this.categoryID, this.storeID});

  @override
  Stream<QuerySnapshot> availableItemsStream;

  List<ItemListingModel> availableItems = new List();

  String collectionName;

  @override
  void initState() {
    super.initState();

    setState(() {
      this.collectionName =
          Provider.of<SellerDetailsProvider>(context, listen: false)
              .getCollectionNameFromCategory(category: categoryID);

      //pass param here
    });
  }

  heading(String heading, {int fsize = 18}) => Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: ListTile(
            title: Text(
              "${heading}",
              style:
                  TextStyle(fontFamily: 'Archia', fontSize: fsize.toDouble()),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      heading('${widget.heading}'),
      StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("stores")
              .document(storeID)
              .collection('$collectionName')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CupertinoActivityIndicator());
            else {
              final List<ItemListingModel> itemListing = snapshot.data.documents
                  .map((doc) =>
                      ItemListingModel(doc.data['price'], doc.data['itemName'],doc.data['url']))
                  .toList();
              if (itemListing.length == 0)
                return ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text('No ${widget.heading} listed in the store',style: TextStyle(color: Colors.grey),),
                );
              return ItemBuyTable(
                scaffoldKey: this.widget.scaffoldkey,
                itemListings: itemListing,
              );
            }
          })
    ]));
  }
}
