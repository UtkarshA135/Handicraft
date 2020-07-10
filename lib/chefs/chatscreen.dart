import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';
import 'full_screen_image.dart';
import 'package:cottage_app/models/messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  String name;
  String photoUrl;
  String receiverUid;
  ChatScreen({this.name, this.photoUrl, this.receiverUid});
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 
  Message _message;
  var _formKey = GlobalKey<FormState>();
  var map = Map<String, dynamic>();
  CollectionReference _collectionReference;
  DocumentReference _receiverDocumentReference;
  DocumentReference _senderDocumentReference;
  DocumentReference _documentReference;
  DocumentSnapshot documentSnapshot;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _senderuid;
  var listItem;
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;
  StorageReference _storageReference;
  TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    
    _messageController = TextEditingController();
    getUID().then((user) {
      setState(() {
        _senderuid = user.uid;
        print("sender uid : $_senderuid");
        getSenderPhotoUrl(_senderuid).then((snapshot) {
          setState(() {
            senderPhotoUrl = snapshot['url'];
            senderName = snapshot['name'];
            print(senderPhotoUrl);
            print(  senderName );
          });
        });
        getReceiverPhotoUrl(widget.receiverUid).then((snapshot) {
          setState(() {
            receiverPhotoUrl = snapshot['url'];
            receiverName = snapshot['name'];
            print( receiverName );
            print(receiverPhotoUrl);
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void addMessageToDb(Message message) async {
    print("Message : ${message.message}");
    map = message.toMap();

    print("Map : ${map}");
    _collectionReference = Firestore.instance
        .collection("messages")
        .document(message.senderUid)
        .collection(widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = Firestore.instance
        .collection("messages")
        .document(widget.receiverUid)
        .collection(message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         // title: Text(widget.name),
             backgroundColor: Color(0xFF5AEAF1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
            color: Colors.black,
            ),
            onPressed: (){
              // print('back');
              Navigator.pop(context);
            },
          ),
          centerTitle: false,
          title: ListTile(
            contentPadding: EdgeInsets.only(left: 0.0),
             leading:
              CircleAvatar(
                // radius: 25.0,
               backgroundColor: Colors.black,
            backgroundImage: NetworkImage(widget.photoUrl),
              ),
         title: Text(widget.name,
            style: TextStyle(
              fontFamily: 'Lobster',
              color: Colors.black,
             // fontSize: ScreenUtil().setSp(70.0),
            ),
          ),

          )
        ),
        body: Form(
          key: _formKey,
          child: _senderuid == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    //buildListLayout(),
                    ChatMessagesListWidget(),
                    Divider(
                      height: 20.0,
                      color: Colors.black,
                    ),
                    ChatInputWidget(),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
        ));
  }

  Widget ChatInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.photo,
                color: Colors.black,
              ),
              onPressed: () {
                pickImage();
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              validator: (String input) {
                if (input.isEmpty) {
                  return "Please enter message";
                }
              },
              controller: _messageController,
              decoration: InputDecoration(
                  hintText: "Enter message...",
                  labelText: "Message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              onFieldSubmitted: (value) {
                _messageController.text = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  sendMessage();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String> pickImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = selectedImage;
    });
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print("URL: $url");
    uploadImageToDb(url);
    return url;
  }

  void uploadImageToDb(String downloadUrl) {
    _message = Message.withoutMessage(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    print("Map : $map");
    _collectionReference = Firestore.instance
        .collection("messages")
        .document(_message.senderUid)
        .collection(widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = Firestore.instance
        .collection("messages")
        .document(widget.receiverUid)
        .collection(_message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });
  }

  void sendMessage() async {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    _message = Message(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : ${_senderuid} , message: ${text}");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    addMessageToDb(_message);
  }

  Future<FirebaseUser> getUID() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<DocumentSnapshot> getSenderPhotoUrl(String uid) {
    var senderDocumentSnapshot =
        Firestore.instance.collection('users').document(uid).get();
    return senderDocumentSnapshot;
  }

  Future<DocumentSnapshot> getReceiverPhotoUrl(String uid) {
    var receiverDocumentSnapshot =
        Firestore.instance.collection('users').document(uid).get();
    return receiverDocumentSnapshot;
  }

  Widget ChatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(_senderuid)
            .collection(widget.receiverUid)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            listItem = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  chatMessageItem(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
    return buildChatLayout(documentSnapshot);
  }

  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid?
            MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              snapshot['senderUid'] == _senderuid
                ? Text('')
                  // ? CircleAvatar(
                  //     backgroundImage: senderPhotoUrl == null
                  //         ? AssetImage('assets/blankimage.png')
                  //         : NetworkImage(senderPhotoUrl),
                  //     radius: 20.0,
                  //   )
                  : CircleAvatar(
                      backgroundImage: receiverPhotoUrl == null
                          ? AssetImage('assets/chefs.jpg')
                          : NetworkImage(receiverPhotoUrl),
                      radius: 20.0,
                    ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // snapshot['senderUid'] == _senderuid
                  //     ? new Text(
                  //        senderName == null ? "" : senderName,
                  //         style: TextStyle(
                  //             color: Colors.black,
                  //            fontSize: 16.0,
                  //             fontWeight: FontWeight.bold),
                  //     )
                  //  : new Text(
                  //         receiverName == null ? "" : receiverName,
                  //          style: TextStyle(
                  //            color: Colors.black,
                  //             fontSize: 16.0,
                  //              fontWeight: FontWeight.bold),
                  //       ),
                   snapshot['type'] == 'text'
                  //      ? new Text(
                  //          snapshot['message'],
                  //         style: TextStyle(color: Colors.black, fontSize: 14.0),
                  //              overflow: TextOverflow.ellipsis,
                  //               maxLines: 8,
                  //       )
                  //     : InkWell(
                  //        onTap: (() {
                  //           Navigator.push(
                  //               context,
                  //               new MaterialPageRoute(
                  //                   builder: (context) => FullScreenImage(photoUrl: snapshot['photoUrl'],)));
                  //         }),
                  //         child: Hero(
                  //           tag: snapshot['photoUrl'],
                  //           child: FadeInImage(
                  //            image: NetworkImage(snapshot['photoUrl']),
                  //             placeholder: AssetImage('assets/images.png'),
                  //            width: 200.0,
                  //            height: 200.0,
                  //          ),
                  //        ),
                  //       ),
              
              ? Container(
                              width:MediaQuery.of(context).size.width*0.7,
                             child: Bubble(
                                margin: BubbleEdges.only(top: 10),
                                shadowColor: Colors.blue,
                                elevation: 2,
                                alignment: snapshot['senderUid'] == _senderuid? Alignment.topRight: Alignment.topLeft,
                                nip:snapshot['senderUid'] == _senderuid?  BubbleNip.rightTop: BubbleNip.leftTop,

                              child: Text(
                                 snapshot['message'],
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                               overflow: TextOverflow.ellipsis,
                                maxLines: 8,
                            ),
                        ),
                     )
                      : Bubble(
                        margin: BubbleEdges.only(top: 10.0),
                        // padding:BubbleEdges.all(0.0) ,
                                shadowColor: Colors.blue,
                                elevation: 2,
                                alignment: snapshot['senderUid'] == _senderuid? Alignment.topRight: Alignment.topLeft,
                                nip:snapshot['senderUid'] == _senderuid?  BubbleNip.rightTop: BubbleNip.leftTop,

                            child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: snapshot['photoUrl'],)));
                            }),
                            child: Hero(
                              tag: snapshot['photoUrl'],
                              child: FadeInImage(
                              image: NetworkImage(snapshot['photoUrl']),
                              
                               placeholder: AssetImage('assets/chefs.jpg'),
                               width: MediaQuery.of(context).size.width*0.4,
                                // height: 50.0,
                             ),),),
                             ),
                             
              // height: 50.0,
              
              // snapshot['senderUid'] == _senderuid 

              //     ? CircleAvatar(
              //       // backgroundImage: NetworkImage(senderPhotoUrl) ,
              //         backgroundImage: senderPhotoUrl == null
              //             ? AssetImage('assets/images.png')
              //             : NetworkImage(senderPhotoUrl),
              //         radius: 20.0,
              //       )
              //       : Text('') ,
              //     // :CircleAvatar(
              //     //     backgroundImage: 
              //     //     receiverPhotoUrl == null
              //     //         ? AssetImage('assets/blankimage.png'):
              //     //          NetworkImage(receiverPhotoUrl),
              //     //     radius: 20.0,
              //     //   ), 
                  
               ],
              )
            ],
          ),
        ),
      ],
    );
  }
}