import 'package:flutter/material.dart';
import 'package:cottage_app/diners/cart/orderPlaced.dart';
import 'package:upi_india/upi_india.dart';





class Payments extends StatefulWidget {
  String upi ;
  String amt;
  Payments({this.upi,this.amt});
  @override
  _PaymentsState createState() => _PaymentsState(upiid: upi,amount: amt);
}

class _PaymentsState extends State<Payments> {
  String upiid;
  String amount;
  _PaymentsState( {this.upiid,this.amount});
  Future<UpiResponse> _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;
   
  @override
  void initState() {
    print(upiid);
    print(amount);
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(String app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: upiid,
      receiverName: 'Md Azharuddin',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: double.parse(amount),
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(child: Text("No apps found to handle transaction."));
    else
      return Center(
        child: Wrap(
          children: apps.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                _transaction = initiateTransaction(app.app);
                setState(() {});
              },
              child: Container(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 60,
                      width: 60,
                    ),
                    Text(app.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          displayUpiApps(),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: _transaction,
              builder: (BuildContext context,
                  AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('An Unknown error has occured'));
                  }
                  UpiResponse _upiResponse;
                  _upiResponse = snapshot.data;
                  if (_upiResponse.error != null) {
                    String text = '';
                    switch (snapshot.data.error) {
                      case UpiError.APP_NOT_INSTALLED:
                        text = "Requested app not installed on device";
                        break;
                      case UpiError.INVALID_PARAMETERS:
                        text = "Requested app cannot handle the transaction";
                        break;
                      case UpiError.NULL_RESPONSE:
                        text = "requested app didn't returned any response";
                        break;
                      case UpiError.USER_CANCELLED:
                        text = "You cancelled the transaction";
                        break;
                    }
                    return Center(
                      child: Text(text),
                    );
                  }
                  String txnId = _upiResponse.transactionId;
                  String resCode = _upiResponse.responseCode;
                  String txnRef = _upiResponse.transactionRefId;
                  String status = _upiResponse.status;
                  String approvalRef = _upiResponse.approvalRefNo;
                  switch (status) {
                    case UpiPaymentStatus.SUCCESS:
                      print('Transaction Successful');
                    Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => OrderPlacedPage()));
                      break;
                    case UpiPaymentStatus.SUBMITTED:
                      print('Transaction Submitted');
                      break;
                    case UpiPaymentStatus.FAILURE:
                      print('Transaction Failed');
                      Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => OrderPlacedPage()));
                      break;
                    default:
                      print('Received an Unknown transaction status');
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Transaction Id: $txnId\n'),
                      Text('Response Code: $resCode\n'),
                      Text('Reference Id: $txnRef\n'),
                      Text('Status: $status\n'),
                      Text('Approval No: $approvalRef'),
                    ],
                  );
                } else
                  return Text(' ');
              },
            ),
          )
        ],
      ),
    );
  }
}