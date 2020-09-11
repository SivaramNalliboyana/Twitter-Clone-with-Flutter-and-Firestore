import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/comment.dart';
import 'package:twitter/utils/variables.dart';

class ViewUser extends StatefulWidget {
  final String uid;
  ViewUser(this.uid);
  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  String onlineuser;
  Stream userstream;
  String username;
  int following;
  int followers;
  String profilepic;
  bool isfollowing;
  bool dataisthere = false;
  initState() {
    super.initState();
    getcurrentuseruid();
    getstream();
    getcurrentuserinfo();
  }

  getcurrentuserinfo() async {
    print(widget.uid);
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userdoc =
        await usercollection.document(widget.uid.trim()).get();
    var followersdocuments = await usercollection
        .document(widget.uid)
        .collection('followers')
        .getDocuments();
    var followngdocuments = await usercollection
        .document(widget.uid)
        .collection('following')
        .getDocuments();
    usercollection
        .document(widget.uid)
        .collection('followers')
        .document(firebaseuser.uid)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          isfollowing = true;
        });
      } else {
        setState(() {
          isfollowing = false;
        });
      }
    });
    setState(() {
      username = userdoc['username'];
      following = followngdocuments.documents.length;
      followers = followersdocuments.documents.length;
      profilepic = userdoc['profilepic'];
      dataisthere = true;
    });
  }

  getstream() async {
    setState(() {
      userstream = tweetcollection
          .where('uid', isEqualTo: widget.uid.trim())
          .snapshots();
    });
  }

  getcurrentuseruid() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      onlineuser = firebaseuser.uid;
    });
  }

  followuser() async {
    var document = await usercollection
        .document(widget.uid)
        .collection('followers')
        .document(onlineuser)
        .get();

    if (!document.exists) {
      usercollection
          .document(widget.uid)
          .collection('followers')
          .document(onlineuser)
          .setData({});

      usercollection
          .document(onlineuser)
          .collection('following')
          .document(widget.uid)
          .setData({});
      setState(() {
        followers++;

        isfollowing = true;
      });
    } else {
      usercollection
          .document(widget.uid)
          .collection('followers')
          .document(onlineuser)
          .delete();

      usercollection
          .document(onlineuser)
          .collection('following')
          .document(widget.uid)
          .delete();
      setState(() {
        followers--;

        isfollowing = false;
      });
    }
  }

  likepost(String documentid) async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot document =
        await tweetcollection.document(documentid).get();

    if (document['likes'].contains(firebaseuser.uid)) {
      tweetcollection.document(documentid).updateData({
        'likes': FieldValue.arrayRemove([firebaseuser.uid])
      });
    } else {
      tweetcollection.document(documentid).updateData({
        'likes': FieldValue.arrayUnion([firebaseuser.uid])
      });
    }
  }

  sharepost(String documentid, String tweet) async {
    Share.text('Flitter', tweet, 'text/plain');
    DocumentSnapshot document =
        await tweetcollection.document(documentid).get();
    tweetcollection
        .document(documentid)
        .updateData({'shares': document['shares'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: dataisthere == true
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.lightBlue, Colors.purple]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 6,
                          left: MediaQuery.of(context).size.width / 2 - 64),
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(profilepic),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2.7),
                      child: Column(
                        children: [
                          Text(
                            username,
                            style: mystyle(30, Colors.black, FontWeight.w600),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Following",
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              ),
                              Text(
                                "Followers",
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                following.toString(),
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              ),
                              Text(
                                followers.toString(),
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () => followuser(),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [Colors.blue, Colors.lightBlue])),
                              child: Center(
                                child: Text(
                                  isfollowing == false ? "Follow" : "Unfollow",
                                  style: mystyle(
                                      25, Colors.white, FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "User Tweets",
                            style: mystyle(25, Colors.black, FontWeight.w700),
                          ),
                          StreamBuilder(
                              stream: userstream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot tweetdoc =
                                          snapshot.data.documents[index];
                                      return Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                tweetdoc['profilepic']),
                                          ),
                                          title: Text(
                                            tweetdoc['username'],
                                            style: mystyle(20, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (tweetdoc['type'] == 1)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    tweetdoc['tweet'],
                                                    style: mystyle(
                                                        20,
                                                        Colors.black,
                                                        FontWeight.w400),
                                                  ),
                                                ),
                                              if (tweetdoc['type'] == 2)
                                                Image(
                                                    image: NetworkImage(
                                                        tweetdoc['image'])),
                                              if (tweetdoc['type'] == 3)
                                                Column(
                                                  children: [
                                                    Text(
                                                      tweetdoc['tweet'],
                                                      style: mystyle(
                                                          20,
                                                          Colors.black,
                                                          FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Image(
                                                        image: NetworkImage(
                                                            tweetdoc['image'])),
                                                  ],
                                                ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CommentPage(
                                                                        tweetdoc[
                                                                            'id']))),
                                                        child:
                                                            Icon(Icons.comment),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        tweetdoc['commentcount']
                                                            .toString(),
                                                        style: mystyle(18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () => likepost(
                                                            tweetdoc['id']),
                                                        child: tweetdoc['likes']
                                                                .contains(
                                                                    onlineuser)
                                                            ? Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            : Icon(Icons
                                                                .favorite_border),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        tweetdoc['likes']
                                                            .length
                                                            .toString(),
                                                        style: mystyle(18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () => sharepost(
                                                            tweetdoc['id'],
                                                            tweetdoc['tweet']),
                                                        child:
                                                            Icon(Icons.share),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        tweetdoc['shares']
                                                            .toString(),
                                                        style: mystyle(18),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              })
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
