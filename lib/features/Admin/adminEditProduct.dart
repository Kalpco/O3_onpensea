import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/features/Admin/adminHomeScreen.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/utils/constants/colors.dart';
import '../../commons/config/api_constants.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

import '../../navigation_menu.dart';

class AdminEditProduct extends StatefulWidget {
  AdminEditProduct({super.key, required this.product});
  ProductResponseDTO product;

  @override
  AdminEditProductFormState createState() => AdminEditProductFormState();
}

class AdminEditProductFormState extends State<AdminEditProduct> {
  // Define form key for name of the form
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController goldWeight = TextEditingController();
  TextEditingController goldPurity = TextEditingController();
  TextEditingController noOfSmallStones = TextEditingController();
  TextEditingController productSize = TextEditingController();
  TextEditingController weightOfSmallStones = TextEditingController();
  TextEditingController clarityOfSolitareDiamond = TextEditingController();
  TextEditingController productCategory = TextEditingController();
  TextEditingController productSubCategory = TextEditingController();
  TextEditingController typeOfStone = TextEditingController();
  TextEditingController productOwnerName = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController productMakingChargesPercentage =
      TextEditingController();
   TextEditingController discountPercentage = TextEditingController();

  bool? productDiscountApplied;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product.productName);
    description = TextEditingController(text: widget.product.productDescription);
    goldWeight = TextEditingController(text: widget.product.productWeight?.toString() ?? '');
    productSize = TextEditingController(text: widget.product.productSize);
    goldPurity = TextEditingController(text: widget.product.purity.toString() ?? '');
    noOfSmallStones = TextEditingController(text: widget.product.gemsDTO?.noOfSmallStones?.toString() ?? '');
    weightOfSmallStones = TextEditingController(text: widget.product.gemsDTO?.weightOfSmallStones?.toString() ?? ' ');
    clarityOfSolitareDiamond = TextEditingController(text:widget.product.gemsDTO?.clarityOfSolitareDiamond?.toString() ?? '');
    productCategory = TextEditingController(text: widget.product.productCategory?.toString() ?? '');
    productSubCategory = TextEditingController(text: widget.product.productSubCategory);
    typeOfStone = TextEditingController(text: widget.product.gemsDTO?.typeOfStone?.toString() ?? ' ');
    productOwnerName = TextEditingController(text: widget.product.productOwnerName);
    productQuantity = TextEditingController(text: widget.product.productQuantity.toString() ?? '');
    productMakingChargesPercentage = TextEditingController(text: widget.product.productMakingChargesPercentage.toString() ?? '');
    productDiscountApplied =  widget.product.discountApplied;
    discountPercentage = TextEditingController(text: widget.product.discountPercentage.toString() ?? '');

  }

  //posting data to backend via this method
  Future<void> updateProduct() async {
    if (formKey.currentState!.validate()) {
      try {
        final url = Uri.parse(
            '${ApiConstants.PRODUCTS_BASE_URL}/merchant/${widget.product.productOwnerId}/catalog/${widget.product.id}');
        final request = http.MultipartRequest('PUT', url);
        request.fields['productCategory'] = productCategory.text;
        request.fields['productSubCategory'] = productSubCategory.text;
        request.fields['productName'] = name.text;
        request.fields['productDescription'] = description.text;
        request.fields['productSize'] = productSize.text;
        request.fields['productWeight'] = goldWeight.text;
        request.fields['purity'] = goldPurity.text;
        request.fields['productOwnerName'] = productOwnerName.text;
        request.fields['productQuantity'] = productQuantity.text;
        request.fields['productMakingChargesPercentage'] =
            int.tryParse(productMakingChargesPercentage.text) != null
                ? int.parse(productMakingChargesPercentage.text).toString()
                : '0';
        request.fields['discountApplied'] = (productDiscountApplied ?? false).toString();
        request.fields['discountPercentage'] =
        int.tryParse(discountPercentage.text) != null
            ? int.parse(discountPercentage.text).toString()
            : '0';//For gems DTO

        // Create the gemsDTO object
        Map<String, dynamic> gems = {
          'noOfSmallStones': noOfSmallStones.text,
          'weightOfSmallStones': weightOfSmallStones.text,
          'clarityOfSolitareDiamond': clarityOfSolitareDiamond.text,
        };
        request.fields['gemsDTO'] = jsonEncode(gems);

        // gemsDTO added for post method

        // Send the request
        final response = await request.send();
        print("response: $response");
        if (response.statusCode == 201) {
          // Show a snackbar or dialog after submission
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Product Has Been Updated Successfully'),
              backgroundColor: Colors.green));
          Get.offAll(() => NavigationMenu());
        } else {
          final responseBody = await response.stream.bytesToString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong: $responseBody')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during product edit')),
        );
      }

      // can clear the fields after submission if needed.
      // resetForm();
    }
  }

  void resetForm() {
    name.clear();
    description.clear();
    goldWeight.clear();
    goldPurity.clear();
    productSize.clear();
    noOfSmallStones.clear();
    weightOfSmallStones.clear();
    clarityOfSolitareDiamond.clear();
    setState(() {});
  }

  // Clean up the controllers when the widget is disposed
  @override
  void dispose() {
    name.dispose();
    description.dispose();
    goldWeight.dispose();
    goldPurity.dispose();
    noOfSmallStones.dispose();
    productSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Edit Product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Product Category Dropdown
                SizedBox(height: 16.0),
                TextFormField(
                    controller: productCategory,
                    decoration: InputDecoration(
                      labelText: 'Product Category',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false),
                SizedBox(height: 16.0),
                TextFormField(
                    controller: productSubCategory,
                    decoration: InputDecoration(
                      labelText: 'Product SubCategory',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false),
                // Sub Category Dropdown
                if (productCategory.text != 'Custom') SizedBox(height: 16.0),
                Column(
                  children: [
                    if (productCategory.text != 'Custom')
                      TextFormField(
                          controller: typeOfStone,
                          decoration: InputDecoration(
                            labelText: 'Types Of Diamond',
                            border: OutlineInputBorder(),
                          ),
                          enabled: false),
                    if (productCategory.text != 'Custom')
                      SizedBox(height: 16.0),
                    if (productCategory.text != 'Custom')
                      TextFormField(
                        controller: noOfSmallStones,
                        decoration: InputDecoration(
                          labelText: 'No. Of Diamond',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of Diamond';
                          }
                          return null;
                        },
                      ),
                    if (productCategory.text != 'Custom')
                      SizedBox(height: 16.0),
                    if (productCategory.text != 'Custom')
                      TextFormField(
                        controller: weightOfSmallStones,
                        decoration: InputDecoration(
                          labelText: 'Weight Of Diamond',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the weight of Diamond';
                          }
                          return null;
                        },
                      ),
                    if (productCategory.text != 'Custom')
                      SizedBox(height: 16.0),
                    // Product Size Field
                    if (productCategory.text != 'Custom')
                      TextFormField(
                        controller: clarityOfSolitareDiamond,
                        decoration: InputDecoration(
                          labelText: 'Clarity Of Stones',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the clarity of stones';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 16.0),
                  ],
                ),
                SizedBox(height: 16.0),

                // Name Field
                TextFormField(
                  controller: name,
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
                  controller: description,
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
                  controller: goldWeight,
                  decoration: InputDecoration(
                    labelText: 'Gold Weight (grams)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: goldPurity,
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
                TextFormField(
                  controller: productOwnerName,
                  decoration: InputDecoration(
                    labelText: 'Product Owner Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please update product owner name';
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
                      return 'Please update product Quantity';
                    }
                    return null;
                  },
                ),
                if (productCategory.text == 'Custom') SizedBox(height: 16.0),
                if (productCategory.text == 'Custom')
                  TextFormField(
                    controller: productMakingChargesPercentage,
                    decoration: InputDecoration(
                      labelText: 'Product Making Charges Percentage',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please update making charges percentage';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,2}$')), // Allow only two digits
                    ],
                  ),
                if (productCategory.text == 'Diamond') SizedBox(height: 16.0),
                if (productCategory.text == 'Diamond')
                  TextFormField(
                    controller: productMakingChargesPercentage,
                    decoration: InputDecoration(
                      labelText: 'Product Making Charges Percentage',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please update making charges percentage';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,2}$')), // Allow only two digits
                    ],
                  ),


                SizedBox(height: 16.0),
                TextFormField(
                  controller: productSize,
                  decoration: InputDecoration(
                    labelText: 'Product Size',
                    border: OutlineInputBorder(),
                    // prefixIcon: IconButton(
                    //       icon: Icon(Iconsax.size), onPressed: () {  }, )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product size';
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
                  value: productDiscountApplied,
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
                      productDiscountApplied = newValue;
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
                if (productDiscountApplied == true)
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

                SizedBox(height: 15.0),
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
                            backgroundColor: U_Colors.satinSheenGold,
                            side: BorderSide.none,
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 35.0),
                            minimumSize: Size(120, 38),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: updateProduct,
                      child: Text('Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: U_Colors.yaleBlue,
                        side: BorderSide.none,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 35.0),
                        minimumSize: Size(120, 38),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
