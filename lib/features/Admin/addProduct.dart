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
import '../../network/dio_client.dart';
import '../authentication/screens/login/Controller/LoginController.dart';

class AddProduct extends StatefulWidget {
  @override
  AddProductFormState createState() => AddProductFormState();
}

class AddProductFormState extends State<AddProduct> {
  // Define form key for name of the form
  final formKey = GlobalKey<FormState>();

  final TextEditingController productName = TextEditingController();
  final TextEditingController productDescription = TextEditingController();
  final TextEditingController productWeight = TextEditingController();
  final TextEditingController purity = TextEditingController();
  final TextEditingController noOfSolitaires = TextEditingController();
  final TextEditingController productSize = TextEditingController();
  final TextEditingController productOwnerName = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productQuantity = TextEditingController();
  final TextEditingController noOfSmallStones = TextEditingController();
  final TextEditingController weightOfSmallStones = TextEditingController();
  final TextEditingController clarityOfSolitareDiamond = TextEditingController();
  final TextEditingController productMakingChargesPercentage = TextEditingController();
  final TextEditingController discountPercentage = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final loginController = Get.find<LoginController>();
  bool isLoading = false;

  // Dropdown selected values
  String? selectedProductCategory;
  String? selectedSubCategory;
  String? selectedDiamondType;
  bool? selectedDiscountApplied;

  // List of Product Categories and Sub Categories
  final List<String> productCategories = ['Custom', 'Diamond'];
  final List<String> subCategories = ['Ring', 'Necklace','Pendant','Earing','Bracelet','Bangle','Chain'];
  final List<String> diamondTypeCategories = ['Natural Diamond'];

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

