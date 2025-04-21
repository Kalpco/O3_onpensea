import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio; // Prefix 'dio' to avoid conflicts
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile; // Hiding conflicting classes
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:flutter/services.dart';

import '../../../network/dio_client.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';


class AddCustomProduct extends StatefulWidget {
  @override
  AddProductFormState createState() => AddProductFormState();
}

class AddProductFormState extends State<AddCustomProduct> {
  // Define form key for name of the form
  final formKey = GlobalKey<FormState>();

  final TextEditingController productType = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final loginController = Get.find<LoginController>();
  bool isLoading = false;


  String? selectedSubCategory;

  final List<String> subCategories = ['Ring', 'Necklace','Pendant','Earing','Bracelet','Bangle','Chain'];


  //For to get images from phone
  List<File> selectedImages = [];
  final picker = ImagePicker();
  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    setState(
          () {
        selectedImages.clear();// To clear previous image
        List<String> imageNames = []; //To get images name
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
            imageNames.add(xfilePick[i].name);
          }
          imageController.text = imageNames.join(', '); // Join names with commas
        }
        // else {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Nothing is selected'),
        //     backgroundColor: Colors.lightBlueAccent,
        //   ));
        // }
      },
    );
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate())
    {
      try {
        setState(() {
          isLoading = true; // Show loader
        });
        final dioClient = DioClient.getInstance();
        int userId = loginController.userData['userId'];
       String userType = loginController.userData['userType'];
        final String url = '${ApiConstants.PRODUCTS_BASE_URL}/merchant/$userId/$userType/customized';
        print("url -> ${url}");

        dio.FormData formData = dio.FormData();
        formData.fields.addAll([
          MapEntry('productType', productType.text),
          MapEntry('productSubCategory', selectedSubCategory!),
        ]);

        if (selectedImages.isNotEmpty) {
          for (File image in selectedImages) {
            formData.files.add(
              MapEntry(
                'customizedImageUrl[]',
                await dio.MultipartFile.fromFile(image.path),
              ),
            );
          }
        }
        print("form data ${formData.fields}");

        final response = await dioClient.post(url, data: formData);
        setState(() {
          isLoading = false;
        });
        print("product response - ${response.data}");
        if (response.statusCode == 201)
        {
          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully'),backgroundColor: Colors.green),
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add product: ${response.statusMessage}')),
          );
        }
      }
      catch (e) {
        if (e is dio.DioException) {
          print('Backend Error: ${e.response?.data}');
        }
        print('Error occured during adding product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to add product')),
        );
      }
    }
  }



  void clearFields() {

    productType.clear();
    imageController.clear();
    setState(() {
      selectedSubCategory = null;

    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Add Product'),
      // ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add Custom Product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                // Sub Category Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Sub Category',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedSubCategory,
                  items: subCategories.map((subCategory) {
                    return DropdownMenuItem<String>(
                      value: subCategory,
                      child: Text(subCategory),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubCategory = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a sub category' : null,
                ),
                SizedBox(height: 16.0),

                // Name Field
                TextFormField(
                  controller: productType,
                  decoration: InputDecoration(
                    labelText: 'Product Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                TextFormField(
                  controller: imageController,
                  decoration: InputDecoration(
                    labelText: 'Product Images',
                    prefixIcon: IconButton(
                      icon: Icon(Iconsax.image),
                      onPressed: getImages,
                    ),
                  ),
                  readOnly: true, // Make the field read-only
                  showCursor: true, // Allow the cursor to be visible
                  enableInteractiveSelection: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please upload product images';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0,),

                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide.none,
                            backgroundColor: U_Colors.satinSheenGold,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 18.0),
                            minimumSize: Size(120, 38),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isLoading ? null : submitForm,
                      child:isLoading ?
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ): Text('Add Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: U_Colors.yaleBlue,
                        side: BorderSide.none,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 18.0),
                        minimumSize: Size(120, 38),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
