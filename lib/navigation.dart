import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/signup.dart';
import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool isSigned = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((useraccount) {
      if (useraccount != null) {
        setState(() {
          isSigned = true;
        });
      } else {
        setState(() {
          isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? Login() : HomePage(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernamecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to Flitter",
              style: mystyle(30, Colors.white, FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Login",
              style: mystyle(25, Colors.white, FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 64,
              height: 64,
              child: Image(
                image: AssetImage('images/flutter1.png'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: usernamecontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "email",
                    labelStyle: mystyle(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.email)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "password",
                    labelStyle: mystyle(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.lock)),
              ),
            ),
            SizedBox(height: 15.0),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: usernamecontroller.text + '@flitter.com',
                    password: passwordcontroller.text);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    "Login",
                    style: mystyle(20, Colors.black, FontWeight.w700),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Dont have an account?',
                  style: mystyle(20),
                ),
                SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp())),
                  child: Text("Register",
                      style: mystyle(20, Colors.purple, FontWeight.w700)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
