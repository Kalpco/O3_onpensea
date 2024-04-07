import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class RecentTransactions extends StatelessWidget {
  final List<dynamic> transactionDetails;

  const RecentTransactions({
    super.key,
    required this.transactionDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions :',
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.labelLarge,
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Transaction ID',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Type',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Status',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          // Display fetched transaction IDs, types, and statuses
          if (transactionDetails != null)
            for (int i = 0; i < transactionDetails.length; i++)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      transactionDetails[i]["propName"],
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      transactionDetails[i]["type"],
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      transactionDetails[i]["status"],
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                        fontSize: 13 ,
                        color: (transactionDetails[i]["status"] == "Admin" ||
                                transactionDetails[i]["status"] == "Verified"
                            ? Colors.green
                            : Colors.red ),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              )
          else
            Text(
              'No transaction data available',
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.labelLarge,
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          // Display a message if data is empty
        ],
      ),
    );
  }
}
