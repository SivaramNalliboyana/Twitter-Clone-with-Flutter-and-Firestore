import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/variables.dart';

class AddUser {
  storeuser(user, username, password) {
    usercollection.document(user.uid).setData({
      'email': user.email,
      'password': password,
      'username': username,
      'uid': user.uid,
      'profilepic':
          'https://cnaca.ca/wp-content/uploads/2018/10/user-icon-image-placeholder.jpg'
    });
  }
}
