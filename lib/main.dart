import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:library_management_app/AuthHandler.dart';
import 'package:library_management_app/LoginPage.dart';
import 'constants.dart';
import 'util.dart';
import 'LMButton.dart';

void main() {
  runApp(const LibraryManagementApp());
  InitialiseHandlers();
}

class LibraryManagementApp extends StatefulWidget {
  const LibraryManagementApp({Key? key}) : super(key: key);

  @override
  State<LibraryManagementApp> createState() => _LibraryManagementAppState();
}

class _LibraryManagementAppState extends State<LibraryManagementApp> {
  bool initialized = false;
  bool error = false;

  void initializeFirebase() async {
    try {
      var app = await Firebase.initializeApp();
      setState(() {
        if (!app.name.isEmpty)
          initialized = true;
        else
          error = true;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainBody =
        initialized ? HomePage(title: appTitle) : Text("Something went wrong.");

    return MaterialApp(
      title: appTitle,
      home: Scaffold(body: mainBody),
      theme: ThemeData(primarySwatch: primaryAppColor),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundAppColor,
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        elevation: 0,
        backgroundColor: mainScreenAppBarColor,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Image.asset(suttLogo),
            top: 0,
            left: 0,
            height: scaleHeight(context, 100),
            width: scaleWidth(context, 100),
          ),
          LMButton(
            context,
            userTypeButtonHeight,
            userTypeButtonWidth,
            20,
            40,
            onStudentButtonPress,
            label: "Student",
          ),
          LMButton(context, userTypeButtonHeight, userTypeButtonWidth, 55, 40,
              onAdminButtonPress,
              label: "Admin"),
        ],
      ),
    );
  }

  void onAdminButtonPress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => StudentLoginPage(true)));
  }

  void onStudentButtonPress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => StudentLoginPage(false)));
  }
}
