import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';

class ProfileOne extends StatefulWidget {
  @override
  _ProfileOneState createState() => _ProfileOneState();
}

class _ProfileOneState extends State<ProfileOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.lightBlue, Colors.purple]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 6,
              left: MediaQuery.of(context).size.width / 2 - 64,
            ),
            child: CircleAvatar(
              radius: 64,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(exampleimage),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.7),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  'Sivaram',
                  style: mystyle(30, Colors.black, FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
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
                      "20",
                      style: mystyle(20, Colors.black, FontWeight.w600),
                    ),
                    Text(
                      "50",
                      style: mystyle(20, Colors.black, FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.lightBlue, Colors.purple]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Edit profile",
                      style: mystyle(20, Colors.white, FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
