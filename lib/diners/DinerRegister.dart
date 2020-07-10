import 'package:flutter/cupertino.dart';
import 'package:cottage_app/diners/dinerHomepage.dart';
import 'package:cottage_app/diners/dinerinfo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BuyerRegisterPage extends StatefulWidget {
  BuyerRegisterPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _BuyerRegisterPageState createState() => _BuyerRegisterPageState();
}

class _BuyerRegisterPageState extends State<BuyerRegisterPage> {
  bool isLoading = false;
  bool showLoading = true;
  TextEditingController _namecontroller;
  TextEditingController _phoneNocontroller;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkuserExists();
    this._namecontroller = new TextEditingController();
    this._phoneNocontroller = new TextEditingController();
  }

  checkuserExists() async {
    isUserExist().then((userExists) {
      if (userExists) {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => 
             DinerHomePage()));
      } else {
        print("first time login");
        setState(() {
          showLoading = false;
        });
      }
    });
  }

  onPressRegister() {
    if (!_formKey.currentState.validate()) {
    } else {
      setState(() {
        this.isLoading = true;
      });
      registerBuyer(
              _namecontroller?.text ?? "1",
              _phoneNocontroller?.text ??"2"
              )
          .then((statusCode) {
        setState(() {
          this.isLoading = false;
        });
        switch (statusCode) {
          case 1:
            print('registered');
            Fluttertoast.showToast(
                msg: "Registered",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                fontSize: 16.0); 
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => DinerHomePage()));
            break;
          case 2:
            print('check your internet connection');
            Fluttertoast.showToast(
                msg: "Check your Internet Connection",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          case 3:
            print('please try again later');
            Fluttertoast.showToast(
                msg: "Please try again later",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
        }
      });
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {TextEditingController controllervar}) {
    return  Padding(
                padding: EdgeInsets.symmetric(vertical:6.0,horizontal:16.0),
                child :Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please fill in this field';
                }
                return null;
              },
              // obscureText: isPassword,
              controller: controllervar,
              decoration: InputDecoration(
                 labelText: title,
                  fillColor: Colors.white,
                                    filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:BorderSide(color: Colors.grey[900],),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                     focusedBorder: OutlineInputBorder(),)
                ),
        ],
      ),
      )  );
  }

  Widget _submitButton() {
    return   /*Padding(padding: EdgeInsets.symmetric(vertical:8.0,horizontal:50.0),child :
    MaterialButton(
    
        minWidth: 50.0,
  
                              height: 60.0,
  
                              highlightColor: Colors.amberAccent[700],
  
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  
                              color: Colors.amberAccent[700],
  
      onPressed: onPressRegister,
      child:
        isLoading
            ? CupertinoActivityIndicator()
            : Text(
                'Register Now',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
      
     ) );*/
     Padding(
              padding: const EdgeInsets.symmetric(vertical: 59),
              child: MaterialButton(onPressed: onPressRegister,
              
              color: Colors.cyan[900],
              height: 50.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              minWidth: double.infinity,
              child:   isLoading
            ? CupertinoActivityIndicator()
            : Text(
                'Register Now',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              ));
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }


  Widget _formfieldswidgets() {
    return Column(
      children: <Widget>[
        _entryField("Name", controllervar: _namecontroller),
        _entryField("Phone Number", controllervar: _phoneNocontroller)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
    if (showLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else
      return 
       Scaffold(
        
      body: SingleChildScrollView(
              child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                painter: BackgroundSignIn(),
                child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Form(
              key: _formKey,
              child:Column(
            children: <Widget>[
            _getHeader(),
            _formfieldswidgets(),
            SizedBox(height: 10.0,),
           _submitButton()
            ],
            
          ),
                )
              ),
        ),
      ),
       ));
  }
}
_getHeader() {
  return Expanded(
    flex: 3,
    child: Container(
        alignment: Alignment.bottomLeft,
        child: Align(
          alignment: Alignment.center,
                  child: Text(
    'Register\nWith Us',
    style: TextStyle(color: Colors.black, fontSize: 40,
    fontFamily: "Lobster"),
    
          ),
        ),
      ),
  );
}
class BackgroundSignIn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.white;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.5);
    blueWave.quadraticBezierTo(sw * 0.5, sh * 0.45, sw * 0.2, 0);
    blueWave.close();
    paint.color = Colors.cyan[100];
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    greyWave.close();
    paint.color = Colors.cyan;
    canvas.drawPath(greyWave, paint);

    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.cyan[700];
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

