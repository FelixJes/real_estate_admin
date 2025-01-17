import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_admin/Providers/session.dart';
import 'package:real_estate_admin/home.dart';
import 'package:real_estate_admin/login_screen.dart';

import 'Modules/Project/project_list.dart';

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);

  // Widget getPage() {
  //   var session = AppSession();
  //   switch (session.pageController.) {
  //     case value:

  //       break;
  //     default:
  //   }
  // }

  final List<Widget> pages = [
    Container(
      color: Colors.black,
    ),
    const ProjectList(),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var session = AppSession();
    return StreamBuilder<User?>(
      stream: session.firbaseAuth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return Consumer(
              builder: ((context, value, child) {
                return GetMaterialApp(
                  defaultTransition: Transition.noTransition,
                  home: Container(),
                  builder: (context, child) {
                    return Home(child: child!);
                  },
                );
              }),
            );
          } else {
            return const LoginScreen();
          }
        }
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snapshot.error.toString())));
          return const LoginScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
