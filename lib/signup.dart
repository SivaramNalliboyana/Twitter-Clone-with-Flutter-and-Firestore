import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/adduser.dart';
import 'package:flitter/variables.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var usernamecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  signup() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: usernamecontroller.text + '@flitter.com',
      password: passwordcontroller.text,
    )
        .then((signeduser) {
      AddUser().storeuser(
          signeduser.user, usernamecontroller.text, passwordcontroller.text);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 100),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Get started flittering",
                style: mystyle(30, Colors.white, FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Register",
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
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Password",
                      labelStyle: mystyle(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.lock)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Repeat Password",
                      labelStyle: mystyle(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.lock)),
                ),
              ),
              SizedBox(height: 15.0),
              InkWell(
                onTap: () => signup(),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Register",
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
                    'I agree to',
                    style: mystyle(20),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TermsPolicy())),
                    child: Text("Terms of policy",
                        style: mystyle(20, Colors.purple, FontWeight.w700)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TermsPolicy extends StatefulWidget {
  @override
  _TermsPolicyState createState() => _TermsPolicyState();
}

class _TermsPolicyState extends State<TermsPolicy> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
