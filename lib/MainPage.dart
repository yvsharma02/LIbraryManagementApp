import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_management_app/FireStoreHandler.dart';
import 'package:library_management_app/LMBook.dart';
import 'package:library_management_app/constants.dart';
import 'util.dart';
import 'LMTextField.dart';
import 'constants.dart';

class MainPage extends StatefulWidget {
  List<LMBook> cachedBookList;
  bool adminMode;

  MainPage(this.cachedBookList, this.adminMode, {Key? key}) : super(key: key);

  @override
  State<MainPage> createState() =>
      _MainPageState(cachedBookList, this.adminMode);
}

class _MainPageState extends State<MainPage> {
  bool adminMode;
  List<LMBook> cachedBookList;

  _MainPageState(this.cachedBookList, this.adminMode);
  List<Widget> tiles = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    tiles = List.empty(growable: true);
    String currentUserID = FirebaseAuth.instance.currentUser == null
        ? ""
        : (FirebaseAuth.instance.currentUser as User).uid;

    for (int i = 0; i < cachedBookList.length; i++) {
      String bookUID = cachedBookList[i].UID;

      final info = cachedBookList[i].data;
      bool isIssued = info["isIssued"];
      bool issuedByCurrentUser = info["issuedBy"] == currentUserID;

      String issueBtnText = isIssued
          ? (issuedByCurrentUser ? bookIssuedTxt : bookUnavaliableTxt)
          : bookAvaliableTxt;
      Color issueBtnClr = isIssued
          ? (issuedByCurrentUser ? bookReturnClr : bookUnavaliableClr)
          : bookAvaliableClr;

      String issueStatusText = isIssued ? adminIssued : adminNotIssued;
      Color issueStatusColor = isIssued ? adminIssuedClr : adminNotIssuedClr;

      tiles.add(ListTile(
          tileColor: (i % 2 == 0) ? Colors.grey.shade200 : Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200, width: 3),
            borderRadius: BorderRadius.circular(5),
          ),
          title: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        info["title"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("By:\t" + info["author"],
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 12))),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        issueStatusText,
                        style: TextStyle(color: issueStatusColor),
                      )),
                ],
              )),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            if (!adminMode)
              FloatingActionButton(
                  heroTag: bookUID + "issueBtn",
                  backgroundColor: issueBtnClr,
                  onPressed: (isIssued && !issuedByCurrentUser) || adminMode
                      ? null
                      : () {
                          setState(() {
                            if (issuedByCurrentUser) {
                              info["isIssued"] = false;
                              info["issuedBy"] = "";
                            } else {
                              info["isIssued"] = true;
                              info["issuedBy"] = currentUserID;
                            }
                            updateDBEntry(booksCollectionDB, bookUID, info);
                          });
                        },
                  child: Text(issueBtnText)),
            if (adminMode)
              FloatingActionButton(
                heroTag: bookUID + "rmBtn",
                onPressed: () {
                  setState(() {
                    cachedBookList.remove(cachedBookList[i]);
                    removeBook(bookUID);
                  });
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                backgroundColor: Colors.red.withAlpha(0),
                elevation: 0,
              )
          ])));
      /*tiles.add(Divider());*/
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: FloatingActionButton(
            onPressed: () => onSignout(context),
            child: Icon(Icons.cancel),
            backgroundColor: Colors.white.withOpacity(0),
            elevation: 0,
            heroTag: "signoutBtn",
          ),
          actions: [
            if (adminMode)
              FloatingActionButton(
                onPressed: () => showNewBookDialog(context),
                heroTag: "addBookBtn",
                backgroundColor: Colors.white.withOpacity(0),
                elevation: 0,
                child: Icon(Icons.add),
              )
          ],
        ),
        body: ListView(
          children: tiles,
        ));
  }

  void onSignout(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null)
      FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  void showNewBookDialog(BuildContext context) {
    String name = "";
    String author = "";
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: Center(child: Text("Add a new book!")),
              content: SizedBox(
                  height: scaleHeight(context, alertBoxHeight,
                      scaleWithWidth: true),
                  width: scaleWidth(context, alertBoxWidth),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(2),
                          child: TextField(
                              onChanged: (n) => name = n,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1))),
                                labelText: "Title",
                                hintText: "Title",
                              ))),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                              onChanged: (a) => author = a,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1))),
                                labelText: "Author",
                                hintText: "Author",
                              ))),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 5, 0),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                onPressed: () {
                                  if (name.isEmpty) {
                                    showAlertScreen(
                                        context, "Name cannot be empty!");
                                    return;
                                  }
                                  if (author.isEmpty) {
                                    showAlertScreen(
                                        context, "Author cannot be exmpty!");
                                    return;
                                  }

                                  addBook(context, name, author);
                                },
                                child: Icon(Icons.check),
                              )))
                    ],
                  )));
        });
  }

  void addBook(BuildContext context, String name, String author) {
    Map<String, dynamic> bookData = {
      "title": name,
      "author": author,
      "isIssued": false
    };

    Navigator.of(context).pop();
    showLoadingScreen(context, msg: "Adding Book");
    addBookToDB(bookData, (id) {
      setState(() {
        cachedBookList.add(LMBook(id, bookData));
      });
      hideLoadingScreen(context);
    });
  }
}
