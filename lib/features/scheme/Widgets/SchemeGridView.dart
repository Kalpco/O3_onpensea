import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';
import '../../../commons/config/ApiUrl.dart';
import '../../../utils/constants/sizes.dart';
import '../../Home/widgets/DividerWithAvatar.dart';
import '../Screens/widgets/AllOpenContainerWrapperNew.dart';
import '../Widgets/OpenContainerWrapperNew.dart';

class SchemeGridView extends StatelessWidget {

  SchemeGridView({
    super.key,
    required this.allInvestments,
  });

  List<Investments>? allInvestments;

  Widget _gridItemBody(Datum singleInvestment) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl:
                "${ApiUrl.INVESTMENT_SCHEME}${singleInvestment.investmentImage01}",
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: Colors.grey),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )),
    );
  }

  Widget _gridItemFooter(Datum singleInvestment, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 5),
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              "Scheme Name: ${singleInvestment.investmentName}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.labelLarge,
                fontSize: 16,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      singleInvestment != null
                          ? "Owner: ${singleInvestment.companyName}" // Assuming ownerName is the property that holds the owner's name
                          : "", // You can decide what to show if prop is null
                      style: const TextStyle(
                        color: Colors.black, // Adjust styling as needed
                        fontWeight: FontWeight.normal,
                        fontSize: 12, // Adjust font size as needed
                      ),
                    ),
                  ],
                ),
                // Add spacing between price and owner name
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: allInvestments!.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3.5 / 3,
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 0,
      ),
      itemBuilder: (_, index) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    allInvestments![index].data[0].investmentType.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: AllOpenContainerWrapperNew(
                allInvestments: allInvestments![index].data,
                investmentType: allInvestments![index].data[0].investmentType,
                child: GridTile(
                  // footer:
                  //     _gridItemFooter(allInvestments![index].data[0], context),
                  child: _gridItemBody(allInvestments![index].data[0]),
                ),
              ),
            ),
            const SizedBox(
              height: U_Sizes.spaceBwtSections,
            ),
            const DividerWithAvatar(
                imagePath: 'assets/logos/KALPCO_splash.png'),
          ],
        );
      },
    );
  }
}
