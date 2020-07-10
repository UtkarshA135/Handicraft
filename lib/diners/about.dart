import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';


class Credits extends StatefulWidget {
  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Center(child: Text('About us')),
      ),
      body: Column(children: <Widget>[
        view(),
      ],),

    );
  }
}
Widget view(){


  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal:16.0,vertical:80.0
    ),
    child: Container(
      height: 500.0,
      width: 500.0,

      child: GridView.count(
        mainAxisSpacing: 20.0,
        crossAxisCount: 2,
        children: <Widget>[
          box(),
          box1(),
          box2(),
          box3(),
        ],
      ),
    ),
  );

}
Widget box(){
  return Container(
    height: 30,
    child: Card(

        elevation: 10.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0,),
            CircleAvatar(     backgroundImage:   AssetImage("assets/Utkarsh.jpeg")     ),
            SizedBox(height :15.0),
            Text('Utkarsh Agarwal'),
            SizedBox(height: 10.0,),
            Center(
              child: IconButton( icon :Icon(Icons.link),
                onPressed: () => _launchURL1,


              ),
            ),
          ],


        )
    ),
  );
}
Widget box1(){
  return Container(
    height: 30,
    child: Card(

        elevation: 10.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0,),
            CircleAvatar(     backgroundImage:   AssetImage("assets/Anirudh.jpeg")     ),
            SizedBox(height :15.0),
            Text('Anirudh Tiwari'),
            SizedBox(height: 10.0,),
            Center(
              child: IconButton( icon :Icon(Icons.link),
                onPressed: () => _launchURL2,


              ),
            ),
          ],


        )
    ),
  );

}
Widget box3(){
  return Container(
    height: 30,
    child: Card(

        elevation: 10.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0,),
            CircleAvatar(     backgroundImage:   AssetImage("assets/shruti.jpeg")     ),
            SizedBox(height :15.0),
            Text('Shruti Buchha'),
            SizedBox(height: 10.0,),
            Center(
              child: IconButton( icon :Icon(Icons.link),
                onPressed: () => _launchURL3,


              ),
            ),
          ],


        )
    ),
  );
}

Widget box2(){
  return Container(
    height: 30,
    child: Card(

        elevation: 10.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0,),
            CircleAvatar(     backgroundImage:   AssetImage("assets/Shree.jpeg")     ),
            SizedBox(height :15.0),
            Text('Shree Ahuja'),
            SizedBox(height: 10.0,),
            Center(
              child: IconButton( icon :Icon(Icons.link),
                onPressed: () => _launchURL4,


              ),
            ),
          ],


        )
    ),
  );
}
_launchURL1() async {
  const url = 'https://www.linkedin.com/in/utkarsh-agarwal-654470191';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }}
_launchURL2() async {
  const url = 'https://www.linkedin.com/in/anirudh-tiwari-5a0ab7193';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }}
_launchURL3() async {
  const url = 'https://www.linkedin.com/mwlite/in/shruti-buchha-0168911ab';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }}
_launchURL4() async {
  const url = 'https://www.linkedin.com/in/shree-ahuja-a8115518b';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }}
