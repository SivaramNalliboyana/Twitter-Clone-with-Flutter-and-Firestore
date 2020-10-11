import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle mystyle(double size, [Color color, FontWeight fw]) {
  return GoogleFonts.montserrat(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

CollectionReference usercollection =
    FirebaseFirestore.instance.collection('users');
String exampleimage =
    'https://upload.wikimedia.org/wikipedia/commons/9/9a/Mahesh_Babu_in_Spyder_%28cropped%29.jpg';

CollectionReference tweetcollection =
    FirebaseFirestore.instance.collection('tweets');
StorageReference pictures = FirebaseStorage.instance.ref().child('tweetpics');
