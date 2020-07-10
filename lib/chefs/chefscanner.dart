import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellerQRScan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<SellerQRScan> {
  String barcode = "";
  bool scanStatus;

  @override
  initState() {
    super.initState();
    setState(() {
     this.scanStatus=false; 
    });
  }

  
  _completeOrder(String url) async {
    var response = await http.get(url);

    print(response.statusCode);
    if(response.statusCode==200){
      Navigator.pop(context);
      Fluttertoast.showToast(
                msg: "ORDER SUCCESSFULLY COMPLETED",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                fontSize: 16.0);

    }
    else{
      Fluttertoast.showToast(
                msg: "Try again later",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                fontSize: 16.0);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'delconfirm',
        child: Scaffold(
            appBar: new AppBar(
              title: Text(
                "Delivery Confirmation",
                style: TextStyle(
                    fontFamily: 'Archia', fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.lightGreen[400],
              elevation: 0.0,
            ),
            body: new SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      'Once you\'ve delivered the goods to your customer and collected payment, ask the Customer to display the QR Code from his Local Kitchen App and scan to complete the order and confirm delivery.',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/chefs.jpg',
                    cacheHeight: 500,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: RaisedButton(
                        color: (scanStatus)?Colors.blue:Colors.green,
                        textColor: Colors.white,
                        splashColor: Colors.redAccent,
                        onPressed: scan,
                         shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        child:
                           (scanStatus)?Text('Scan Code Again'):Text('Scan Confirmation Code from Customer')),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      barcode,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  (scanStatus)?Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child:  RaisedButton.icon(
                          label: Text(
                            'Submit Order Confirmation',
                            style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                          icon: Icon(Icons.check_circle_outline,color: Colors.white),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                           _completeOrder(barcode);
                          },
                        ),
                      
                  ):Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      barcode,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )));
  }

  Future scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() => {
        this.barcode = barcode.rawContent,
        this.scanStatus= (barcode.type.name=='Barcode')?true:false,
        });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode =
              'Grant CAMERA permissions to Kirana Seva when prompted';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
