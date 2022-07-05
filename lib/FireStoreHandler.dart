import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'constants.dart';

import 'package:library_management_app/constants.dart';

FirebaseFirestore? db;

FirebaseFirestore getDB() {
  if (db == null) initialise();

  return db as FirebaseFirestore;
}

void initialise() {
  if (db != null) return;

  db = FirebaseFirestore.instance;
}

void getCollection(String collectionName,
    void Function(QuerySnapshot<Map<String, dynamic>>) onComplete) async {
  await getDB().collection(collectionName).get().then(onComplete);
}

void addUserToDB(String uid, bool isAdmin) {
  var booksIssued = [];
  Map<String, dynamic> data = {"isAdmin": isAdmin, "booksIssued": booksIssued};
  getDB()
      .collection(usersCollectionDB)
      .doc(uid)
      .set(data, SetOptions(merge: false));
}

void addBookToDB(Map<String, dynamic> book, void Function(String) onAdded) {
  getDB()
      .collection(booksCollectionDB)
      .add(book)
      .then((value) => onAdded(value.id));
}

void updateDBEntry(String collection, String id, Map<String, dynamic> newData) {
  getDB().collection(collection).doc(id).set(newData);
}

void removeBook(String uid) {
  getDB().collection(booksCollectionDB).doc(uid).delete();
}
