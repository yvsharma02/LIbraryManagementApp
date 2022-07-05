import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_management_app/LMBook.dart';
import 'package:library_management_app/LoginPage.dart';
import 'package:library_management_app/MainPage.dart';
import 'package:library_management_app/constants.dart';
import 'util.dart';
import 'package:flutter/material.dart';
import 'FireStoreHandler.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

void onSignUp(
    BuildContext context, String email, String password, bool isAdmin) async {
  try {
    showLoadingScreen(context);
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((data) {
      addUserToDB((data.user as User).uid, isAdmin);
      hideLoadingScreen(context);
      showAlertScreen(context, "Accounted Created Successfully!");
    });
  } on FirebaseAuthException catch (e) {
    hideLoadingScreen(context);
    if (e.code == 'weak-password') {
      showAlertScreen(context, "Specified password is too weak!");
    } else if (e.code == 'email-already-in-use') {
      showAlertScreen(context, "Account already exists!");
    }
  } catch (e) {
    print(e);
  }
}

void onSignIn(BuildContext context, String email, String password) async {
  try {
    showLoadingScreen(context);
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((UserCredential cred) {
      hideLoadingScreen(context);
      onSignInComplete(context, false);
    });
  } on FirebaseAuthException catch (e) {
    hideLoadingScreen(context);
    if (e.code == 'user-not-found') {
      showAlertScreen(
          context, "No account associated with email. Use Sign-up instead.");
    } else if (e.code == 'wrong-password') {
      showAlertScreen(context, "Invalid Password. Please retry!");
    }
  } catch (e) {
    print(e);
  }
}

void adminSignIn(BuildContext context, String username, String password) {
  showLoadingScreen(context);
  http
      .post(Uri.parse("https://sids438.pythonanywhere.com/login/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{"username": username, "password": password}))
      .then((response) {
    hideLoadingScreen(context);
    var resData = jsonDecode(response.body);
    print(resData == "Logged In");
    if (resData != "Logged In") {
      showAlertScreen(context, resData);
    } else {
      onSignInComplete(context, true);
    }
  });
}

void InitialiseHandlers() {
  FirebaseAuth.instance.authStateChanges().listen(onUserChange);
}

void onUserChange(User? user) {
  print("User just changed!");
  if (user != null)
    print(user.uid + " just logged in!");
  else
    print("Signed out!");
}
