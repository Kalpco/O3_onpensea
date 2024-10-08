import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';  // For jsonEncode
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


  // Dropdown selected values
  String? selectedProductCategory;
  String? selectedSubCategory;
  String? selectedDiamondType;

  // List of Product Categories and Sub Categories
  final List<String> productCategories = ['Gold', 'Diamond'];
  final List<String> subCategories = ['Ring', 'Necklace'];
  final List<String> diamondTypeCategories = ['Lab-Grown', 'Natural'];

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
        final url = Uri.parse(
            'http://172.16.16.28:11002/products/kalpco/v1.0.0/products/merchant/2/M/catalog');
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
        Map<String, dynamic> gemsDTO = {
          'noOfSmallStones': noOfSmallStones.text,
          'weightOfSmallStones': weightOfSmallStones.text,
          'clarityOfSolitareDiamond': clarityOfSolitareDiamond.text,
          'typeOfStone': selectedDiamondType,
        };
        request.fields['gemsDTO'] = jsonEncode(gemsDTO);

        if (selectedImages != null) {
          for (File image in selectedImages) {
            request.files.add(
                await http.MultipartFile.fromPath('productImageUri', image!.path));
          }
        }

        final response = await request.send();

        if (response.statusCode == 201)
        {
          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product Has Been Added Successfully')),
          );
        }
      }
      catch (e) {
        print('Error during registration: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during registration')),
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
      appBar: AppBar(
        title: Text('Add Product'),
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
                  controller: productPrice,
                  decoration: InputDecoration(
                    labelText: 'Product Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product Price';
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

                SizedBox(height: 16.0),
                // No. of Solitaires Field
                TextFormField(
                  controller: noOfSolitaires,
                  decoration: InputDecoration(
                    labelText: 'No. of Solitaires',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of solitaires';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // No. of Solitaires Field
                TextFormField(
                  controller: weightOfSmallStones,
                  decoration: InputDecoration(
                    labelText: 'Weight Of SmallStones',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the weight of smallstoness';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // No. of Solitaires Field
                TextFormField(
                  controller: clarityOfSolitareDiamond,
                  decoration: InputDecoration(
                    labelText: 'Clarity Of Solitare Diamond',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the clarity of solitare diamond';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Diamond Type Clarity',
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
                      ? 'Please select a diamond type clarity'
                      : null,
                ),
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
                    labelText: 'Photo',
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
                      onPressed: submitForm,
                      child: Text('Submit'),
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
