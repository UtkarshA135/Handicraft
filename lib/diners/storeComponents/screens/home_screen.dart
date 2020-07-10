import 'package:flutter/material.dart';


import 'package:cottage_app/diners/storeComponents/widgets/recent_chat.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
         
          title: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              'Chats',
              style: TextStyle(
                fontSize: 22.0,
                
                
              ),
              textAlign: TextAlign.center,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            
            Expanded(
              child: Container(
              
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                   
                    RecentChats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}