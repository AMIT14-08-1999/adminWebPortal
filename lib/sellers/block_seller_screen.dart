import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockSellerScreen extends StatefulWidget {
  const BlockSellerScreen({Key? key}) : super(key: key);

  @override
  State<BlockSellerScreen> createState() => _BlockSellerScreenState();
}

class _BlockSellerScreenState extends State<BlockSellerScreen> {
  QuerySnapshot? allBlockSellers;
  showDialogBox(sellerDocumentId) {
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
                      .collection("sellers")
                      .doc(sellerDocumentId)
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

  getAllVerifiedUsers() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((getAllBlockSellers) {
      allBlockSellers = getAllBlockSellers;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllVerifiedUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedSellersDesign() {
      if (allBlockSellers == null) {
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
                              allBlockSellers!.docs[index].get("photoUrl"),
                            ),
                          )),
                    ),
                  ),
                  Text(
                    allBlockSellers!.docs[index].get("name"),
                  ),
                  Text(
                    allBlockSellers!.docs[index].get("email"),
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
                          showDialogBox(allBlockSellers!.docs[index].id);
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
                                  allBlockSellers!.docs[index]
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
                                    allBlockSellers!.docs[index]
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
          itemCount: allBlockSellers!.docs.length,
        );
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: "Block Sellers Accounts",
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: verifiedSellersDesign(),
        ),
      ),
    );
  }
}
