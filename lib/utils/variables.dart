import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mystyle(double size, [Color color, FontWeight fw]) {
  return GoogleFonts.montserrat(fontSize: size, fontWeight: fw, color: color);
}

CollectionReference usercollection = Firestore.instance.collection('users');
CollectionReference tweetcollection = Firestore.instance.collection('tweets');
StorageReference tweetpictures =
    FirebaseStorage.instance.ref().child('tweetpictures');
var exampleimage =
    'https://upload.wikimedia.org/wikipedia/commons/9/9a/Mahesh_Babu_in_Spyder_%28cropped%29.jpg';
