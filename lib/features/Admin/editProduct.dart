import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/features/Admin/ProductRequestDTO.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/utils/constants/colors.dart';
import '../../commons/config/api_constants.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;




class Productedit extends StatefulWidget {

  Productedit({super.key, required this.product});
  ProductResponseDTO product;


  @override
  AddProductFormState createState() => AddProductFormState();
}
class AddProductFormState extends State<Productedit> {

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



  TextEditingController imagesControllers = TextEditingController();
  List<File> selectedImages = []; //to store iamge via file type
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product.productName);
    description=TextEditingController(text: widget.product.productDescription);
    goldWeight=TextEditingController(text: widget.product.productWeight?.toString() ??'');
    productSize=TextEditingController(text: widget.product.productSize);
    goldPurity=TextEditingController(text: widget.product.purity.toString()?? '');
    noOfSmallStones=TextEditingController(text: widget.product.gemsDTO?.noOfSmallStones?.toString()?? '');
    weightOfSmallStones=TextEditingController(text: widget.product.gemsDTO?.weightOfSmallStones?.toString()?? ' ');
    clarityOfSolitareDiamond=TextEditingController(text: widget.product.gemsDTO?.clarityOfSolitareDiamond?.toString()??'');
    productCategory=TextEditingController(text: widget.product.productCategory?.toString()??'');
    productSubCategory=TextEditingController(text: widget.product.productSubCategory);
    typeOfStone=TextEditingController(text: widget.product.gemsDTO?.typeOfStone?.toString()?? ' ');
  }




  //posting data to backend via this method
  Future<void> addProduct() async {
    if (formKey.currentState!.validate()) {
      try {
        final url = Uri.parse(
            'http://172.16.17.26:11002/products/kalpco/v1.0.0/products/merchant/1/M/catalog');
        final request = http.MultipartRequest('PUT', url);
        //  http://o3uat.kalpco.in/products/kalpco/v1.0.0/products/merchant/5/U/catalog?typeOfStone=La
        // Add form fields and coverting to key value format
        request.fields['productOwnerName'] = 'ganesh';
        request.fields['productName'] = name.text;
        request.fields['productDescription'] = description.text;
      //  request.fields['productCategory'] = selectedProductCategory!;
       // request.fields['productSubCategory'] = selectedSubCategory!;
        request.fields['productSize'] = productSize.text;
        request.fields['productWeight'] = goldWeight.text;
        request.fields['goldPurity'] = goldPurity.text;
        request.fields['isActive'] = 'true';
        request.fields['productQuantity'] = '100'; // Convert integers to string




        // Create the gemsDTO object
        // var gemsDTO = {
        //   "typeOfStone": selectedTypeOfStone,
        //   "noOfSmallStones": noOfSmallStones.text,
        //   "weightOfSmallStones": weightOfSmallStones.text,
        //   "clarityOfSolitareDiamond": clarityOfSolitareDiamond.text
        // };

        //gemsDTO added for post method
     //   request.fields['gemsDTO'] = jsonEncode(gemsDTO);




        // Handle file upload
        if (selectedImages.isNotEmpty) {
          for (var imageFile in selectedImages) {
            if (await imageFile.exists()) {
              request.files.add(
                await http.MultipartFile.fromPath(
                    'productImageUri', imageFile.path),
              );
            }
          }
        }
        // Send the request
        final response = await request.send();
        print("response: $response");
        if (response.statusCode == 201) {
          // Show a snackbar or dialog after submission
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Product Has Been Added Successfully'),
              backgroundColor: Colors.green));
        } else {
          final responseBody = await response.stream.bytesToString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong: $responseBody')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during product add')),
        );
      }


      // can clear the fields after submission if needed.
     // resetForm();

    }

  }
  void resetForm(){
    name.clear();
    description.clear();
    goldWeight.clear();
    goldPurity.clear();
    productSize.clear();
    imagesControllers.clear();
    noOfSmallStones.clear();
    weightOfSmallStones.clear();
    clarityOfSolitareDiamond.clear();
    setState(() {
    });
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
        title: Text('Product Details'),
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
                TextFormField(
                  controller: productCategory,
                  decoration: InputDecoration(
                    labelText: 'Product Category',
                    border: OutlineInputBorder(),
                  ), enabled: false
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: productSubCategory,
                  decoration: InputDecoration(
                    labelText: 'Product SubCategory',
                    border: OutlineInputBorder(),
                  ), enabled: false
                ),
                // Sub Category Dropdown
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
                SizedBox(height: 16.0),
                  Column(
                    children: [
                      TextFormField(
                        controller: typeOfStone,
                        decoration: InputDecoration(
                          labelText: 'Types Of Stone',
                          border: OutlineInputBorder(),
                        ),enabled: false
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: noOfSmallStones,
                        decoration: InputDecoration(
                          labelText: 'No. of Stones',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of stones';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: weightOfSmallStones,
                        decoration: InputDecoration(
                          labelText: 'Weight Of Stones',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the weight of stones';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      // Product Size Field
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
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 35.0),
                            minimumSize: Size(120, 38),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: addProduct,
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
