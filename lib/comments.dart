import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as Tago;

class CommentsPage extends StatefulWidget {
  final String id;
  final String username;
  final String profilepic;
  final String uid;
  CommentsPage(this.id, this.username, this.profilepic, this.uid);
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentcontroller = TextEditingController();
  savecomment() async {
    DocumentSnapshot document = await tweetcollection.document(widget.id).get();
    var documents = await tweetcollection
        .document(widget.id)
        .collection('comments')
        .getDocuments();
    var length = documents.documents.length;
    tweetcollection
        .document(widget.id)
        .collection('comments')
        .document('Comment $length')
        .setData({
      'username': widget.username,
      'uid': widget.uid,
      'profilepic': widget.profilepic,
      'time': DateTime.now(),
      'id': 'Comment $length',
      'comment': commentcontroller.text
    });
    tweetcollection
        .document(widget.id)
        .updateData({'commentcount': document['commentcount'] + 1});
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
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                      stream: tweetcollection
                          .document(widget.id)
                          .collection('comments')
                          .snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot comment =
                                  snapshot.data.documents[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(comment['profilepic']),
                                ),
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      "${comment['username']}:",
                                      style: mystyle(
                                          20, Colors.black, FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      comment['comment'],
                                      style: mystyle(
                                          20, Colors.black, FontWeight.w500),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                    '${Tago.format(comment["time"].toDate())}'),
                              );
                            });
                      }),
                ),
                Divider(),
                ListTile(
                  title: TextFormField(
                    controller: commentcontroller,
                    decoration: InputDecoration(
                      labelText: 'Comment..',
                      labelStyle: mystyle(20, Colors.black, FontWeight.w700),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                  trailing: OutlineButton(
                    onPressed: () => savecomment(),
                    borderSide: BorderSide.none,
                    child: Text(
                      "Publish",
                      style: mystyle(16),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
