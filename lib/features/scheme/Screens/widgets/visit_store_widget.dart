import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/commons/config/ApiUrl.dart';

import '../../../../commons/styles/custom_border_radius.dart';
import '../../../scheme/Widgets/Skeleton.dart';

class VisitStoreWidget extends StatelessWidget {
  const VisitStoreWidget(
      {super.key,
      required this.jewellerShopImage,
      required this.jewelleryName,
      required this.jewelleryAddress});

  final String jewellerShopImage;
  final String jewelleryName;
  final List<String> jewelleryAddress;

  void _openModal(BuildContext context, String jewellerShopImage,
      String jewelleryName, List<String> jewelleryAddress) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Available Stores',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Search for Jeweller, City, Area',
                      border: const OutlineInputBorder(),
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: 1, // Replace with actual count of stores
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: const Color(0xffEEEEEE), width: 1.2),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: const Icon(Icons.store),
                            title: Text(
                              "$jewelleryName - ${jewelleryAddress[0]}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            subtitle: Text(
                              jewelleryAddress[1],
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            trailing: Text(
                              '25.4kms Away',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        );
                        // Populate more `ListTile`s based on the actual data
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffEEEEEE), width: 1.2),
        ),
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => _openModal(context, jewellerShopImage,
                    jewelleryName, jewelleryAddress),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 1,
                        child: CachedNetworkImage(
                          imageUrl:
                              "${ApiUrl.INVESTMENT_SCHEME}$jewellerShopImage",
                          placeholder: (context, url) => const Skeleton(
                            width: double.infinity,
                            height: 189,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Image.asset('assets/store.jpg'),
                      // Replace with your image path
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Redeem at our jewellers store",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Visit our Kalpco authorized Jewellers store",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "View all stores",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                size: 15,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
