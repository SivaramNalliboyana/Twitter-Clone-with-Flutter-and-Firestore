import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flitter/pages/profile.dart';
import 'package:flutter/material.dart';

import '../variables.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot> searchresult;
  searchuser(String str) {
    var users = usercollection
        .where('username', isGreaterThanOrEqualTo: str)
        .getDocuments();
    setState(() {
      searchresult = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECE5DA),
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
              filled: true,
              hintText: "Search for users..",
              hintStyle: mystyle(18)),
          onFieldSubmitted: searchuser,
        ),
      ),
      body: searchresult == null
          ? Center(
              child: Text(
                "Search for users....",
                style: mystyle(25),
              ),
            )
          : FutureBuilder(
              future: searchresult,
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot user = snapshot.data.documents[index];
                      return Card(
                        elevation: 8.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(user['profilepic']),
                          ),
                          title: Text(
                            user['username'],
                            style: mystyle(25),
                          ),
                          trailing: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage(user['uid']))),
                            child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.lightBlue,
                              ),
                              child: Center(
                                child: Text(
                                  "View",
                                  style: mystyle(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
    );
  }
}
