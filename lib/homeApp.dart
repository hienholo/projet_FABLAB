/*
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fablabs7/pages/httpRequest.dart';
import 'package:fablabs7/pages/loginPage.dart';
import 'package:fablabs7/theme/colors.dart';

import 'pages/dashboardPage.dart';
import 'pages/lockPage.dart';
import 'pages/usersPage.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int selectedPage = 0;
  static const List<Widget> pages = <Widget>[
    DashboardPage(),
    LockPage(),
    UsersPage()
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedPage = index;
      print('Pressed ${index}');
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _username = TextEditingController(text: "");
    TextEditingController _password = TextEditingController(text: "");
    String error = '';

    return Scaffold(
      backgroundColor: primary,
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: SafeArea(
        child: SizedBox(
          // height: 30,
          // width: 40,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                //TODO: Save the user to the database
                                if (_username.text != '' &&
                                    _password.text != '') {
                                  AuthenticationProvider.addUser(_username.text,
                                          _password.text, 'user', false)
                                      .then((value) => {
                                            if (value != null)
                                              {
                                                _username.text = '',
                                                _password.text = '',
                                                Navigator.pop(context),
                                              }
                                          });
                                } else {
                                  error = 'Please fill out the form';
                                }
                              },
                              child: Text("Add User"))
                        ],
                        scrollable: true,
                        title: Text('Add New User'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _username,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                TextFormField(
                                  controller: _password,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: Icon(Icons.password),
                                  ),
                                ),
                                Text(
                                  error,
                                  style: TextStyle(
                                    color: red,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                  });
            },
            child: Icon(
              Icons.add,
              size: 20,
            ),
            backgroundColor: buttoncolor,
            // shape:
            //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: selectedPage,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      CupertinoIcons.home,
      CupertinoIcons.lock,
      CupertinoIcons.person,
      CupertinoIcons.arrow_left_circle,
    ];
    return AnimatedBottomNavigationBar(
        backgroundColor: primary,
        icons: iconItems,
        splashColor: secondary,
        inactiveColor: black.withOpacity(0.5),
        gapLocation: GapLocation.center,
        activeIndex: selectedPage,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        elevation: 2,
        onTap: (index) {
          if (index == 3) {
            // SIGN OUT
            AuthenticationProvider.logout();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
          onItemTapped(index);
        });
  }
}
*/