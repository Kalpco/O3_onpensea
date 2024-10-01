import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  AddProductFormState createState()  => AddProductFormState();
}

class AddProductFormState extends State<AddProduct> {
  // Define form key for name of the form
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController goldWeight = TextEditingController();
  final TextEditingController goldPurity = TextEditingController();
  final TextEditingController noOfSolitaires = TextEditingController();
  final TextEditingController productSize = TextEditingController();

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
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Nothing is selected'),
            backgroundColor: Colors.green,
          ));
        }
      },
    );
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      print("Product Category: $selectedProductCategory");
      print("Sub Category: $selectedSubCategory");
      print("Name: ${name.text}");
      print("Description: ${description.text}");
      print("Gold Weight: ${goldWeight.text}");
      print("No. of Solitaires: ${noOfSolitaires.text}");
      print("Gold Purity: ${goldPurity.text}");
      print("Diamond Type: $selectedDiamondType");
      print("Product Size: ${productSize.text}");

      // can clear the fields after submission if needed.
      name.clear();
      description.clear();
      goldWeight.clear();
      goldPurity.clear();
      noOfSolitaires.clear();
      productSize.clear();

      setState(() {
        selectedProductCategory = null;
        selectedSubCategory = null;
        selectedDiamondType = null;
      });

      // Show a snackbar or dialog after submission
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product Has Been Added Successfully')));
    }
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
                TextFormField(
                  controller: productSize,
                  decoration: InputDecoration(
                    labelText: 'Product Size',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product size';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: 500,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green)),
                    child: const Text('Select images from gallery',
                        style: TextStyle(
                          fontSize:
                              18, // Increase the font size to make the text larger
                          fontWeight:
                              FontWeight.bold, // Optional: Make text bold
                        )),
                    onPressed: getImages, // Calls the getImages function
                  ),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
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
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
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

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    name.dispose();
    description.dispose();
    goldWeight.dispose();
    goldPurity.dispose();
    noOfSolitaires.dispose();
    productSize.dispose();
    super.dispose();
  }
}
