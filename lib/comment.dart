import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/utils/variables.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentPage extends StatefulWidget {
  final String documentid;
  CommentPage(this.documentid);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var commentcontroller = TextEditingController();

  addcoment() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get();
    tweetcollection.doc(widget.documentid).collection('comments').doc().set({
      'comment': commentcontroller.text,
      'username': userdoc.data()['username'],
      'uid': userdoc.data()['uid'],
      'profilepic': userdoc.data()['profilepic'],
      'time': DateTime.now()
    });
    DocumentSnapshot commentcount =
        await tweetcollection.doc(widget.documentid).get();

    tweetcollection
        .doc(widget.documentid)
        .update({'commentcount': commentcount.data()['commentcount'] + 1});
    commentcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: tweetcollection
                      .doc(widget.documentid)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot commentdoc =
                              snapshot.data.docs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(commentdoc.data()['profilepic']),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  commentdoc.data()['username'],
                                  style: mystyle(20),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  commentdoc.data()['comment'],
                                  style:
                                      mystyle(20, Colors.grey, FontWeight.w500),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              tAgo
                                  .format(commentdoc.data()['time'].toDate())
                                  .toString(),
                              style: mystyle(15),
                            ),
                          );
                        });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentcontroller,
                  decoration: InputDecoration(
                    hintText: "Add a comment..",
                    hintStyle: mystyle(18),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                trailing: OutlineButton(
                  onPressed: () => addcoment(),
                  borderSide: BorderSide.none,
                  child: Text(
                    "Publish",
                    style: mystyle(16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
