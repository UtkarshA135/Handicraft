import 'package:cottage_app/diners/storeComponents/store.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:cottage_app/diners/individualstore.dart';
class StoreCard extends StatelessWidget {
  final Store store;
  StoreCard({this.store});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return
  /* Hero(tag: '${store.id}',child: Padding(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2)
      ,child:
    Card(
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))
      ,
      child:
   Padding(
    padding: EdgeInsets.all(16.0),
    child: Card(
      child: Row(
        children: <Widget>[
          Container(
            child: InkWell(
              onTap: () {
                 Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => MyStorePage(
                      store: store,
                    )));
              },
            ),
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
        store.picUrl ??
            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Store_Building_Flat_Icon_Vector.svg/768px-Store_Building_Flat_Icon_Vector.svg.png",
        
      ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0)),
          ),
          SizedBox(width: 10.0),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                store.name,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                store.description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
                SizedBox(height: 5.0),
              Text((this.store.distance>1000?'${this.store.distance/1000} Km':'${this.store.distance} meters')??'...',
              
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              )

            ],
          )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Open",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Ratings: 4",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ))));*/
    SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        // color: Colors.blueAccent,
        height: 160,
        child: InkWell(
          onTap: () {
                 Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => MyStorePage(
                      store: store,
                    )));
              },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              // Those are our background
              Container(
                height: 136,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: true? kBlueColor : kSecondaryColor,
                  boxShadow: [kDefaultShadow],
                ),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
              // our product image
              Positioned(
                //top: 0,
                right: 0,
                bottom: 0,
                child: Hero(
                  tag: '${store.id}',
                  child: Container(
                   padding: EdgeInsets.fromLTRB(16,20,16,16),
                    height: 150,
                    // image is square but we add extra 20 + 20 padding thats why width is 200
                    width: 150,
                    child:  
     CircleAvatar(backgroundImage:AssetImage("assets/jute.jpg",
     
      ),
      radius:10
      )
                     
                      ),
                  ),
                ),
              
              // Product title and price
              Positioned(
                bottom: 7,
                left: 0,
                child: SizedBox(
                  height: 136,
                  // our image take 200 width, thats why we set out total width - 200
                  width: size.width - 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                            store.name,
                          style:TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            fontFamily: "Lobster"
                          ),
                          
                        ),
                      ),
                        Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                            store.description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold),
                          ),
                      ),
                      // it use the available space
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 1.5, // 30 padding
                          vertical: kDefaultPadding / 4, // 5 top and bottom
                        ),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                        ),
                        child: Text(
                          (this.store.distance>1000?'${this.store.distance/1000} Km':'${this.store.distance} meters')??'...',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
