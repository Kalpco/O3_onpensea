import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/Properties.dart';
import '../Widgets/OpenContainerWrapperNew.dart';
import '../Widgets/open_container_wrapper.dart';

class PropertyGridView extends StatelessWidget {
  const PropertyGridView(
      {super.key,
      required this.props,
      required this.likeButtonPressed,
      required this.screenStatus});

  final List<Properties> props;
  final void Function(int index) likeButtonPressed;
  final String screenStatus;

  Widget _gridItemHeader(Properties prop, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Visibility(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(30),
          //       color: Colors.white,
          //     ),
          //     width: 80,
          //     height: 30,
          //     alignment: Alignment.center,
          //     child: const Text(
          //       "30% OFF",
          //       style: TextStyle(fontWeight: FontWeight.w600),
          //     ),
          //   ),
          // ),
          // IconButton(
          //   icon: Icon(
          //     Icons.favorite,
          //     color:const Color(0xFFA6A3A0),
          //   ),
          //   onPressed: () => likeButtonPressed(index),
          // ),
        ],
      ),
    );
  }

  Widget _gridItemBody(Properties prop) {
    String? bytesList;
    bytesList = prop.propImage1Byte;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E6E8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.asset(
          prop.propImage1Byte,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _gridItemFooter(Properties prop, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 95,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                prop.propName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  fontSize: 12,
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 50, // Adjust the height as needed
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prop != null
                            ? "\u{20B9} ${prop.propValue}"
                            : "\u{20B9} ${prop.propValue}",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        prop != null
                            ? "${prop.ownerName}" // Assuming ownerName is the property that holds the owner's name
                            : "", // You can decide what to show if prop is null
                        style: TextStyle(
                          color: Colors.black, // Adjust styling as needed
                          fontWeight: FontWeight.normal,
                          fontSize: 10, // Adjust font size as needed
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 1), // Add spacing between price and owner name
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GridView.builder(
        itemCount: props.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 4,
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 25,
        ),
        itemBuilder: (_, index) {
          Properties property = props[index];
          return OpenContainerWrapperNew(
            screenStatus: screenStatus,
            property: property,
            child: GridTile(
              header: _gridItemHeader(property, index),
              footer: _gridItemFooter(property, context),
              child: _gridItemBody(property),
            ),
          );
        },
      ),
    );
  }
}
