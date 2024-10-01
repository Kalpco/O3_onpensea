import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DetailScreen extends StatelessWidget {
  final String schemeName;
  final String amount;

  const DetailScreen({required this.schemeName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Details Screen'),
      ),
      body: Center(
        child: Text('Scheme: $schemeName\nAmount: $amount'),
      ),
    );
  }
}