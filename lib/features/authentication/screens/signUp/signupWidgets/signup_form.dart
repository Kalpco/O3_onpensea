import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/commons/widgets/login_signup/form_divider.dart';
import 'package:onpensea/commons/widgets/login_signup/social_buttons.dart';
import 'package:onpensea/features/authentication/screens/signUp/verify_email.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import '../../../../../commons/widgets/success_screen/success_screen.dart';
import '../../login/login.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, required this.dark});

  final bool dark;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
    final mobileNumber = _phoneNoController.text;
    final Random r = Random();
    int random = 100000 + r.nextInt(900000);
    setState(() {
      _generatedOtp = random;
    });
    print("Generated OTP: $random");

    if (mobileNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your mobile number')),
      );
      return;
    }

    final apiUrl =
        'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=$random%20is%20your%20OTP%20for%20registering%20with%20Kalpco.For%20security%20reasons,%20do%20not%20share%20this%20OTP%20with%20anyone.&sendername=KLPCOP&smstype=TRANS&numbers=$mobileNumber&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707171801953849374';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      _showOtpDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _photoController.text = pickedFile.name;
      });
    }
  }

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
      builder: (context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _enteredOtp = int.tryParse(value);
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_enteredOtp != null) {
                  _verifyOTP();
                }
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;
      try {
        final url =
        Uri.parse('${ApiConstants.USERS_URL!}/users');
        final request = http.MultipartRequest('POST', url);
        print(url);
        request.fields['name'] = _firstNameController.text;
        // request.fields['fatherName'] = _fatherNameController.text;
        request.fields['lastName'] = _lastNameController.text;
        request.fields['email'] = _emailController.text;
        request.fields['password'] = _passwordController.text;
        request.fields['mobileNo'] = _phoneNoController.text;
        // request.fields['address'] = _addressController.text;
        request.fields['gender'] =
        _selectedGender != null ? _selectedGender![0] : '';
        request.fields['city'] = _cityController.text;

        request.fields['pincode'] = _pincodeController.text;

        request.fields['state'] = _stateController.text;
        request.fields['aadharNo'] = _aadharController.text;
        request.fields['panNo'] = _panController.text;
        request.fields['userType'] =
        _selectedUserType != null ? _selectedUserType![0] : '';
        request.fields['companyName'] = _companynameController.text;
        request.fields['gstNumber'] = _GSTNumberController.text;
        request.fields['companyAddress'] = _companyAddressController.text;
        request.fields['isActive'] = "true";
        request.fields['isDeliverable'] = "n";

        if (_image != null) {
          request.files
              .add(await http.MultipartFile.fromPath('photoUrl', _image!.path));
        }

        final response = await request.send();

        if (response.statusCode == 201) {
          Get.to(() => SuccessScreen());
        } else {
          final responseBody = await response.stream.bytesToString();
          print("Response : $responseBody");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $responseBody')),
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
    final dark = U_Helper.isDarkMode(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: U_TextStrings.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: U_Sizes.inputFieldSpaceBtw,
              ),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: U_TextStrings.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your father\'s name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: U_TextStrings.gender,
              prefixIcon: Icon(Icons.male_sharp),
            ),
            value: _selectedGender,
            items: _genders.map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: U_TextStrings.city,
              prefixIcon: Icon(Icons.location_city),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),




          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            controller: _pincodeController,
            decoration: const InputDecoration(
              labelText: U_TextStrings.pincode,
              prefixIcon: Icon(Icons.pin_drop),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your pincode';
              }
              return null;
            },
          ),






          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            controller: _stateController,
            decoration: const InputDecoration(
              labelText: U_TextStrings.state,
              prefixIcon: Icon(Iconsax.location),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your state';
              }
              return null;
            },
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: U_TextStrings.email,
              prefixIcon: Icon(Icons.mail),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible, // Toggle visibility based on state
            decoration: InputDecoration(
              labelText: U_TextStrings.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          Stack(
            children: [
              TextFormField(
                controller: _phoneNoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: U_TextStrings.phoneNo,
                  prefixIcon: Icon(Iconsax.call),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              Positioned(
                right: 12,
                top: 10,
                child: OutlinedButton(
                  onPressed: _sendOTP,
                  style: OutlinedButton.styleFrom(
                    side: isVerified
                        ? BorderSide.none
                        : BorderSide(
                      color: isVerified
                          ? Colors.green
                          : Colors.grey.shade500,
                      width: 2.0,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    isVerified ? 'Verified' : 'Verify Now',
                    style: TextStyle(
                        color: isVerified ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(
          //   height: U_Sizes.inputFieldSpaceBtw,
          // ),
          // TextFormField(
          //   controller: _addressController,
          //   decoration: const InputDecoration(
          //     labelText: U_TextStrings.address,
          //     prefixIcon: Icon(Iconsax.home),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your address';
          //     }
          //     return null;
          //   },
          // ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          // TextFormField(
          //   controller: _aadharController,
          //   decoration: const InputDecoration(
          //     labelText: U_TextStrings.aadhar,
          //     prefixIcon: Icon(Iconsax.card_tick),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your Aadhar';
          //     }
          //     return null;
          //   },
          // ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            controller: _panController,
            decoration: const InputDecoration(
              labelText: U_TextStrings.pan,
              prefixIcon: Icon(Iconsax.home),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Pan';
              }
              return null;
            },
          ),
          // const SizedBox(
          //   height: U_Sizes.inputFieldSpaceBtw,
          // ),
          // DropdownButtonFormField<String>(
          //   decoration: const InputDecoration(
          //     labelText: U_TextStrings.userType,
          //     prefixIcon: Icon(Iconsax.home),
          //   ),
          //   value: _selectedUserType,
          //   items: _userTypes.map((String userType) {
          //     return DropdownMenuItem<String>(
          //       value: userType,
          //       child: Text(userType),
          //     );
          //   }).toList(),
          //   onChanged: (newValue) {
          //     setState(() {
          //       _selectedUserType = newValue;
          //     });
          //   },
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please select a user type';
          //     }
          //     return null;
          //   },
          // ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          // TextFormField(
          //   controller: _companynameController,
          //   decoration: const InputDecoration(
          //     labelText: U_TextStrings.CompanyName,
          //     prefixIcon: Icon(Iconsax.home),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your CompanyName';
          //     }
          //     return null;
          //   },
          // ),
          // const SizedBox(
          //   height: U_Sizes.inputFieldSpaceBtw,
          // ),
          // TextFormField(
          //   controller: _GSTNumberController,
          //   decoration: const InputDecoration(
          //     labelText: U_TextStrings.GSTNumber,
          //     prefixIcon: Icon(Iconsax.home),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your GSTNumber';
          //     }
          //     return null;
          //   },
          // ),
          // const SizedBox(
          //   height: U_Sizes.inputFieldSpaceBtw,
          // ),
          // TextFormField(
          //   controller: _companyAddressController,
          //   decoration: const InputDecoration(
          //     labelText: U_TextStrings.CompanyAddress,
          //     prefixIcon: Icon(Iconsax.home),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your Company Address';
          //     }
          //     return null;
          //   },
          // ),
          // const SizedBox(
          //   height: U_Sizes.inputFieldSpaceBtw,
          // ),
          TextFormField(
            controller: _photoController,
            decoration: InputDecoration(
              labelText: 'Photo',
              prefixIcon: Icon(Iconsax.image),
              suffixIcon: IconButton(
                icon: Icon(Iconsax.camera),
                onPressed: _pickImage,
              ),
            ),
            readOnly: true,
            // validator: (value) {
            //   if (_image == null) {
            //     return 'Please select a photo';
            //   }
            //   return null;
            // },
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  activeColor: U_Colors.yaleBlue,
                  value: _isChecked, // Use the state variable
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!; // Update the state variable
                    });
                  },
                ),
              ),
              const SizedBox(
                width: U_Sizes.spaceBtwItems,
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
                      color: dark ? Colors.white : U_Colors.yaleBlue,
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
                      color: dark ? Colors.white : U_Colors.yaleBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(
            height: U_Sizes.spaceBwtSections,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: U_Colors.yaleBlue,
                  disabledBackgroundColor: U_Colors.yaleBlue),
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
            ),
          ),)
        ],
      ),
    );
  }
}