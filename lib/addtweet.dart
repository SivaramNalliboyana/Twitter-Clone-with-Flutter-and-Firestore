import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTweet extends StatefulWidget {
  @override
  _AddTweetState createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {
  bool uploading = false;
  File imagepath;
  TextEditingController tweet = TextEditingController();

  pickimage(ImageSource source) async {
    final image = await ImagePicker().getImage(source: source);
    setState(() {
      imagepath = File(image.path);
    });
    Navigator.pop(context);
  }

  optionsdialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => pickimage(ImageSource.gallery),
                child: Text(
                  "Image from gallery",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickimage(ImageSource.camera),
                child: Text(
                  "Image from camera",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: mystyle(20),
                ),
              )
            ],
          );
        });
  }

  uploadimage(String id) async {
    StorageUploadTask storageUploadTask = pictures.child(id).putFile(imagepath);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  postweet() async {
    setState(() {
      uploading = true;
    });
    var tweetdocuments = await tweetcollection.getDocuments();
    int length = tweetdocuments.documents.length;
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userdocument =
        await usercollection.document(firebaseuser.uid).get();
    // 3 conditions
    // only tweet
    if (tweet.text != '' && imagepath == null) {
      tweetcollection.document('Tweet $length').setData({
        'username': userdocument['username'],
        'profilepic': userdocument['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'likes': [],
        'commentcount': 0,
        'tweet': tweet.text,
        'shares': 0,
        'type': 1
      });
      Navigator.pop(context);
    }
    // only picture
    if (tweet.text == '' && imagepath != null) {
      String downloadurl = await uploadimage('Tweet $length');
      tweetcollection.document('Tweet $length').setData({
        'username': userdocument['username'],
        'profilepic': userdocument['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'likes': [],
        'commentcount': 0,
        'picture': downloadurl,
        'shares': 0,
        'type': 2
      });
      Navigator.pop(context);
    }
    // tweet and picture
    if (tweet.text != '' && imagepath != null) {
      String downloadurl = await uploadimage('Tweet $length');
      tweetcollection.document('Tweet $length').setData({
        'username': userdocument['username'],
        'profilepic': userdocument['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'likes': [],
        'commentcount': 0,
        'picture': downloadurl,
        'shares': 0,
        'tweet': tweet.text,
        'type': 3
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => postweet(),
        child: Icon(
          Icons.publish,
          size: 40,
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 32),
        ),
        title: Text(
          "Add Tweet",
          style: mystyle(20),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () => optionsdialog(),
            child: Icon(
              Icons.photo,
              size: 40,
            ),
          )
        ],
      ),
      body: uploading == true
          ? Center(
              child: Text('Uploading...', style: mystyle(30)),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    maxLines: null,
                    controller: tweet,
                    style: mystyle(20),
                    decoration: InputDecoration(
                        labelText: "What is happening now?",
                        labelStyle: mystyle(25),
                        border: InputBorder.none),
                  ),
                ),
                imagepath == null
                    ? Container()
                    : MediaQuery.of(context).viewInsets.bottom > 0
                        ? Container()
                        : Image(
                            width: 200,
                            height: 200,
                            image: FileImage(imagepath),
                          )
              ],
            ),
    );
  }
}
