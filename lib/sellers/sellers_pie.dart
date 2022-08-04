import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

class SellerPieChartScreen extends StatefulWidget {
  const SellerPieChartScreen({Key? key}) : super(key: key);

  @override
  State<SellerPieChartScreen> createState() => _SellerPieChartScreenState();
}

class _SellerPieChartScreenState extends State<SellerPieChartScreen> {
  int totalNumberOfVerifiedSellers = 0;
  int totalNumberOfBlockedSellers = 0;

  getTotalNumberOfVerifiedSelelrs() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      setState(() {
        totalNumberOfVerifiedSellers = allVerifiedSellers.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedSelelrs() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedSellers) {
      setState(() {
        totalNumberOfBlockedSellers = allBlockedSellers.docs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalNumberOfBlockedSelelrs();
    getTotalNumberOfVerifiedSelelrs();
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
          {'domain': 'Blocked Sellers', 'measure': totalNumberOfBlockedSellers},
          {
            'domain': 'Verified Sellers',
            'measure': totalNumberOfVerifiedSellers
          },
        ],
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case 'Blocked Sellers':
              return Colors.red;
            case 'Verified Sellers':
              return Colors.green;
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
