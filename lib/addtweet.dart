import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/utils/variables.dart';

class AddTweet extends StatefulWidget {
  @override
  _AddTweetState createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {
  File imagepath;
  TextEditingController tweetcontroller = TextEditingController();
  bool uploading = false;

  pickImage(ImageSource imgsource) async {
    final image = await ImagePicker().getImage(source: imgsource);
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
            children: [
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text(
                  "Image from gallery",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.camera),
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
    StorageUploadTask storageUploadTask =
        tweetpictures.child(id).putFile(imagepath);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  posttweet() async {
    setState(() {
      uploading = true;
    });
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get();
    var alldocuments = await tweetcollection.get();
    int length = alldocuments.docs.length;
    // 3 conditions
    // only tweet
    if (tweetcontroller.text != '' && imagepath == null) {
      tweetcollection.doc('Tweet $length').set({
        'username': userdoc.data()['username'],
        'profilepic': userdoc.data()['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'tweet': tweetcontroller.text,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 1
      });
      Navigator.pop(context);
    }
    // only image
    if (tweetcontroller.text == '' && imagepath != null) {
      String imageurl = await uploadimage('Tweet $length');
      tweetcollection.doc('Tweet $length').set({
        'username': userdoc.data()['username'],
        'profilepic': userdoc.data()['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'image': imageurl,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 2
      });
      Navigator.pop(context);
    }

    // tweet and image
    if (tweetcontroller.text != '' && imagepath != null) {
      String imageurl = await uploadimage('Tweet $length');
      tweetcollection.doc('Tweet $length').set({
        'username': userdoc.data()['username'],
        'profilepic': userdoc.data()['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'tweet': tweetcontroller.text,
        'image': imageurl,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 3
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => posttweet(),
          child: Icon(
            Icons.publish,
            size: 32,
          )),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 32),
        ),
        centerTitle: true,
        title: Text(
          "Add Tweet",
          style: mystyle(20),
        ),
        actions: [
          InkWell(
            onTap: () => optionsdialog(),
            child: Icon(
              Icons.photo,
              size: 40,
            ),
          )
        ],
      ),
      body: uploading == false
          ? Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: tweetcontroller,
                    maxLines: null,
                    style: mystyle(20),
                    decoration: InputDecoration(
                        labelText: "What's happening now",
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
            )
          : Center(
              child: Text(
                "Uploading....",
                style: mystyle(25),
              ),
            ),
    );
  }
}
