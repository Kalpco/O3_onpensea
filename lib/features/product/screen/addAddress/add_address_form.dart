import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';
import 'dart:convert';

import '../../../../network/dio_client.dart';
import '../../../../utils/constants/colors.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';

class AddAddressForm extends StatefulWidget {
  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final _formKey = GlobalKey<FormState>();
  String? city, state, pincode, address, mobileNo,email,name,fatherName,lastName;
  final loginController = Get.find<LoginController>();

  Future<void> _addAddress() async {
    try {
      int userId = loginController.userData['userId'];
      final dio = DioClient.getInstance();

      final response = await dio.post(
        "${ApiConstants.USERS_URL}/Address/$userId",
        data: {
          "city": city,
          "pinCode": pincode,
          "state": state,
          "address": address,
          "mobileNo": mobileNo,
          "email": email,
          "name": name,
          "fatherName": fatherName,
          "lastName": lastName
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        // Successfully added the address
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address added successfully'),
            backgroundColor: Colors.green,),
        );
        Navigator.pop(context); // Close the modal
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add address. Please try again.'),
              backgroundColor: Colors.red),
        );
      }
    }
    catch(addressException){
      print("❌ Address add error: $addressException");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add address. Please try again.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) => name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: 'Middle Name'),
              onSaved: (value) => fatherName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the middle name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
              onSaved: (value) => lastName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the last name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: 'State'),
              onSaved: (value) => state = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the state';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: 'City'),
              onSaved: (value) => city = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the city';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
                maxLength: 6,
              decoration: InputDecoration(labelText: 'Pincode'),
              onSaved: (value) => pincode = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the pincode';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              onSaved: (value) => address = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the address';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(labelText: 'Mobile No'),
              onSaved: (value) => mobileNo = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the mobile number';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addAddress(); // Call the function to send the data to the API
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: U_Colors.chatprimaryColor,
                  side: BorderSide.none,
                ),
                child: Text('Add Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
