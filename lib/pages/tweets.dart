import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/addtweet.dart';
import 'package:flitter/comments.dart';
import 'package:flitter/pages/profile.dart';
import 'package:flitter/pages/search.dart';
import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';

class TweetsPage extends StatefulWidget {
  @override
  _TweetsPageState createState() => _TweetsPageState();
}

class _TweetsPageState extends State<TweetsPage> {
  Stream mystream;
  String useruid;
  initState() {
    super.initState();
    getStream();
  }

  getStream() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      useruid = firebaseuser.uid;
      mystream = tweetcollection.snapshots();
    });
  }

  buildcard(String text, Widget widget, IconData icon) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => widget)),
      child: Container(
        width: double.infinity,
        height: 70,
        child: Card(
          child: Row(
            children: <Widget>[
              Icon(icon, size: 35),
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: mystyle(26, Colors.black, FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.lightBlue,
              child: Center(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(exampleimage),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Sivaram",
                      style: mystyle(30, Colors.white, FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('3 Followers',
                            style: mystyle(20, Colors.white, FontWeight.w600)),
                        Text('4 Following',
                            style: mystyle(20, Colors.white, FontWeight.w600))
                      ],
                    )
                  ],
                ),
              ),
            ),
            buildcard('Profile', ProfilePage(useruid), Icons.person),
            buildcard('Search', SearchPage(), Icons.search),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flitter',
              style: mystyle(20, Colors.white, FontWeight.w700),
            ),
            SizedBox(
              width: 5.0,
            ),
            Image(
              width: 45,
              height: 54,
              image: AssetImage('images/flutter1.png'),
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(
              Icons.star,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddTweet())),
        child: Icon(Icons.add, size: 32),
      ),
      body: StreamBuilder(
          stream: mystream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot tweet = snapshot.data.documents[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(tweet['profilepic']),
                      backgroundColor: Colors.white,
                      radius: 25,
                    ),
                    title: Text(
                      tweet['username'],
                      style: mystyle(20, Colors.black, FontWeight.w600),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        if (tweet['type'] == 1)
                          Text(
                            tweet['tweet'],
                            style: mystyle(20, Colors.black, FontWeight.w400),
                          ),
                        if (tweet['type'] == 3)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(tweet['tweet'],
                                  style: mystyle(
                                      20, Colors.black, FontWeight.w400)),
                              SizedBox(height: 10.0),
                              Image(image: NetworkImage(tweet['picture'])),
                            ],
                          ),
                        if (tweet['type'] == 2)
                          Image(image: NetworkImage(tweet['picture'])),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentsPage(
                                              tweet['id'],
                                              tweet['username'],
                                              tweet['profilepic'],
                                              tweet['uid']))),
                                  child: Icon(Icons.comment),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  tweet['commentcount'].toString(),
                                  style: mystyle(18),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => likepost(tweet['id']),
                                  child: tweet['likes'].contains(useruid)
                                      ? Icon(Icons.favorite, color: Colors.red)
                                      : Icon(Icons.favorite_border),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  tweet['likes'].length.toString(),
                                  style: mystyle(18),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () =>
                                      share(tweet['tweet'], tweet['id']),
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
    );
  }
}
