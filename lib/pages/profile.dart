import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';

import '../comments.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage(this.uid);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool dataIsthere = false;
  String username;
  String profilepic;
  String onlineuser;
  String useruid;
  Stream mystream;
  String following;
  String followers;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  likepost(String id) async {
    DocumentSnapshot document = await tweetcollection.document(id).get();
    if (document['likes'].contains(useruid)) {
      tweetcollection.document(id).updateData({
        'likes': FieldValue.arrayRemove([useruid])
      });
    } else {
      tweetcollection.document(id).updateData({
        'likes': FieldValue.arrayUnion([useruid])
      });
    }
  }

  share(String tweet, String id) async {
    Share.text('FlitterTweet', tweet, 'text/plain');
    DocumentSnapshot share = await tweetcollection.document(id).get();
    tweetcollection.document(id).updateData({'shares': share['shares'] + 1});
  }

  getuserdata() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    var uid = widget.uid == 'ownid' ? firebaseuser.uid : widget.uid;
    DocumentSnapshot userdoc = await usercollection.document(uid).get();
    var followersdocuments = await usercollection
        .document(userdoc['uid'])
        .collection('followers')
        .getDocuments();
    var followingdocuments = await usercollection
        .document(userdoc['uid'])
        .collection('following')
        .getDocuments();
    usercollection
        .document(userdoc['uid'])
        .collection('followers')
        .document(firebaseuser.uid)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          isFollowing = true;
        });
      } else {
        isFollowing = false;
      }
    });
    setState(() {
      username = userdoc['username'];
      useruid = userdoc['uid'];
      profilepic = userdoc['profilepic'];
      onlineuser = firebaseuser.uid;
      dataIsthere = true;
      followers = followersdocuments.documents.length.toString();
      following = followingdocuments.documents.length.toString();
      mystream = tweetcollection
          .where('username', isEqualTo: userdoc['username'])
          .snapshots();
    });
  }

  editprofile() {}

  followuser() async {
    var document = await usercollection
        .document(useruid)
        .collection('followers')
        .document(onlineuser)
        .get();
    if (!document.exists) {
      usercollection
          .document(useruid)
          .collection('followers')
          .document(onlineuser)
          .setData({});
      usercollection
          .document(onlineuser)
          .collection('following')
          .document(useruid)
          .setData({});
    } else {
      usercollection
          .document(useruid)
          .collection('followers')
          .document(onlineuser)
          .delete();
      usercollection
          .document(onlineuser)
          .collection('following')
          .document(useruid)
          .delete();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dataIsthere == false
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.lightBlue, Colors.purple])),
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
                      children: <Widget>[
                        Text(
                          username,
                          style: mystyle(30, Colors.black, FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "Following",
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            ),
                            Text(
                              "Followers",
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              following,
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            ),
                            Text(
                              followers,
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () => onlineuser == useruid
                              ? editprofile()
                              : followuser(),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.lightBlue])),
                            child: Center(
                              child: Text(
                                onlineuser == useruid
                                    ? "Edit"
                                    : isFollowing == false
                                        ? "Follow"
                                        : "Unfollow",
                                style:
                                    mystyle(25, Colors.white, FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "User Tweets",
                          style: mystyle(25, Colors.black, FontWeight.w700),
                        ),
                        StreamBuilder(
                            stream: mystream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot tweet =
                                      snapshot.data.documents[index];
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(tweet['profilepic']),
                                        backgroundColor: Colors.white,
                                        radius: 25,
                                      ),
                                      title: Text(
                                        tweet['username'],
                                        style: mystyle(
                                            20, Colors.black, FontWeight.w600),
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          if (tweet['type'] == 1)
                                            Text(
                                              tweet['tweet'],
                                              style: mystyle(20, Colors.black,
                                                  FontWeight.w400),
                                            ),
                                          if (tweet['type'] == 3)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(tweet['tweet'],
                                                    style: mystyle(
                                                        20,
                                                        Colors.black,
                                                        FontWeight.w400)),
                                                SizedBox(height: 10.0),
                                                Image(
                                                    image: NetworkImage(
                                                        tweet['picture'])),
                                              ],
                                            ),
                                          if (tweet['type'] == 2)
                                            Image(
                                                image: NetworkImage(
                                                    tweet['picture'])),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CommentsPage(
                                                                    tweet['id'],
                                                                    tweet[
                                                                        'username'],
                                                                    tweet[
                                                                        'profilepic'],
                                                                    tweet[
                                                                        'uid']))),
                                                    child: Icon(Icons.comment),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    tweet['commentcount']
                                                        .toString(),
                                                    style: mystyle(18),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () =>
                                                        likepost(tweet['id']),
                                                    child: tweet['likes']
                                                            .contains(useruid)
                                                        ? Icon(Icons.favorite,
                                                            color: Colors.red)
                                                        : Icon(Icons
                                                            .favorite_border),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    tweet['likes']
                                                        .length
                                                        .toString(),
                                                    style: mystyle(18),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () => share(
                                                        tweet['tweet'],
                                                        tweet['id']),
                                                    child: Icon(Icons.share),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    tweet['shares'].toString(),
                                                    style: mystyle(18),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
