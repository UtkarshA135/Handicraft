import 'package:cottage_app/diners/DinerRegister.dart';
import 'package:cottage_app/chefs/SellersRegister.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userType;
  Future<void> saveUserType(String _userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Type', _userType);
  }

  Future<String> _getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userType = prefs.getString('User Type');
    print(_userType);
    if (_userType == null)
      return 'None';
    else
      return _userType;
  }

  void _alreadyChosen() {}

  @override
  void initState() {
    super.initState();

    _getUserType().then((_type) {
      setState(() {
        this.userType = _type;
      });
      print(_type);
      if (_type == 'Buyer')
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => BuyerRegisterPage()));
      else if (_type == 'Craftsman') {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => SellerRegisterPage()));
      }
    });

    //_alreadyChosen();
  }

  Container menuButton(String imageurl, String caption, Widget destination) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: FlatButton(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Hero(
                    tag: '$caption',
                    child: Image.asset(imageurl,
                        height: MediaQuery.of(context).size.height / 4.1),
                  ),
                ),
                onPressed: () async {
                  await saveUserType(caption);
                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (context) => destination));
                }),
          ),
          Text("Proceed as ${caption}"),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (userType != null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Center(
                        child: menuButton('assets/foodie.jpg', 'Buyer',
                            BuyerRegisterPage())),
                    Divider(),
                    Center(
                        child: menuButton('assets/chefs.jpg',
                            'Craftsman', SellerRegisterPage()
                            //SellerHomePage(),
                            )),
                  ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Center(
                        child: Image.asset('assets/logo.jpg')
                           )
                    
                  ]));
  }
}