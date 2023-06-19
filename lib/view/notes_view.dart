
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../constants/routes.dart';
import '../main.dart';

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Log Out"),
              )
            ];
          }, onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false));
                }
                devtools.log("${shouldLogout.toString()} - Should Log Out!");
                break;
            }
            devtools.log("${value.toString()} - is the selected item!");
          }),
        ],
      ),
      body: const Text("hello notes"),
    );
  }
}