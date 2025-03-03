import 'package:fablabs7/pages/AddDoor.dart';
import 'package:fablabs7/pages/AddUserPage.dart';
import 'package:fablabs7/pages/lockPage.dart';
import 'package:fablabs7/pages/openingDoor.dart';
import 'package:fablabs7/pages/usersPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fablabs7/theme/colors.dart';
import 'package:badges/badges.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fablabs7/widgets/lineChart.dart';



class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('ZION TECH!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white
                  )),
                  
                  subtitle: Text('Good Morning', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white54
                  )),
                  trailing: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(200)
                )
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  GestureDetector(
                    onTap: ()=>{
                      print("open map")
                    },
                    child:itemDashboard('Potre ouvertes', CupertinoIcons.lock_rotation_open, Colors.deepOrange,"map"),
                  ),
                  itemDashboard('Ajout Porte', CupertinoIcons.add_circled_solid, Colors.green, "stat"),
                  itemDashboard('Liste Client', CupertinoIcons.person_2, Colors.purple, "userListe"),
                  itemDashboard('Ajout Client', CupertinoIcons.person_add_solid, Colors.brown, "ajoutClient"),
                  itemDashboard('Ouvre/Ferme ', CupertinoIcons.lock_shield_fill, Colors.indigo,"Lock"),
                  itemDashboard('Statistique', CupertinoIcons.graph_circle, Colors.teal,"ajoutPoubelle"),
                  itemDashboard('plus  infos', CupertinoIcons.question_circle, Colors.blue, "plusInfos"),
                  itemDashboard('Contact', CupertinoIcons.phone, Colors.pinkAccent, "contact"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background, String Taped) => GestureDetector(

    onTap: () {
       String ValueTaped ="";
      
      setState(() {
        
        ValueTaped = Taped;
      });

      switch (ValueTaped) {
        case "map":

          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OpeningDoor()),
              );

        
          break;

        case "stat":

          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddDoor()),
              );

          break;

        case "userListe":
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersPage()),
              );

          break;

        case "ajoutClient":

          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUserPage()),
              );

          break;

        case "Lock":    

         Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LockPage()),
              );

          break;

         case "ajoutPoubelle":    

          print("Have to open ajoutPoubelle");

          break; 

        case "plusInfos":
          print("have to open plus d'infos");  

          break;

        case "contact":
          print("have to open plus d'infos");   

        default:
      }
    },

    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white)
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    ),
  );
}
