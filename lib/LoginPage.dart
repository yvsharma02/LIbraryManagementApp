import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_management_app/LMButton.dart';
import 'package:library_management_app/LMTextField.dart';
import 'package:library_management_app/util.dart';
import 'constants.dart';
import 'AuthHandler.dart';
import 'FireStoreHandler.dart';
import 'LMBook.dart';
import 'MainPage.dart';

import 'package:google_sign_in/google_sign_in.dart';

class StudentLoginPage extends StatefulWidget {
  final bool isAdmin;

  const StudentLoginPage(this.isAdmin, {Key? key}) : super(key: key);

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState(isAdmin);
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  String currentEmail = "";
  String currentPassword = "";
  bool loginAsAdmin = false;

  _StudentLoginPageState(this.loginAsAdmin);

  @override
  Widget build(BuildContext context) {
    String emailFieldLabel = loginAsAdmin ? "Admin ID" : "Email-ID";
    String emailFieldHint =
        loginAsAdmin ? "Enter your admin ID." : "Enter your email.";
    String appBarTitle = loginAsAdmin ? "Admin Login" : "Student Login";

    return Scaffold(
      backgroundColor: backgroundAppColor,
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: mainScreenAppBarColor,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(suttLogo),
            top: 0,
            left: 0,
            height: scaleHeight(context, 100),
            width: scaleWidth(context, 100),
          ),
          LMTextField(
            context,
            loginPageTextHeight,
            loginPageTextWidth,
            emailFieldX,
            emailFieldY,
            (newEmail) => currentEmail = newEmail,
            label: emailFieldLabel,
            hint: emailFieldHint,
          ),
          LMTextField(
            context,
            loginPageTextHeight,
            loginPageTextWidth,
            passwordFieldX,
            passwordFieldY,
            (newPass) => currentPassword = newPass,
            label: "Password",
            hint: "Enter your Password.",
            obscure: true,
          ),
          LMButton(
            context,
            loginPageButtonHeight,
            loginPageButtonWidth,
            signInButtonX,
            signInButtonY,
            () {
              if (loginAsAdmin)
                adminSignIn(context, currentEmail, currentPassword);
              else
                onSignIn(context, currentEmail, currentPassword);
            },
            label: "Sign-in!",
          ),
          if (!loginAsAdmin)
            LMButton(
              context,
              loginPageButtonHeight,
              loginPageButtonWidth,
              signUpButtonX,
              signUpButtonY,
              () => onSignUp(
                  context, currentEmail, currentPassword, loginAsAdmin),
              label: "Sign-up!",
            ),
          if (!loginAsAdmin)
            LMButton(
              context,
              loginPageButtonHeight,
              loginPageButtonWidth,
              googleSignInX,
              googleSignInY,
              () => startGoogleSigninProcess(context),
              label: "Signin using Google!",
            )
        ],
      ),
    );
  }
}

void startGoogleSigninProcess(BuildContext context) {
  showLoadingScreen(context);
  signInWithGoogle().then((val) {
    hideLoadingScreen(context);
    onSignInComplete(context, false);
  });
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

void TestRetriveData() {
  getCollection("users", (x) {
    for (var doc in x.docs) print("${doc.id} => ${doc.data()}");
  });
}

void onSignInComplete(BuildContext context, bool admin) {
  showLoadingScreen(context, msg: "Signin successful! Loading Data");
  getCollection(booksCollectionDB, (data) {
    hideLoadingScreen(context);
    List<LMBook> bookList = List.empty(growable: true);

    for (int i = 0; i < data.size; i++)
      bookList.add(LMBook(data.docs[i].id, data.docs[i].data()));
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainPage(bookList, admin)));
  });
}
