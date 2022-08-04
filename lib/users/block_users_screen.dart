import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedUserScreen extends StatefulWidget {
  const BlockedUserScreen({Key? key}) : super(key: key);

  @override
  State<BlockedUserScreen> createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen> {
  QuerySnapshot? allBlockedUsers;
  showDialogBox(userDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Activate Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to activate this account",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> userDataMap = {
                    "status": "approved",
                  };
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userDocumentId)
                      .update(userDataMap)
                      .whenComplete(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => HomeScreen()));
                    showReusableSnackBar(context, "Activate Successfully..");
                  });
                },
                child: const Text("Yes"),
              )
            ],
          );
        });
  }

  getAllBlockedUsers() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((getAllBlockedUsers) {
      allBlockedUsers = getAllBlockedUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget blockedUserDesign() {
      if (allBlockedUsers == null) {
        return const Center(
          child: Text(
            "No Record found",
            style: TextStyle(fontSize: 30),
          ),
        );
      } else {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 180,
                      height: 140,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              allBlockedUsers!.docs[index].get("photoUrl"),
                            ),
                          )),
                    ),
                  ),
                  Text(
                    allBlockedUsers!.docs[index].get("name"),
                  ),
                  Text(
                    allBlockedUsers!.docs[index].get("email"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogBox(allBlockedUsers!.docs[index].id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/activate.png",
                            width: 56,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Activate Now",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: allBlockedUsers!.docs.length,
        );
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: "Blocked Users Accounts",
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: blockedUserDesign(),
        ),
      ),
    );
  }
}
