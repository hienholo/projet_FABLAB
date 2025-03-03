import 'package:fablabs7/constaints.dart';
import 'package:fablabs7/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:fablabs7/constaints.dart';
import 'package:fablabs7/models/userModel.dart';
import 'package:fablabs7/pages/httpRequest.dart';
import 'package:fablabs7/theme/colors.dart';
import 'package:slidable_button/slidable_button.dart';

class Lock {
  bool lockState;
  String lockImage;

  changeLockState() {
    lockState = !lockState;
    if (lockState == true) {
      lockImage = LOCK_OPENED_IMAGE;
    } else {
      lockImage = LOCK_CLOSED_IMAGE;
    }
  }

  Lock({required this.lockState, required this.lockImage});
}

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  State<LockPage> createState() => _LockState();
}

class _LockState extends State<LockPage> {
  String result = "";

  final Lock _lock = Lock(lockState: true, lockImage: LOCK_CLOSED_IMAGE);

  unlock() {
    setState(() {
      _lock.lockState = false;
      _lock.lockImage = LOCK_OPENED_IMAGE;
    });
  }

  lock() {
    setState(() {
      _lock.lockState = true;
      _lock.lockImage = LOCK_CLOSED_IMAGE;
    });
  }

  late DateTime now;
  refreshStatus() {
 /*   AuthenticationProvider.getLockState().then((value) => {
          this.setState(() {
            result = 'Updated successfuly';
            if (value['message'] == 'true') {
              lock();
            } else if (value['message'] == 'false') {
              unlock();
            }
          })
        });*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*AuthenticationProvider.getLockState().then((value) => {
          if (value['message'] == 'true')
            {lock()}
          else if (value['message'] == 'false')
            {unlock()}
        });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: getBody(),
    );
  }

  Widget getBody() {
    var lockColor = _lock.lockState ? red : green;
   // UserModel? user = AuthenticationProvider.user;
    // user = JwtDecoder.decode(storage.read(key: 'decodedJWT').toString());
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: IconBadge(
                icon: const Icon(Icons.refresh),
                itemCount: 0,
                badgeColor: Colors.red,
                itemColor: mainFontColor,
                hideZero: true,
                top: -1,
                onTap: () {
                  refreshStatus();
                },
              ),
            ),
            SizedBox(
              width: 250,
              height: 250,
              child: _lock.lockState
                  ? const Icon(
                      Icons.lock,
                      size: 250,
                      color: Color.fromARGB(255, 255, 132, 31),
                    )
                  : const Icon(
                      Icons.lock_open,
                      size: 250,
                      color: Color.fromARGB(255, 43, 255, 24),
                    ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: HorizontalSlidableButton(
                width: 400,
                height: 60,
                buttonWidth: 100.0,
                color: const Color.fromARGB(255, 73, 73, 73),
                buttonColor: buttoncolor,
                dismissible: false,
                label: const Center(
                  child: Text(
                    "Slide Me",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 25),
                        child: const Text(
                          "Lock",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 25),
                        child: const Text(
                          "Unlock",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
                onChanged: (position) {
                  setState(() {
                  
                      if (position == SlidableButtonPosition.start) {
                         print("open");
                        lock();
                        /*AuthenticationProvider.changeLockState("lock")
                            .then((value) => {
                                  if (value != null)
                                    {lock(), result = 'Lock is closed'}
                                });*/
                      } else if (position == SlidableButtonPosition.end) {
                        print("open");
                        unlock();
                       /* AuthenticationProvider.changeLockState("unlock")
                            .then((value) => {
                                  if (value != null)
                                    {unlock(), result = 'Lock is opened'}
                                });*/
                      }
                  
                  });
                },
              ),
            ),
            Text(
              result,
              style: TextStyle(color: lockColor, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 50,
              height: 50,
              child: true == true
                  ? const Icon(
                      Icons.verified,
                      size: 50,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.dangerous,
                      size: 50,
                      color: red,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}