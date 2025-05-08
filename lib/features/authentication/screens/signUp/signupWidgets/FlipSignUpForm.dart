import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

import '../../../../../commons/config/api_constants.dart';
import '../../../../../commons/widgets/success_screen/success_screen.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../login/login.dart';

class FlipSignupForm extends StatefulWidget {
  final String title;
  final bool showEmail;

  const FlipSignupForm({required this.title, required this.showEmail});

  @override
  State<FlipSignupForm> createState() => _FlipSignupFormState();
}

class _FlipSignupFormState extends State<FlipSignupForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pincodeController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _companynameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _GSTNumberController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _isActiveController = TextEditingController();

  final List<String> _userTypes = ['User', 'Merchant', 'Factory'];
  String? _selectedUserType;

  final List<String> _genders = ['Male', 'Female'];
  String? _selectedGender;

  File? _image;
  bool isVerified = false;
  bool _isChecked = false;
  int? _generatedOtp;
  int? _enteredOtp;
  bool _isPasswordVisible = false;
  bool _checkboxError = false;
  bool showEmail = true;

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _firstNameController.dispose();
    // _fatherNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNoController.dispose();
    _addressController.dispose();
    _photoController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _companynameController.dispose();
    _GSTNumberController.dispose();
    _companyAddressController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final Random r = Random();
    int random = 100000 + r.nextInt(900000);
    setState(() {
      _generatedOtp = random;
    });

    final email = _emailController.text;
    final mobileNumber = _phoneNoController.text;
    print('email is $email');

    if (widget.showEmail) {
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter your email')),
        );
        return;
      }

      // Regex for email validation
      final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      if (!emailRegex.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid email')),
        );
        return;
      }

      final Uri emailOtpUrl = Uri.parse(ApiConstants.USER_REGISTERATION_OTP);
      print('Sending OTP to URL: $emailOtpUrl');

      final response = await http.post(
        emailOtpUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "name": _firstNameController.text.trim(),
          "otp": _generatedOtp.toString(),
        }),

      );
      print('response is ${response.statusCode}');
      print('response is ${response.body}');

      if (response.statusCode == 201) {
        _showOtpDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP to email')),
        );
      }
    } else {
      if (mobileNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter your mobile number')),
        );
        return;
      }
      // Check if mobile number is exactly 10 digits
      final mobileNumberRegex = RegExp(r'^[0-9]{10}$');
      if (!mobileNumberRegex.hasMatch(mobileNumber)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
        );
        return;
      }

      final smsUrl =
          'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=$random%20is%20your%20OTP%20for%20registering%20with%20Kalpco.For%20security%20reasons,%20do%20not%20share%20this%20OTP%20with%20anyone.&sendername=KLPCOP&smstype=TRANS&numbers=$mobileNumber&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707171801953849374';      final response = await http.get(Uri.parse(smsUrl));
      if (response.statusCode == 200) {
        _showOtpDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP to mobile')),
        );
      }
    }
  }


  // Future<void> _sendOTP() async {
  //   final mobileNumber = _phoneNoController.text;
  //   final email = _emailController.text;
  //
  //   final Random r = Random();
  //   int random = 100000 + r.nextInt(900000);
  //   setState(() {
  //     _generatedOtp = random;
  //   });
  //   print("Generated OTP: $random");
  //
  //   if (mobileNumber.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please enter your mobile number')),
  //     );
  //     return;
  //   }
  //
  //   final apiUrl =
  //       'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=$random%20is%20your%20OTP%20for%20registering%20with%20Kalpco.For%20security%20reasons,%20do%20not%20share%20this%20OTP%20with%20anyone.&sendername=KLPCOP&smstype=TRANS&numbers=$mobileNumber&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707171801953849374';
  //
  //   final response = await http.get(Uri.parse(apiUrl));
  //   if (response.statusCode == 200) {
  //     _showOtpDialog();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to send OTP')),
  //     );
  //   }
  // }

  Future<void> _verifyOTP() async {
    if (_enteredOtp == _generatedOtp) {
      setState(() {
        isVerified = true;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number verified successfully')),
      );
    } else {
      setState(() {
        isVerified = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Enter OTP'),
        content: TextField(
          controller: _otpController,
          decoration: InputDecoration(hintText: 'OTP'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_otpController.text == _generatedOtp.toString()) {
                setState(() {
                  isVerified = true;
                });
                Navigator.of(context).pop(); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('OTP Verified')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid OTP')),
                );
              }
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }
  // void _showOtpDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Enter OTP'),
  //         content: TextField(
  //           keyboardType: TextInputType.number,
  //           onChanged: (value) {
  //             setState(() {
  //               _enteredOtp = int.tryParse(value);
  //             });
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               if (_enteredOtp != null) {
  //                 _verifyOTP();
  //               }
  //             },
  //             child: Text('Verify'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _register() async {
  //   setState(() {
  //     _checkboxError = !_isChecked; // Set error if not checked
  //   });
  //   if (_formKey.currentState!.validate()) {
  //     _isLoading.value = true;
  //     try {
  //       final url = Uri.parse('${ApiConstants.USER_REGISTER}');
  //       final request = http.MultipartRequest('POST', url);
  //       print(url);
  //       print(_emailController.text);
  //       print(_phoneNoController.text);
  //
  //
  //
  //
  //       request.fields['name'] = _firstNameController.text;
  //       // request.fields['fatherName'] = _fatherNameController.text;
  //       request.fields['lastName'] = _lastNameController.text;
  //       request.fields['email'] = _emailController.text;
  //       request.fields['password'] = _passwordController.text;
  //       request.fields['mobileNo'] = _phoneNoController.text;
  //       // request.fields['address'] = _addressController.text;
  //       request.fields['gender'] =
  //           _selectedGender != null ? _selectedGender![0] : '';
  //       request.fields['city'] = _cityController.text;
  //
  //       request.fields['pincode'] = _pincodeController.text;
  //
  //       request.fields['state'] = _stateController.text;
  //       request.fields['aadharNo'] = _aadharController.text;
  //       request.fields['panNo'] = _panController.text;
  //       request.fields['userType'] =
  //           _selectedUserType != null ? _selectedUserType![0] : '';
  //       request.fields['companyName'] = _companynameController.text;
  //       request.fields['gstNumber'] = _GSTNumberController.text;
  //       request.fields['companyAddress'] = _companyAddressController.text;
  //       request.fields['isActive'] = "true";
  //       request.fields['isDeliverable'] = "n";
  //
  //       if (_image != null) {
  //         request.files
  //             .add(await http.MultipartFile.fromPath('photoUrl', _image!.path));
  //       }
  //
  //       final response = await request.send();
  //
  //       if (response.statusCode == 201) {
  //         Get.to(() => SuccessScreen());
  //       } else {
  //         final responseBody = await response.stream.bytesToString();
  //         final Map<String, dynamic> decodedBody = jsonDecode(responseBody);
  //         print("response body $responseBody");
  //         final String message = decodedBody['message'] ?? 'Something went wrong';
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(message)),
  //         );
  //
  //       }
  //     } catch (e) {
  //       print('Error during registration: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('An error occurred during registration')),
  //       );
  //     } finally {
  //       _isLoading.value = false;
  //     }
  //   }
  // }

  Future<void> _register() async {
    setState(() {
      _checkboxError = !_isChecked; // Set error if not checked
    });
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;
      try {
        final url = Uri.parse('${ApiConstants.USER_REGISTER}');
        final request = http.MultipartRequest('POST', url);
        print(url);
        final email = _emailController.text.trim();
        final mobile = _phoneNoController.text.trim();
        print('email $email');
        print('mobile $mobile');

        request.fields['name'] = _firstNameController.text;
        request.fields['lastName'] = _lastNameController.text;
        request.fields['password'] = _passwordController.text;
        request.fields['userType'] ='U';
        request.fields['isActive'] = "true";
        request.fields['isDeliverable'] = "Y";
        if (email.isNotEmpty) {
          request.fields['email'] = email;
        } else {
          request.fields['mobileNo'] = mobile;
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        print("response body $decoded");

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decoded['message'] ?? 'Registration successful'),backgroundColor: Colors.green),
          );
          Get.to(() => SuccessScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decoded['message'] ?? 'Registration failed'),backgroundColor: Colors.red,),
          );

        }
      } catch (e) {
        print('Error during registration: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during registration')),
        );
      } finally {
        _isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      margin: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name',prefixIcon: Icon(Iconsax.user),),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name',prefixIcon: Icon(Iconsax.user),),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // Toggle password visibility
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 4) {
                    return 'Password must be at least 4 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: widget.showEmail ? _emailController : _phoneNoController,
                onChanged: (_) {
                  setState(() {
                    isVerified = false;
                  });
                },
                decoration: InputDecoration(
                  labelText: widget.showEmail ? 'Email' : 'Mobile Number',
                  prefixIcon: Icon(widget.showEmail ? Icons.mail : Iconsax.call),
                  suffixIcon: OutlinedButton(
                    onPressed: _sendOTP,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(0, 0),
                      side: BorderSide(
                        color: isVerified ? Colors.green : Colors.grey.shade500,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      isVerified ? 'Verified' : 'Verify',
                      style: TextStyle(
                        color: isVerified ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                keyboardType: widget.showEmail
                    ? TextInputType.emailAddress
                    : TextInputType.number,
                inputFormatters: widget.showEmail
                    ? null
                    : [FilteringTextInputFormatter.digitsOnly], // 👈 Add this line
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ${widget.showEmail ? "email" : "phone number"}';
                  } else if (widget.showEmail) {
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }else if (!isVerified) {
                      return 'Email not verified';
                    }
                  } else {
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    } else if (!isVerified) {
                      return 'Phone number not verified';
                    }
                  }
                  return null;
                },
              ),

              // widget.showEmail
              //     ? TextFormField(
              //         controller: _emailController,
              //         decoration: InputDecoration(labelText: 'Email',prefixIcon: Icon(Icons.mail),),
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Please enter your email';
              //           } else if (!RegExp(
              //                   r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
              //               .hasMatch(value)) {
              //             return 'Please enter a valid email address';
              //           }
              //           return null;
              //         },
              //       )
              //     : TextFormField(
              //         controller: _phoneNoController,
              //         decoration: InputDecoration(labelText: 'Mobile Number',prefixIcon: Icon(Iconsax.call),),
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Please enter your phone number';
              //           } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
              //             return 'Please enter a valid 10-digit phone number';
              //           } else if (!isVerified) {
              //             return 'Phone number not verified';
              //           }
              //           return null;
              //         },
              //       ),
              // Positioned(
              //   right: 10,
              //   top: 50,
              //   child: OutlinedButton(
              //     onPressed: _sendOTP,
              //     style: OutlinedButton.styleFrom(
              //       side: isVerified
              //           ? BorderSide.none
              //           : BorderSide(
              //               color: isVerified
              //                   ? Colors.green
              //                   : Colors.grey.shade500,
              //               width: 2.0,
              //             ),
              //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5.0),
              //       ),
              //     ),
              //     child: Text(
              //       isVerified ? 'Verified' : 'Verify Now',
              //       style: TextStyle(
              //           color: isVerified ? Colors.green : Colors.red,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 12),
              //     ),
              //   ),
              // ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      activeColor: U_Colors.yaleBlue,
                      value: _isChecked, // Use the state variable
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                          _checkboxError = false; // Update the state variable
                        });
                      },
                    ),
                  ),

                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: '${U_TextStrings.agree}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: U_TextStrings.privacyPolicy,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          // color: dark ? Colors.white : U_Colors.yaleBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: '${U_TextStrings.and}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: U_TextStrings.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                          // color: dark ? Colors.white : U_Colors.yaleBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              if (_checkboxError)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'You must agree to the terms and conditions',
                        style: TextStyle(color: U_Colors.yaleBlue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: U_Colors.yaleBlue,
                      disabledBackgroundColor: U_Colors.yaleBlue,side: BorderSide(color: U_Colors.yaleBlue)),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (context, isLoading, child) {
                      if (isLoading) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else {
                        return Text(
                          U_TextStrings.createAccount,
                          style: TextStyle(color: U_Colors.whiteColor),
                        );
                      }
                    },
                  ),
                  onPressed: _register,
                ),
              ),
              TextButton(onPressed: (){Get.to(() => const LoginScreen());}, child: Text(
                "Already a customer? Login",
                style: TextStyle(
                  color: U_Colors.yaleBlue,
                  decoration: TextDecoration.underline,
                  fontSize: 14
                ),
              ),)
              // ElevatedButton(onPressed: _register, child: Text('Sign Up'))
            ],
          ),
        ),
      ),
    );
  }
}
