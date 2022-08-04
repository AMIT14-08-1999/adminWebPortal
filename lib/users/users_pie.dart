import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

class UsersPieChart extends StatefulWidget {
  const UsersPieChart({Key? key}) : super(key: key);

  @override
  State<UsersPieChart> createState() => _UsersPieChartState();
}

class _UsersPieChartState extends State<UsersPieChart> {
  int totalNumberOfVerifiedUsers = 0;
  int totalNumberOfBlockedUsers = 0;

  getTotalNumberOfVerifiedUsers() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        totalNumberOfVerifiedUsers = allVerifiedUsers.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedUsers() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedUsers) {
      setState(() {
        totalNumberOfBlockedUsers = allBlockedUsers.docs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalNumberOfBlockedUsers();
    getTotalNumberOfVerifiedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(
        title: "Amazon",
      ),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Users', 'measure': totalNumberOfBlockedUsers},
          {'domain': 'Verified Users', 'measure': totalNumberOfVerifiedUsers},
        ],
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case 'Blocked Users':
              return Colors.pink;
            case 'Verified Users':
              return const Color.fromARGB(255, 204, 5, 204);
            default:
              return Colors.grey;
          }
        },
        labelFontSize: 20,
        animate: false,
        pieLabel: (pieData, index) {
          return "${pieData["domain"]}";
        },
        labelColor: Colors.white,
        strokeWidth: 6,
        donutWidth: 20,
      ),
    );
  }
}
