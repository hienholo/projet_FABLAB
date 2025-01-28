import 'package:fablabs7/pages/usersPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fablabs7/theme/colors.dart';
import 'package:badges/badges.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fablabs7/widgets/lineChart.dart';




class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 10),
                child: LineChartSample(),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Overview",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: mainFontColor,
                                )),
                            IconBadge(
                              icon: Icon(Icons.settings),
                              itemCount: 0,
                              badgeColor: Colors.red,
                              itemColor: mainFontColor,
                              hideZero: true,
                              top: -1,
                              onTap: () {
                                print('test');
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    Text("Jan 16, 2023",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: mainFontColor,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child:
                  SizedBox(
                      child: GridView.count(
                        shrinkWrap: true,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 40,
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
                                  Icons.door_front_door_rounded,
                                  size: 50,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Opening Door",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: black
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
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
                            child:  GestureDetector(
                              onTap: ()=>{
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UsersPage()),
                                  )
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.supervised_user_circle,
                                    size: 50,
                                    color: Colors.greenAccent,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Users",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: black
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
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
                                  Icons.lock,
                                  size: 50,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Status",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
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
                                  Icons.visibility,
                                  size: 50,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "11-10-2023",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: mainFontColor
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "14:50 PM",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: mainFontColor
                                  ),
                                )
                              ],
                            ),
                          ),

                        ],
                      )
                  ),
                )

            ],
          ),
        ));
  }
}
