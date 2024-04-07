import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Dspinvestor/Screens/all_movie_screen.dart';
import '../../../../Investor/Screens/all_movie_screen.dart';
import '../../../../config/CustomTheme.dart';

class YourTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
              'Investor',
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.labelLarge,
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'COUNT',
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.labelLarge,
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Action',
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.labelLarge,
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
        rows: [
          DataRow(cells: [
            DataCell(
              Text(
                'CP',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            DataCell(
              Text(
                '10',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            DataCell(Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllInvestorScreen(
                                categoryType: "movies",
                                screenStatus: 'buy',
                              )),
                    );
                  }, style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.fifthColorForMovies,
                ),
                  child: Text(
                    'Go',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
            )),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'DSP',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            DataCell(
              Text(
                '20',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            DataCell(Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllDSPInvestorScreen(
                                  categoryType: "movies",
                                  screenStatus: 'buy',
                                )),
                      );
                    }
                    ;
                  },style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.fifthColorForMovies,
                ),
                  child: Text(
                    'Go',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                // SizedBox(width: 8),
              ],
            )),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'DI',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            DataCell(
              Text(
                '30',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            DataCell(Row(
              children: [],
            )),
          ]),
        ],
      ),
    );
  }
}
