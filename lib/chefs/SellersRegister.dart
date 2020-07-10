import 'package:cottage_app/chefs/chefinfo.dart';
import 'package:cottage_app/chefs/chefHomepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SellerRegisterPage extends StatefulWidget {
  SellerRegisterPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SellerRegisterPageState createState() => _SellerRegisterPageState();
}

class _SellerRegisterPageState extends State<SellerRegisterPage> {
  bool isLoading = false;
  bool showLoading = true;
  TextEditingController _shopnamecontroller,
      _phonenumber1controller,
      _shopkeepernamecontroller,
      _phonenumber2controller,
      _shopDescriptionController = new TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkuserExists();
    this._shopkeepernamecontroller = new TextEditingController();
    this._phonenumber1controller = new TextEditingController();
    this._phonenumber2controller = new TextEditingController();
    this._shopnamecontroller = new TextEditingController();
    this._shopDescriptionController = new TextEditingController();
  }

  checkuserExists() async {
    isUserExist().then((userExists) {
      if (userExists) {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => ChefHomePage()));
      } else {
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
      registerSeller(
              _shopnamecontroller?.text ?? "1",
              _phonenumber1controller?.text ?? "2",
              _shopkeepernamecontroller?.text ?? "3",
              _phonenumber2controller?.text ?? "4",
              _shopDescriptionController?.text ?? "6")
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
                new MaterialPageRoute(builder: (context) => ChefHomePage()));
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

  Widget _entryField(String title, {TextEditingController controllervar}) {
    return 
    Padding(
                padding: EdgeInsets.symmetric(vertical:6.0,horizontal:16.0),
                child :Container(
      margin: EdgeInsets.symmetric(vertical: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        
         
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
                                     focusedBorder: OutlineInputBorder(),))
        ],
      ),
     ) );
  }

  Widget _submitButton() {
    return /*Padding(padding: EdgeInsets.symmetric(vertical:8.0,horizontal:50.0),child :
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
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: onPressRegister,
                        color: Colors.cyan[900],
                        height: 50.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minWidth: double.infinity,
                        child:     isLoading
            ? CupertinoActivityIndicator()
            : Text(
                'Register Now',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
                      ),
                    );
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
        _entryField("Shop name", controllervar: _shopnamecontroller),
        _entryField("Shop Description",
            controllervar: _shopDescriptionController),
        _entryField("Shopkeeper/Manager name",
            controllervar: _shopkeepernamecontroller),
        _entryField("Phone Number 1", controllervar: _phonenumber1controller),
        _entryField("Phone Number 2", controllervar: _phonenumber2controller),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
    Color dynamicbgcolor = (!isDarkMode) ? Colors.grey[200] : Colors.black;
    if (showLoading) {  return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else

      return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
              painter: BackgroundSignIn(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Form(
                  key :_formKey,
                  child:
                  Column(
                  children: <Widget>[
                    _getHeader(),
                    _formfieldswidgets(),
                    SizedBox(
                      height: 18.0,
                    ),
                  _submitButton(),
                  ],
                ),
              )),
        ),
      ),
       ) );
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
          style: TextStyle(color: Colors.black, fontSize: 40,fontFamily: "Lobster"),
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

