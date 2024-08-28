import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onpensea/utils/constants/colors.dart';

import '../../authentication/screens/login/Controller/LoginController.dart';
import '../Controller/callWalletApi.dart';
import '../Model/walletTransactionDTO.dart';
import '../Model/wrapperTransactionResponseDTO.dart';
// Import your models

class Mywallet extends StatefulWidget {
  const Mywallet({super.key});

  @override
  State<Mywallet> createState() => _MywalletState();
}

class _MywalletState extends State<Mywallet> {
  late Future<WalletTransactionWrapperDTO?> futureWalletData;
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];
    futureWalletData = WalletApiService().fetchWalletTransactions(userId); // Use the actual userId
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${loginController.userData['name'] != null ? "${loginController.userData['name']}'s" : 'Guest'} Wallet ",
            style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
          ),
          backgroundColor: U_Colors.yaleBlue,
        ),
        backgroundColor: U_Colors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: FutureBuilder<WalletTransactionWrapperDTO?>(
            future: futureWalletData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data found.'));
              } else {
                final walletData = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: U_Colors.green,
                        height: 70,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          '₹ ${walletData.totalAmount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          columnWidths: {
                            0: IntrinsicColumnWidth(flex: 0.5),
                            1: FlexColumnWidth(),
                            2: FlexColumnWidth(),
                            3: FlexColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: U_Colors.yaleBlue),
                              children: [
                                tableCell('Sr.No', Colors.white, FontWeight.bold),
                                tableCell('Date', Colors.white, FontWeight.bold),
                                tableCell('Item', Colors.white, FontWeight.bold),
                                tableCell('Amount', Colors.white, FontWeight.bold),
                              ],
                            ),
                            ...walletData.walletTransactionDTOList.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              WalletTransactionDTO transaction = entry.value;
                              return TableRow(
                                children: [
                                  tableCell('$index', Colors.black),
                                  tableCell('${transaction.updateaDate.toLocal()}'.split(' ')[0], Colors.black),
                                  tableCell('${transaction.reason}', Colors.black),
                                  tableCell(
                                    '₹.${transaction.amount}',
                                    transaction.transactionType == 'CR'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget tableCell(String text, Color textColor, [FontWeight fontWeight = FontWeight.normal]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: fontWeight),
        textAlign: TextAlign.center,
      ),
    );
  }
}
