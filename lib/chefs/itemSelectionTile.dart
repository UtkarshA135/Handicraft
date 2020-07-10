import 'dart:io';

import 'package:cottage_app/chefs/full_screen_image.dart';
import 'package:cottage_app/models/itemListingModel.dart';
import 'package:cottage_app/services/chefsDetailProvider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ItemCatalogSelectionTile extends StatefulWidget {

  final String itemName;
  final bool isAdded;
  final double price;
  final int categoryId;
   ItemCatalogSelectionTile({
    Key key,
    this.itemName='Enter a dish',
    // @required this.refresh,
    this.isAdded=false,
    this.price=0.0,
    this.categoryId=1,
  }) : super(key: key);

  @override
  _ItemCatalogSelectionTileState createState() => _ItemCatalogSelectionTileState();
}

class _ItemCatalogSelectionTileState extends State<ItemCatalogSelectionTile> with AutomaticKeepAliveClientMixin{
  TextEditingController _priceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool isAdded;
  double price;
  String itemnName;
  String storeId;
  String collectionName;
  String url;
  File _image;
  List imgs;
  @override
  void initState() { 
    super.initState();
    this.isAdded = widget.isAdded;
    this.price = widget.price;
    this.itemnName =widget.itemName;
     this.storeId =
        Provider.of<SellerDetailsProvider>(context, listen: false).store.id;
setState(() {
this.collectionName=Provider.of<SellerDetailsProvider>(context,listen: false).getCollectionNameFromCategory(category: widget.categoryId);});
  }
_onImageButtonPressed(ImageSource source, {bool singleImage = true}) async {
    
    imgs = await MultiMediaPicker.pickImages(source: source, singleImage: singleImage);
    
    setState(() {
      _image = imgs[0];
    });}
 Future<String> upload() async {
final StorageReference postImgref = FirebaseStorage.instance.ref().child('Post Images');
var timeKey = new DateTime.now();
final StorageUploadTask uploadTask = postImgref.child(timeKey.toString()+'.jpg').putFile(_image);
var imgurl = await(await uploadTask.onComplete).ref.getDownloadURL();
url = imgurl.toString();
print(url);
  return url;
 
}

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    
/* Future  getImage() async {
 // ignore: deprecated_member_use
  try {
          final pickedFile = await _picker.getImage(
            source: ImageSource.gallery,
            
          );
          setState(() {
            _image = File(pickedFile.path);
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }*/
      
 

    return Scaffold(
      appBar : AppBar(title : Text("Add CraftsWork ",),
      centerTitle: true,backgroundColor: Colors.blue[800],
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue[800],
        child:  Icon( Icons.add),
        onPressed:(){ showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: AlertDialog(

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Text('Enter your Handicraft Product'),
              content: ListView(children: <Widget>[
               GestureDetector(child: CircleAvatar(backgroundImage: url!=null?NetworkImage(url):AssetImage("assets/bamboo.jpg"),
               radius: 100,),
               onTap:()  {    _onImageButtonPressed(ImageSource.gallery);}
               ),
               SizedBox(height:5.0),
                 
                 TextField(

                controller: _nameController,
                decoration: InputDecoration(hintText: "Enter product name"),
                 ),
                TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                controller: _priceController,
                decoration: InputDecoration(hintText: "\u20B9 100.00"),
              ),]),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {

                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Add Item to Store',style: TextStyle(color: Colors.green),),
                  onPressed: () async {
                    double price = _priceController.text==""?0.0 : double.parse(_priceController.text);
                    String itemName = _nameController.text == null?"Enter a dish":_nameController.text;
                    String picurl = await upload();
                   // url!=null?url:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU";
                    // url!=null?url:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU";
                    Provider.of<SellerDetailsProvider>(context,listen: false).addToAvailableItems(itemListingModel:  ItemListingModel(price, itemName,picurl),category: widget.categoryId);
                    setState(() {
                      this.isAdded=true;
                      this.itemnName = itemName;
                    this.price =price;
                    this.url =url;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });}),
    body :   StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('stores').document(this.storeId).collection('${collectionName}').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
             return
             snapshot.data.documents.length !=0?
             Dismissible(
               onDismissed: (direction){
 Provider.of<SellerDetailsProvider>(context,listen: false).removeAvailableItem(itemListingModel:  ItemListingModel(documentSnapshot['price'], documentSnapshot['itemName'],documentSnapshot['url']),category: widget.categoryId);
        setState(() {
          this.isAdded=false;
          this.price =0.0;
          this.itemnName ='Enter a Dish';
          this.url = null;
        });
               },
               key: Key(documentSnapshot.data['itemName']),
               child: 
              Card(
                elevation :4.0,
                margin : EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius : BorderRadius.circular(8)
                ),
   child:
              
     ListTile(
       leading: CircleAvatar(
            child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: documentSnapshot['url'],)));
                            }),),
         backgroundImage:documentSnapshot['url']!=null? NetworkImage(documentSnapshot['url']):AssetImage("assets/bamboo.jpg"),
         radius: 30.0,
       ),
      title:
      Text(documentSnapshot['itemName']),
      subtitle :Text('\u20B9 ${documentSnapshot['price']}'),
     
     
      trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
       
       Provider.of<SellerDetailsProvider>(context,listen: false).removeAvailableItem(itemListingModel:  ItemListingModel(documentSnapshot['price'], documentSnapshot['itemName'],documentSnapshot['url']),category: widget.categoryId);
        setState(() {
          this.isAdded=false;
          this.price =0.0;
          this.itemnName ='Enter a Dish';
          this.url = null;
        });
      },),
    )
    

    )):
        Center(
child: Text("Add Items"),
      
    );
    });
        }));
  }
  @override
 
  bool get wantKeepAlive => true;
}
