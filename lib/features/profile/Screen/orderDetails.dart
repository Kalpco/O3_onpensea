import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/colors.dart';
import 'package:onpensea/commons/config/api_constants.dart' as API_CONSTANTS_1;

import '../../authentication/screens/login/Controller/LoginController.dart';


class OrderDetailsPage extends StatefulWidget {
  final dynamic productList;
  int? userId,transactionId,addressId;
  String transactionOrderId;
   OrderDetailsPage({super.key,required this.productList,required this.userId,required this.transactionId,required this.addressId,required this.transactionOrderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  bool isLoading = false; // For showing the loader
  final Dio dio = Dio();



  Future<void> downloadInvoice() async {
    try {
      if (await _requestPermission(Permission.storage)) {
        Directory directory = await getApplicationDocumentsDirectory();
        String filePath = "${directory.path}/invoice.pdf";

        String apiUrl = "${API_CONSTANTS_1.ApiConstants.INVOICE_DOWNLOAD}/user/${widget.userId}/transaction/${widget.transactionId}/addressId/${widget.addressId}";

        Response response = await dio.get(
          apiUrl,
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );

        File file = File(filePath);
        await file.writeAsBytes(response.data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice downloaded to $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download invoice: $e')),
      );
    }
  }


Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    return result.isGranted;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: U_Colors.yaleBlue,
        title: Text('Order Details',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID Section
              Text(
                'Order ID - ${widget.transactionOrderId}',
                style: TextStyle(fontSize: 14, color: Colors.grey,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              //new
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.productList.length,
                itemBuilder: (context, index) {
                  final productDetail = widget.productList[index];
                  final imageUrl="${ApiConstants.baseUrl}${productDetail['productPic']}";
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey),
                            // borderRadius: BorderRadius.circular(20),
                          ),
                          child: productDetail['productPic'] != null
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Product Information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productDetail['productName'] ?? 'Product Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),

                              ),
                              // Text(
                              //   'Seller: ${product['seller'] ?? 'Unknown'}',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              SizedBox(height: 8),
                              Text(
                                '₹${productDetail['totalAmount']?.toString() ?? '0'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Product Details Section
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     // Product Image
              //     Container(
              //       width: 80,
              //       height: 80,
              //       decoration: BoxDecoration(
              //         border: Border.all(color: Colors.grey),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: Image.network(
              //         'https://via.placeholder.com/80',
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //     SizedBox(width: 16),
              //     // Product Information
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'ZAYSH Regular Men Grey Jeans',
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(
              //             '34, Grey',
              //             style: TextStyle(fontSize: 14, color: Colors.grey),
              //           ),
              //           Text(
              //             'Seller: JKSALE18',
              //             style: TextStyle(fontSize: 14, color: Colors.grey),
              //           ),
              //           SizedBox(height: 8),
              //           Text(
              //             '₹670',
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 16),


              // Invoice Download Section
              GestureDetector(
                onTap: downloadInvoice, // Call the download function
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: U_Colors.yaleBlue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1.0,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  // decoration: BoxDecoration(
                  //   color: U_Colors.yaleBlue,
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Invoice download',style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      // Icon(Icons.arrow_forward, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 16),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey.shade300),
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.shade200,
              //         blurRadius: 5.0,
              //         spreadRadius: 1.0,
              //         offset: Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // Shipping Details Section
              //       Padding(
              //         padding: EdgeInsets.all(16),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Shipping Details",
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black87,
              //               ),
              //             ),
              //             SizedBox(height: 8),
              //             Text(
              //               "Satyam Pandey",
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black,
              //               ),
              //             ),
              //             Text(
              //               "Everest CHS, Plot no - 01, A-203, Sec - 4\nKalamboli, St. Joseph School\nNavi Mumbai\nMaharashtra - 410218",
              //               style: TextStyle(fontSize: 14, color: Colors.black87),
              //             ),
              //             SizedBox(height: 4),
              //             Text(
              //               "Phone number: 9167",
              //               style: TextStyle(fontSize: 14, color: Colors.black87),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Divider(color: Colors.grey.shade300, thickness: 1),
              //       // Price Details Section
              //       Padding(
              //         padding: EdgeInsets.all(16),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Price Details",
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black87,
              //               ),
              //             ),
              //             SizedBox(height: 8),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text("List price", style: TextStyle(fontSize: 14)),
              //                 Text("₹1,699", style: TextStyle(fontSize: 14)),
              //               ],
              //             ),
              //             SizedBox(height: 4),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text("Selling price", style: TextStyle(fontSize: 14)),
              //                 Text("₹665", style: TextStyle(fontSize: 14)),
              //               ],
              //             ),
              //             SizedBox(height: 4),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text("Delivery Charge", style: TextStyle(fontSize: 14)),
              //                 Text("₹40 Free", style: TextStyle(fontSize: 14, color: Colors.green)),
              //               ],
              //             ),
              //             SizedBox(height: 4),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text("Handling Fee", style: TextStyle(fontSize: 14)),
              //                 Text("₹5", style: TextStyle(fontSize: 14)),
              //               ],
              //             ),
              //             Divider(color: Colors.grey.shade300, thickness: 1),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Total Amount",
              //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //                 ),
              //                 Text(
              //                   "₹670",
              //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(height: 8),
              //             Text(
              //               "• Cash On Delivery: ₹670.0",
              //               style: TextStyle(fontSize: 14, color: Colors.black87),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }

}
