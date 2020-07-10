import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cottage_app/chefs/itemDisplayTable.dart';
import 'package:cottage_app/models/itemListingModel.dart';
//import 'package:maps/chefs/itemSelector.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';

import 'itemSelectionTile.dart';

class CategoryComponent extends StatefulWidget {
  final String categoryName;
  final int categoryID;
  CategoryComponent({Key key, this.categoryID = 1, this.categoryName})
      : super(key: key);

  @override
  _CategoryComponentState createState() => _CategoryComponentState(
      categoryID: categoryID, categoryName: categoryName);
}

class _CategoryComponentState extends State<CategoryComponent> {
  final String categoryName;
  final int categoryID;
  _CategoryComponentState({this.categoryID, this.categoryName});

  @override
  Stream<QuerySnapshot> availableItemsStream;

  List<ItemListingModel> availableItems = new List();
  String storeId;
  String collectionName;

  @override
  void initState() {
    super.initState();
    this.storeId =
        Provider.of<SellerDetailsProvider>(context, listen: false).store.id;
setState(() {
this.collectionName=Provider.of<SellerDetailsProvider>(context,listen: false).getCollectionNameFromCategory(category: categoryID);

    //pass param here
   
  
});
  }

  heading(String heading, {int fsize = 18}) =>
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            child: ListTile(
              onTap: () async {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ItemCatalogSelectionTile(
                              categoryId: categoryID,
                            )));
              },
              trailing: Icon(Icons.edit),
              title: Text(
                "${heading}",
                style:
                    TextStyle(fontFamily: 'Archia', fontSize: fsize.toDouble(),
                    fontWeight: FontWeight.bold
                    )

                    ,
              ),
            ),
          ),
        
      );

  @override
  Widget build(BuildContext context) {
    return 
    SliverList(
      delegate: SliverChildListDelegate([

heading('${categoryName}'),
 
    StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('stores').document(this.storeId).collection('${collectionName}').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docs = snapshot.data.documents;
            this.availableItems =
                docs.map((doc) => ItemListingModel.fromJson(doc.data)).toList();
            // print(this.availableItems);
            if (availableItems.length == 0)
                return ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text('No ${categoryName} added to your store',style: TextStyle(color: Colors.grey,
                   fontWeight: FontWeight.bold),),
                );
            return ItemsListTable(
              itemListings: this.availableItems,
            );
          } else {
            return CupertinoActivityIndicator();
          }
        }),
      ]),

    );
   
  }
}
