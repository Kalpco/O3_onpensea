import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/CustomTheme.dart';
import '../../Model/TokenPriceModel.dart';

class TokenWatchList extends StatefulWidget {
  final Future<List<TokenPriceModel>> props;

  const TokenWatchList({required this.props, super.key});

  @override
  State<TokenWatchList> createState() => _TokenWatchListState();
}

class _TokenWatchListState extends State<TokenWatchList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<TokenPriceModel>>(
          future: widget.props!,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final tokens = snapshot.data!;
              return buildTokens(tokens);
            } else {
              return const Text("No data available");
            }
          }),
    );
  }

  Widget buildTokens(List<TokenPriceModel> tokens) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${token.tokenName} (${token.tokenSymbol})",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Text(
                    "${token.tokenBalance.round().toString()} Tokens",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  )
                ],
              ),
              Container(
                width: 30,
                height: 30,
                child: Sparkline(
                  data: const [
                    0.0,
                    1.0,
                    1.5,
                    2.0,
                    0.0,
                    0.0,
                    -0.5,
                    -1.0,
                    -0.5,
                    0.0,
                    0.0
                  ],
                  lineWidth: 2.0,
                  lineColor: Colors.green,
                  fillMode: FillMode.below,
                  fillGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.7],
                      colors: [Colors.green, Colors.green.shade100]),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\u{20B9} ${token.price}",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Text(
                    "(\u{20B9}913.5)",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
