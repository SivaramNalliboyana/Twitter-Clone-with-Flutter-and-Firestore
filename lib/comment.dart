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
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userdoc =
        await usercollection.document(firebaseuser.uid).get();
    tweetcollection
        .document(widget.documentid)
        .collection('comments')
        .document()
        .setData({
      'comment': commentcontroller.text,
      'username': userdoc['username'],
      'uid': userdoc['uid'],
      'profilepic': userdoc['profilepic'],
      'time': DateTime.now()
    });
    DocumentSnapshot commentcount =
        await tweetcollection.document(widget.documentid).get();

    tweetcollection
        .document(widget.documentid)
        .updateData({'commentcount': commentcount['commentcount'] + 1});
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
                      .document(widget.documentid)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot commentdoc =
                              snapshot.data.documents[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(commentdoc['profilepic']),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  commentdoc['username'],
                                  style: mystyle(20),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  commentdoc['comment'],
                                  style:
                                      mystyle(20, Colors.grey, FontWeight.w500),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              tAgo
                                  .format(commentdoc['time'].toDate())
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
