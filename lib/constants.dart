import 'package:flutter/material.dart';

const String appTitle = "Library Manager";

// Home Page

MaterialColor primaryAppColor = Colors.orange;
Color backgroundAppColor = Colors.grey.shade300;

const Color mainScreenAppBarColor = Color.fromARGB(0, 33, 150, 243);
const Color mainScreenAppBarTextColor = Color.fromARGB(255, 0, 0, 0);

const double aspectRatio = 16.0 / 9.0;

const double userTypeButtonWidth = 25;
const double userTypeButtonHeight = userTypeButtonWidth * aspectRatio * .2;

// Login Page

const double loginPageTextWidth = 75;
const double loginPageTextHeight = loginPageButtonWidth * aspectRatio;

const double emailFieldX = 12.5;
const double emailFieldY = emailFieldX * aspectRatio * 1.3;

const double passwordFieldX = 12.5;
const double passwordFieldY = passwordFieldX * aspectRatio * 1.85;

const double loginPageButtonWidth = 75;
const double loginPageButtonHeight = loginPageButtonWidth * aspectRatio * 0.04;

const double signInButtonX = 12.5;
const double signInButtonY = signInButtonX * aspectRatio * 2.5;

const double signUpButtonX = 12.5;
const double signUpButtonY = signUpButtonX * aspectRatio * 2.8;

const double alertBoxWidth = 25;
const double alertBoxHeight = alertBoxWidth * aspectRatio * 1.25;

const double googleSignInX = 12.5;
const double googleSignInY = googleSignInX * aspectRatio * 3.3;

// DB

const String usersCollectionDB = "users";
const String booksCollectionDB = "books";

// Main Page

const Color bookAvaliableClr = Colors.green;
// Issued by the user itself.
const Color bookReturnClr = Colors.red;
const Color bookUnavaliableClr = Colors.grey;

const String bookAvaliableTxt = "Issue";
const String bookIssuedTxt = "Return";
const String bookUnavaliableTxt = "N/A";

const String adminIssued = "Issued";
const String adminNotIssued = "Not Issued";

const Color adminIssuedClr = Colors.red;
const Color adminNotIssuedClr = Colors.green;

const double addBookTextHeight = 10;
const double addBookTextWidth = 50;

const double authorFieldX = 25;
const double authorFieldY = 10;

const double nameX = 25;
const double nameY = 60;

const String suttLogo = "assets/images/sutt.png";
