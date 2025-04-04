import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../network/dio_client.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/colors.dart';
import 'package:onpensea/commons/config/api_constants.dart' as API_CONSTANTS_1;

import '../../authentication/screens/login/Controller/LoginController.dart';

class OrderDetailsPage extends StatefulWidget {
  final dynamic productList;
  int? userId, transactionId, addressId;
  String transactionOrderId;
  OrderDetailsPage(
      {super.key,
      required this.productList,
      required this.userId,
      required this.transactionId,
      required this.addressId,
      required this.transactionOrderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool isLoading = false; // For showing the loader
  final dio = DioClient.getInstance();

  Future<void> downloadInvoice() async {
    setState(() {
      isLoading = true; // Show the loader
    });
    try {
      String apiUrl =
          "${API_CONSTANTS_1.ApiConstants.INVOICE_DOWNLOAD}/user/${widget.userId}/transaction/${widget.transactionId}/addressId/${widget.addressId}";
      Response response = await dio.get(
        apiUrl,
        options: Options(
          responseType: ResponseType.bytes, // Ensure response is raw bytes
        ),
      );
      Directory? directory = Directory('/storage/emulated/0/Download');
      // directory = await getExternalStorageDirectory();
      String filePath =
          "${directory!.path}/Kalpco_Invoice_${widget.transactionOrderId}.pdf";
      print('invoice path : $filePath');
      File file = File(filePath);
      await file.writeAsBytes(response.data);

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice successfully downloaded to $filePath'),
          backgroundColor: Colors.green,
        ),
      );
    }on DioException catch (e){
      print("exception: $e" );
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to download invoice: $e'),
            backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide the loader
      });
    }
  }


  final Map<String, Uint8List> _imageCache = {};

  Future<Uint8List?> fetchImageWithToken(String url) async {
    if (_imageCache.containsKey(url)) {
      return _imageCache[url]; // ✅ Return cached image if available
    }

    try {
      final dio = DioClient.getInstance(); // ✅ Use your Dio instance with token
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final imageBytes = Uint8List.fromList(response.data!);
      _imageCache[url] = imageBytes; // ✅ Store image in cache
      return imageBytes;
    } catch (e) {
      print("❌ Image loading error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: U_Colors.yaleBlue,
          title: Text(
            'Order Details',
            style: TextStyle(color: Colors.white),
          ),
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
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                //new
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.productList.length,
                  itemBuilder: (context, index) {
                    final productDetail = widget.productList[index];
                    final imageUrl =
                        "${ApiConstants.baseUrl}${productDetail['productPic']}";
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
                                ? FutureBuilder<Uint8List?>(
                              future: fetchImageWithToken(imageUrl),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator(color: U_Colors.yaleBlue,));
                                } else if (snapshot.hasError || snapshot.data == null) {
                                  return const Icon(Icons.error, color: Colors.red, size: 50);
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                                  );
                                }
                              },
                            )
                                : const Icon(
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
                                  productDetail['productName'] ??
                                      'Product Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                            Text(
                              'Invoice download',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        // Icon(Icons.arrow_forward, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (isLoading)
        Positioned.fill(
          child: Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(U_Colors.yaleBlue),
              ),
            ),
          ),
        ),
    ]);
  }
}
