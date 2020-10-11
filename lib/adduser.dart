import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter/variables.dart';

class AddUser {
  storeuser(user, username, password) {
    usercollection.doc(user.uid).set({
      'email': user.email,
      'password': password,
      'username': username,
      'uid': user.uid,
      'profilepic':
          'https://cnaca.ca/wp-content/uploads/2018/10/user-icon-image-placeholder.jpg'
    });
  }
}
