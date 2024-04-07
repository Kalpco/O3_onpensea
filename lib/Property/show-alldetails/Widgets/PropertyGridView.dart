import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Property/show-alldetails/Models/Properties.dart';
import '../Models/buyermodel.dart';
import 'OpenContainerWrapperNew.dart';


class PropertyGridView extends StatelessWidget {
  const PropertyGridView(
      {super.key,
      required this.props,
      required this.likeButtonPressed,
      required this.screenStatus, required String username});

  final List<Buyer> props;
  final void Function(int index) likeButtonPressed;
  final String screenStatus;

  Widget _gridItemHeader(Buyer prop, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

        ],
      ),
    );
  }

  Widget _gridItemBody(Buyer prop) {
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
        child: Image.memory(
          base64.decode(bytesList),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _gridItemFooter(Buyer prop, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 60,
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
            Row(
              children: [
                Text(
                  prop != null
                      ? "\u{20B9} ${prop.tokenPrice}"
                      : "\u{20B9} ${prop.buyerName}",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(width: 3),
                // Visibility(
                //   visible: prop != null ? true : false,
                //   child: Text(
                //     "\u{20B9}${prop.tokenSupply}",
                //     style: const TextStyle(
                //       decoration: TextDecoration.lineThrough,
                //       color: Colors.grey,
                //       fontWeight: FontWeight.normal,
                //     ),
                //   ),
                // )
              ],
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
          Buyer property = props[index];
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
