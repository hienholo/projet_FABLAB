import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:fablabs7/theme/colors.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(child:
    GridView.count(
      crossAxisCount: 2,
      children: [
        Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.03),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open,
                size: 60,
                color: Colors.orangeAccent,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Opening Door",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: black
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "130",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: mainFontColor
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.03),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open,
                size: 60,
                color: Colors.orangeAccent,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Opening Door",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: black
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "130",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: mainFontColor
                ),
              )
            ],
          ),
        ),

      ],
    )
    ) ;

  }
}
