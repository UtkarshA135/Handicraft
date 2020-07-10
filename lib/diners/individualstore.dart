import 'package:cottage_app/diners/storeListingCategoryView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'rating.dart';
import 'package:cottage_app/diners/storeDetailsbloc.dart';
import 'package:cottage_app/diners/storeComponents/store.dart';

class MyStorePage extends StatefulWidget {
  final Store store;
  MyStorePage({Key key, this.store}) : super(key: key);

  @override
  _MyStorePageState createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Address storeaddress = new Address();
  @override
  void initState() {
    super.initState();
    _getAddress(widget.store.location);
  }

  _getAddress(List<dynamic> coordinates) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(coordinates[0], coordinates[1]));
    var firstresult = addresses.first;
    setState(() {
      storeaddress = firstresult;
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    void showRatingPanel(){ showModalBottomSheet(context: context, builder: (context){
        return Container(
         // padding : EdgeInsets.symmetric(vertical : 20.0 , horizontal : 60.0),
          child: StarFeedback(),

        );
    }
    );

    }
    print(widget.store);
    return ChangeNotifierProvider(
      create: (context) => MyStorePageBLoc(widget.store),
      child: Consumer<MyStorePageBLoc>(builder: (context, logic, child) {
        return logic.showLoading
            ? Hero(
                tag: '${widget.store.id}',
                child: Scaffold(
                  key: _scaffoldKey,
                  body: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ))
            : Hero(
                tag: '${widget.store.id}',
                child: Scaffold(
                    body: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      title: Text(
                        logic.store.name ?? "Store Name",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () =>
                                _launchURL("tel:${widget.store.contact}")),
                                IconButton(icon: Icon(Icons.star_border),
                                onPressed: () => showRatingPanel(),)
                      ],
                      iconTheme: IconThemeData(
                        color: Colors.black87,
                      ),
                      automaticallyImplyLeading: false,
                    ),
                    SliverList(
                      delegate: new SliverChildListDelegate([
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                          child: ListTile(
                            title: Text(
                              storeaddress.addressLine ?? 'Fetching Address...',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w200),
                              textAlign: TextAlign.center,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.location_on,semanticLabel: 'Show store on Map',size:35,color: Colors.grey[800],),
                              onPressed: () => _launchURL(
                                  'https://www.google.com/maps/search/?api=1&query=${widget.store.location[0]},${widget.store.location[1]}'),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                          child: Text(
                            widget.store.description,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w200),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(),
                      ]),
                    ),
                    buyerCategoryComponent(
                      categoryID: 1,
                      heading: 'Embroidery',
                      storeID: widget.store.id,
                      scaffoldkey: _scaffoldKey,
                    ),
                    buyerCategoryComponent(
                      categoryID: 2,
                      heading: 'Woodwork',
                      storeID: widget.store.id,
                      scaffoldkey: _scaffoldKey,
                    ),
                    buyerCategoryComponent(
                      categoryID: 3,
                      heading: 'Pottery',
                      storeID: widget.store.id,
                      scaffoldkey: _scaffoldKey,
                    ),
                    buyerCategoryComponent(
                      categoryID: 4,
                      heading: 'Ceramic',
                      storeID: widget.store.id,
                      scaffoldkey: _scaffoldKey,
                    ),
                    buyerCategoryComponent(
                      categoryID: 5,
                      heading: 'Terracotta',
                      storeID: widget.store.id,
                      scaffoldkey: _scaffoldKey,
                    ),
                    buyerCategoryComponent(
                      categoryID: 6,
                      heading: 'Weaving and Spinning',
                      storeID: widget.store.id,
                      scaffoldkey: _scaffoldKey,
                    ),
                    
                    
                  ],
                  
                )));
      }),
    );
  }
}
