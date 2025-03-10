import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';
import '../../../network/dio_client.dart';
import '../../../utils/constants/sizes.dart';
import '../../Home/widgets/DividerWithAvatar.dart';
import '../Screens/widgets/AllOpenContainerWrapperNew.dart';

class SchemeGridView extends StatelessWidget {
  SchemeGridView({
    super.key,
    required this.allInvestments,
  });

  List<Investments>? allInvestments;

  /// **🔹 Fetch Image Securely with JWT Authentication**
  Future<ImageProvider> _fetchImageWithJwt(String imageUrl) async {
    try {
      Dio dio = DioClient.getInstance(); // Ensure correct Dio instance

      Response<List<int>> response = await dio.get<List<int>>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes, // Get raw bytes
        ),
      );

      return MemoryImage(Uint8List.fromList(response.data!)); // Convert bytes to Image
    } catch (e) {
      print("❌ Error fetching image with JWT: $e");
      return const AssetImage('assets/logos/default_image.png'); // Fallback Image
    }
  }

  /// **🔹 Grid Item Body - Uses JWT for Secure Image Loading**
  Widget _gridItemBody(Datum singleInvestment) {
    String imageUrl =
        "${ApiConstants.INVESTMENTMS_URL}${singleInvestment.investmentImage01}";

    print(imageUrl);

    return FutureBuilder<ImageProvider>(
      future: _fetchImageWithJwt(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.grey),
          );
        }
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }
        return Container(
          padding: const EdgeInsets.all(1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: snapshot.data!,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
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
                      "Owner: ${singleInvestment.companyName}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
            const SizedBox(height: 20),
            Expanded(
              child: AllOpenContainerWrapperNew(
                allInvestments: allInvestments![index].data,
                investmentType: allInvestments![index].data[0].investmentType,
                child: GridTile(
                  child: _gridItemBody(allInvestments![index].data[0]),
                ),
              ),
            ),
            const SizedBox(height: U_Sizes.spaceBwtSections),
            const DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
          ],
        );
      },
    );
  }
}
