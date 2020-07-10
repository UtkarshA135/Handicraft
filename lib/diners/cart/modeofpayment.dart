import "package:cottage_app/diners/cart/orderPlaced.dart";
import 'package:flutter/material.dart';
import 'package:cottage_app/models/payments.dart';

class ModeOfPayment extends StatefulWidget {
  @override
  _ModeOfPaymentState createState() => _ModeOfPaymentState();
}
String upiid =" ";
  String amount = " ";
class _ModeOfPaymentState extends State<ModeOfPayment> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red[800],
        title: Center(child: Text('MODE OF PAYMENT')),
      ),
      body: SingleChildScrollView(
                child: Column(
          children: <Widget>[
              field(),
              field1(),
              view1(),
              view(context),
       
          ],

        ),
      ),
    );
  }
}
Widget field(){
  return  Padding(
    padding: EdgeInsets.symmetric(horizontal:16.0,vertical:16.0),
      child:  TextField(
                   onChanged: (val){
                      upiid = val;
                   },
              decoration: InputDecoration( labelText: "UPI ID",
                                
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                     focusedBorder: OutlineInputBorder(),
                                     ),
              ),
            
  );
}            
Widget view1(){
  return Padding(
     padding: EdgeInsets.symmetric(horizontal:16.0,vertical:20.0),
     child: Text('PAY USING'),
  );
}                
    
    Widget field1(){
  return  Padding(
    padding: EdgeInsets.symmetric(horizontal:16.0,vertical:16.0),
      child:  TextField(
         onChanged: (val){
                      amount = val;
                   },
              decoration: InputDecoration( labelText: "Amount",
            
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                     focusedBorder: OutlineInputBorder(),
                                     ),
              ),
            
  );
}                            
Widget view(BuildContext context){
 
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal:16.0,vertical:80.0
    ),
    child: Container(
          height: 200.0,
          width: 500.0,
         
          child: GridView.count(

        crossAxisCount: 2,
        children: <Widget>[
          box(context),
          box1(context),
        ],
      ),
    ),
  );

}
Widget box(BuildContext context){
  return GestureDetector(
    onTap: (){
         Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Payments(upi:upiid, amt: amount,)));

    },
    child:
   Container(
     height :200.0,
     child:
     Card(

          
              elevation: 10.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: <Widget>[
                SizedBox(height: 20.0,),
                   Image(image: AssetImage('assets/pay.png'),height: 70.0,width: 90.0,fit: BoxFit.cover,),
                      SizedBox(height: 10.0,),
                    Center(
                                          child: Text('UPI',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      ),
                    ),
                ],
               
                
              )
     )   ));
}
Widget box1(BuildContext context){
  return    GestureDetector(
    onTap: (){
       Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => OrderPlacedPage()));

    },
    child:
  Container (
    height :200.0,
    child :Card(
              
              elevation: 10.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
               child: Column(
                children: <Widget>[
                SizedBox(height: 20.0,),
                   Image(image: AssetImage('assets/cod.png'),height: 70.0,width: 90.0,fit: BoxFit.cover,),
                      SizedBox(height: 10.0,),
                    Center(
                                          child: Text(' CASH ON DELIVERY',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      ),
                    ),
                ],
               
                
              )
   )) );
}