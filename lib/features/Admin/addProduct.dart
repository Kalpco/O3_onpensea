import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

import '../authentication/screens/login/Controller/LoginController.dart';  // For jsonEncode
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
  final TextEditingController imageController = TextEditingController();
  final loginController = Get.find<LoginController>();
  bool isLoading = false;

  // Dropdown selected values
  String? selectedProductCategory;
  String? selectedSubCategory;
  String? selectedDiamondType;

  // List of Product Categories and Sub Categories
  final List<String> productCategories = ['Custom', 'Diamond'];
  final List<String> subCategories = ['Ring', 'Necklace','Pendant','Earing','Bracelet','Bangle','Chain'];
  final List<String> diamondTypeCategories = ['Lab Grown', 'Natural Diamond'];

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
        int userId = loginController.userData['userId'];
        final url = Uri.parse('${ApiConstants.PRODUCTS_BASE_URL}/merchant/$userId/M/catalog');
        final request = http.MultipartRequest('POST', url);

        request.fields['productName'] = productName.text;
        request.fields['productDescription'] = productDescription.text;
        request.fields['productOwnerName'] = productOwnerName.text;
        request.fields['productCategory'] = selectedProductCategory!;
        request.fields['productSubCategory'] = selectedSubCategory!;
        request.fields['productSize'] = productSize.text;
        request.fields['productWeight'] = productWeight.text;
        request.fields['purity'] = purity.text;
        request.fields['productPrice'] = productPrice.text;
        request.fields['productQuantity'] = productQuantity.text;
        request.fields['productMakingChargesPercentage'] = productMakingChargesPercentage.text;
        //For gems DTO
        Map<String, dynamic> gems = {
          'noOfSmallStones': noOfSmallStones.text,
          'weightOfSmallStones': weightOfSmallStones.text,
          'clarityOfSolitareDiamond': clarityOfSolitareDiamond.text,
          'typeOfStone': selectedDiamondType,
        };
        request.fields['gemsDTO'] = jsonEncode(gems);

        if (selectedImages != null) {
          for (File image in selectedImages) {
            request.files.add(
                await http.MultipartFile.fromPath('productImageUri', image!.path));
          }
        }

        final response = await request.send();
        setState(() {
          isLoading = false;
        });
        if (response.statusCode == 201)
        {
          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully'),backgroundColor: Colors.green),
          );
        }
      }
      catch (e) {
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

    // Clear the dropdown selections (assuming they are nullable strings)
    setState(() {
      selectedProductCategory = null;
      selectedSubCategory = null;
      selectedDiamondType = null;
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
                if(selectedProductCategory !='Diamond')
                SizedBox(height: 16.0),
                if(selectedProductCategory !='Diamond')
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
