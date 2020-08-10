import 'package:flitter/pages/profile.dart';
import 'package:flitter/pages/profile_one.dart';
import 'package:flitter/pages/search.dart';
import 'package:flitter/pages/tweets.dart';
import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pageoptions = [
    TweetsPage(),
    SearchPage(),
    ProfileOne(),
  ];

  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageoptions[page],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.black,
          currentIndex: page,
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: (Icon(
                  Icons.home,
                  size: 32,
                )),
                title: Text(
                  "Tweets",
                  style: mystyle(20),
                )),
            BottomNavigationBarItem(
                icon: (Icon(
                  Icons.search,
                  size: 32,
                )),
                title: Text(
                  "Search",
                  style: mystyle(20),
                )),
            BottomNavigationBarItem(
                icon: (Icon(
                  Icons.person,
                  size: 32,
                )),
                title: Text(
                  "Profile",
                  style: mystyle(20),
                ))
          ]),
    );
  }
}
