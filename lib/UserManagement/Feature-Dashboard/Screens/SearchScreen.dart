import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/config/CustomTheme.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Set<String> selectedTypes = Set();
  int? selectedMinValue;
  int? selectedMaxValue;
  String? selectedAreaUnit;
  int? selectedAreaMinValue;
  int? selectedAreaMaxValue;
  Set<String> selectedPossessionStatus = Set();
  Set<String> selectedSaleType = Set();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: CustomTheme.customLinearGradient,
            ),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Type',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildSquareCard('Flat', 'assets/images/flats.png'),
                      buildSquareCard('House', 'assets/images/house.png'),
                      buildSquareCard('plot', 'assets/images/plot.png'),
                      buildSquareCard('OS', 'assets/images/OB.png'),
                      buildSquareCard('SS', 'assets/images/store.png'),
                      buildSquareCard('OC', 'assets/images/plots.png'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Budget',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMinValue = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            // Adjust the radius as needed
                            color: Colors.grey[300],
                          ),
                          /*color: Colors.grey[300],*/
                          padding: EdgeInsets.all(8),
                          child: Text(
                            selectedMinValue == null
                                ? 'MIN'
                                : 'Min: $selectedMinValue',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMaxValue = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            // Adjust the radius as needed
                            color: Colors.grey[300],
                          ),
                          /*color: Colors.grey[300],*/
                          padding: EdgeInsets.all(8),
                          child: Text(
                            selectedMaxValue == null
                                ? 'MAX'
                                : 'Max: $selectedMaxValue',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedMinValue,
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text((index + 1).toString()),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedMinValue = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedMaxValue,
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem<int>(
                            value: index + 11,
                            child: Text((index + 11).toString()),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedMaxValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Covered area',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAreaUnit = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            // Adjust the radius as needed
                            color: Colors.grey[300],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            selectedAreaUnit == null
                                ? 'Area'
                                : 'Area: $selectedAreaUnit',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAreaMinValue = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            // Adjust the radius as needed
                            color: Colors.grey[300],
                          ),
                          /*color: Colors.grey[300],*/
                          padding: EdgeInsets.all(8),
                          child: Text(
                            selectedAreaMinValue == null
                                ? 'MIN'
                                : 'Min: $selectedAreaMinValue',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAreaMaxValue = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            // Adjust the radius as needed
                            color: Colors.grey[300],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            selectedAreaMaxValue == null
                                ? 'MAX'
                                : 'Max: $selectedAreaMaxValue',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedAreaUnit,
                        items: [
                          DropdownMenuItem<String>(
                            value: 'feet',
                            child: Text('Ft'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'gaj',
                            child: Text('Gaj'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'cm',
                            child: Text('Cm'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'inch',
                            child: Text('In'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAreaUnit = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedAreaMinValue,
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text((index + 1).toString()),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedAreaMinValue = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedAreaMaxValue,
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem<int>(
                            value: index + 11,
                            child: Text((index + 11).toString()),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedAreaMaxValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Possession Status',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    buildPossessionButton('Under contruction'),
                    Spacer(),
                    buildPossessionButton('Ready to move'),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Sale Type',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    buildSaleTypeButton('NEW'),
                    Spacer(),
                    buildSaleTypeButton('RESALE'),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      /*height: size.height / 13,

                    width: size.width * 0.7,*/
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.purple.shade900,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4C2E84).withOpacity(0.2),
                            offset: const Offset(0, 15.0),
                            blurRadius: 60.0,
                          ),
                        ],
                      ),
                      child: Text(
                        'Search',
                        style: GoogleFonts.inter(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildSquareCard(String text, String imagePath) {
    final isSelected = selectedTypes.contains(text);

    return GestureDetector(
      onTap: () {
        setState(() {
          /*
          if (isSelected) {
            selectedTypes.remove(text);
          } else {
            selectedTypes.add(text);
          }*/
          isSelected ? selectedTypes.remove(text) : selectedTypes.add(text);
        });
      },
      child: Card(
        elevation: 5,
        color: isSelected ? Colors.pink : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 50, // Adjust the image size as needed
                height: 50,
              ),
              SizedBox(height: 8),
              Text(
                text,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPossessionButton(String status) {
    final isSelected = selectedPossessionStatus.contains(status);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedPossessionStatus.remove(status);
          } else {
            selectedPossessionStatus.add(status);
          }
        });
      },
      child: Card(
        elevation: 5,
        color: isSelected ? Colors.pink : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: 140,
          height: 50,
          child: Center(
            child: Text(
              status,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.headlineMedium,
                fontSize: 15,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSaleTypeButton(String type) {
    final isSelected = selectedSaleType.contains(type);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSaleType.remove(type);
          } else {
            selectedSaleType.add(type);
          }
        });
      },
      child: Card(
        elevation: 5,
        color: isSelected ? Colors.pink : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: 140,
          height: 50,
          child: Center(
            child: Text(
              type,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.headlineMedium,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: isSelected ? Colors.white : Colors.black,
              ),
              /*style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),*/
            ),
          ),
        ),
      ),
    );
  }
}