  // Future<void> submitForm() async {
  //   if (formKey.currentState!.validate()) {
  //     try {
  //       setState(() {
  //         isLoading = true; // Show loader
  //       });
  //
  //       final dio = DioClient.getInstance();
  //       int userId = loginController.userData['userId'];
  //       final String url = '${ApiConstants.PRODUCTS_BASE_URL}/merchant/$userId/M/catalog';
  //
  //       FormData formData = FormData.fromMap({
  //         'productName': productName.text,
  //         'productDescription': productDescription.text,
  //         'productOwnerName': productOwnerName.text,
  //         'productCategory': selectedProductCategory!,
  //         'productSubCategory': selectedSubCategory!,
  //         'productSize': productSize.text,
  //         'productWeight': productWeight.text,
  //         'purity': purity.text,
  //         'productPrice': productPrice.text,
  //         'productQuantity': productQuantity.text,
  //         'productMakingChargesPercentage': productMakingChargesPercentage.text,
  //         'discountApplied': (selectedDiscountApplied ?? false).toString(),
  //         'discountPercentage': discountPercentage.text,
  //         'gemsDTO[noOfSmallStones]': noOfSmallStones.text,
  //         'gemsDTO[weightOfSmallStones]': weightOfSmallStones.text,
  //         'gemsDTO[clarityOfSolitareDiamond]': clarityOfSolitareDiamond.text,
  //         'gemsDTO[typeOfStone]': selectedDiamondType ?? '',
  //       });
  //
  //       // Attach images only if selectedImages is not null or empty
  //       if (selectedImages != null && selectedImages.isNotEmpty) {
  //         for (File image in selectedImages) {
  //           formData.files.add(
  //             MapEntry(
  //               'productImageUri',
  //               await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
  //             ),
  //           );
  //         }
  //       }
  //
  //       final response = await dio.post(url, data: formData);
  //
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       if (response.statusCode == 201) {
  //         clearFields();
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Product added successfully'), backgroundColor: Colors.green),
  //         );
  //       } else {
  //         throw Exception('Failed to add product. Status Code: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       print('Error occurred during adding product: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Unable to add product. Please try again!')),
  //       );
  //     }
  //   }
  // }


  Future<void> submitForm() async {
    if (formKey.currentState!.validate())
    {
      try {
        setState(() {
          isLoading = true; // Show loader
        });
        final dioClient = DioClient.getInstance();
        int userId = loginController.userData['userId'];
        final String url = '${ApiConstants.PRODUCTS_BASE_URL}/merchant/$userId/M/catalog';
        print("url -> ${url}");

        dio.FormData formData = dio.FormData();
        formData.fields.addAll([
          MapEntry('productName', productName.text),
          MapEntry('productDescription', productDescription.text),
          MapEntry('productOwnerName', productOwnerName.text),
          MapEntry('productCategory', selectedProductCategory!),
          MapEntry('productSubCategory', selectedSubCategory!),
          MapEntry('productSize', productSize.text),
          MapEntry('productWeight', productWeight.text),
          MapEntry('purity', purity.text),
          MapEntry('productPrice', productPrice.text),
          MapEntry('productQuantity', productQuantity.text),
          MapEntry('productMakingChargesPercentage', productMakingChargesPercentage.text),
          MapEntry('discountApplied', (selectedDiscountApplied ?? false).toString()),
          MapEntry('discountPercentage', discountPercentage.text)
        ]);
        Map<String, dynamic> gemsData = {
          "noOfSmallStones": noOfSmallStones.text.isEmpty ? "0" : noOfSmallStones.text,
          "weightOfSmallStones": weightOfSmallStones.text.isEmpty ? "0.0" : weightOfSmallStones.text,
          "clarityOfSolitareDiamond": clarityOfSolitareDiamond.text.isEmpty ? "NA" : clarityOfSolitareDiamond.text,
          "typeOfStone": selectedDiamondType ?? "NA",
        };

        formData.fields.add(MapEntry('gemsDTO', jsonEncode(gemsData)));

        if (selectedImages.isNotEmpty) {
          for (File image in selectedImages) {
            formData.files.add(
              MapEntry(
                'productImageUri[]',
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
    // Clear gemsDTO-related fields
    noOfSmallStones.clear();
    weightOfSmallStones.clear();
    clarityOfSolitareDiamond.clear();

    //Clear remainning fields
    productName.clear();
    productDescription.clear();
    productWeight.clear();
    purity.clear();
    noOfSolitaires.clear();
    productSize.clear();
    productOwnerName.clear();
    productPrice.clear();
    productQuantity.clear();
    noOfSmallStones.clear();
    weightOfSmallStones.clear();
    clarityOfSolitareDiamond.clear();
    productMakingChargesPercentage.clear();
    imageController.clear();
    discountPercentage.clear();

    // Clear the dropdown selections (assuming they are nullable strings)
    setState(() {
      selectedProductCategory = null;
      selectedSubCategory = null;
      selectedDiamondType = null;
      selectedDiscountApplied = null;
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
          "Add Product",
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
                // Product Category Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Product Category',
                    // border: OutlineInputBorder(),
                  ),
                  value: selectedProductCategory,
                  items: productCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProductCategory = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a product category' : null,
                ),
                SizedBox(height: 16.0),

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
                  controller: productName,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Description Field
                TextFormField(
                  controller: productDescription,
                  decoration: InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Gold Weight Field
                TextFormField(
                  controller: productWeight,
                  decoration: InputDecoration(
                    labelText: 'Gold Weight ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter gold weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // Gold Purity Field
                TextFormField(
                  controller: purity,
                  decoration: InputDecoration(
                    labelText: 'Gold Purity (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter gold purity';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.0),
                // Gold Purity Field
                TextFormField(
                  controller: productOwnerName,
                  decoration: InputDecoration(
                    labelText: 'Product Owner Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product owner name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: productSize,
                  decoration: InputDecoration(
                    labelText: 'Product Size',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product size';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: productQuantity,
                  decoration: InputDecoration(
                    labelText: 'Product Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product Quantity';
                    }
                    return null;
                  },
                ),


                if(selectedProductCategory == null || selectedProductCategory == 'Custom' || selectedProductCategory == 'Diamond')
                SizedBox(height: 16.0),
                TextFormField(
                  controller: productMakingChargesPercentage,
                  decoration: InputDecoration(
                    labelText: 'Product Making Charges Percentage',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product making charges in percentage';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}$')), // Allow only two digits
                  ],
                ),

                if(selectedProductCategory !='Custom')
                SizedBox(height: 16.0),
                if(selectedProductCategory !='Custom')
                TextFormField(
                  controller: noOfSmallStones,
                  decoration: InputDecoration(
                    labelText: 'No. of Diamonds',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of diamonds';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // No. of Solitaires Field
                if(selectedProductCategory !='Custom')
                  TextFormField(
                  controller: weightOfSmallStones,
                  decoration: InputDecoration(
                    labelText: 'Weight of Diamond',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the weight of diamond';
                    }
                    return null;
                  },
                ),
                if(selectedProductCategory !='Custom')
                  SizedBox(height: 16.0),
                if(selectedProductCategory !='Custom')
                  TextFormField(
                  controller: clarityOfSolitareDiamond,
                  decoration: InputDecoration(
                    labelText: 'Clarity of Diamond',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the clarity of diamond';
                    }
                    return null;
                  },
                ),
                if(selectedProductCategory !='Custom')
                  SizedBox(height: 16.0),
                if(selectedProductCategory !='Custom')
                  DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Diamond Type ',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDiamondType,
                  items: diamondTypeCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDiamondType = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a diamond type'
                      : null,
                ),
                if(selectedProductCategory !='Custom')
                SizedBox(height: 16.0),
                // Product Size Field
                // SizedBox(
                //   width: 500,
                //   height: 50,
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(Colors.green)),
                //     child: const Text('Select images from gallery',
                //         style: TextStyle(
                //           fontSize:
                //               18, // Increase the font size to make the text larger
                //           fontWeight:
                //               FontWeight.bold, // Optional: Make text bold
                //         )),
                //     onPressed: getImages, // Calls the getImages function
                //   ),
                // ),
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
                      return 'Please select product images';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0,),
                DropdownButtonFormField<bool>(
                  decoration: InputDecoration(
                    labelText: 'Apply Discount ',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDiscountApplied,
                  // hint: Text('Apply Discount'),
                  items: [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Yes'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('No'),
                    ),
                  ],
                  onChanged: (bool? newValue) {
                    setState(() {
                      selectedDiscountApplied = newValue;
                      if (newValue == false) {
                        discountPercentage.text = '0';
                      }
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a discount option'
                      : null,
                ),
                SizedBox(height: 16),
                if (selectedDiscountApplied == true)
                  TextFormField(
                    controller: discountPercentage,
                    decoration: InputDecoration(
                      labelText: 'Discount Percentage %',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter discount percentage';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}$')),
                    ],
                  ),

                SizedBox(height: 25.0),

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

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    noOfSolitaires.dispose();
    productSize.dispose();
    super.dispose();
  }
}
