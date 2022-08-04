import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedSellerScreen extends StatefulWidget {
  const VerifiedSellerScreen({Key? key}) : super(key: key);

  @override
  State<VerifiedSellerScreen> createState() => _VerifiedSellerScreenState();
}

class _VerifiedSellerScreenState extends State<VerifiedSellerScreen> {
  QuerySnapshot? allApprovedusers;
  showDialogBox(userDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Block Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to block this account",
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
                    "status": "not approved",
                  };
                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(userDocumentId)
                      .update(userDataMap)
                      .whenComplete(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => HomeScreen()));
                    showReusableSnackBar(context, "Blocked Successfully..");
                  });
                },
                child: const Text("Yes"),
              )
            ],
          );
        });
  }

  getAllVerifiedUsers() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedUser) {
      allApprovedusers = allVerifiedUser;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllVerifiedUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedUserDesign() {
      if (allApprovedusers == null) {
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
                              allApprovedusers!.docs[index].get("photoUrl"),
                            ),
                          )),
                    ),
                  ),
                  Text(
                    allApprovedusers!.docs[index].get("name"),
                  ),
                  Text(
                    allApprovedusers!.docs[index].get("email"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialogBox(allApprovedusers!.docs[index].id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/block.png",
                                width: 56,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Block Now",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showReusableSnackBar(
                              context,
                              "Total Earnings= ".toUpperCase() +
                                  "₹ " +
                                  allApprovedusers!.docs[index]
                                      .get("earnings")
                                      .toString());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/earnings.png",
                                width: 56,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "₹ " +
                                    allApprovedusers!.docs[index]
                                        .get("earnings")
                                        .toString(),
                                style: const TextStyle(
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          itemCount: allApprovedusers!.docs.length,
        );
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: "Verified Users Accounts",
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: verifiedUserDesign(),
        ),
      ),
    );
  }
}
