import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/UserManagement/Feature-UserLogin/Screens/login_screen.dart';
import 'package:onpensea/config/ApiUrl.dart';
import 'package:onpensea/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/CustomTheme.dart';
import '../../../config/wallet_connect.dart';
import '../../../provider/AuthProvider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/CustomButton.dart';
import '../../Feature-Dashboard/Screens/common_dashboard_screen.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class OtpScreen4 extends StatefulWidget {
  const OtpScreen4(
      {Key? key,
      required this.name,
      required this.fatherName,
      required this.gender,
      required this.city,
      required this.state,
      required this.email,
      required this.mobileNumber,
      required this.aadharNumber,
      required this.panNumber})
      : super(key: key);

  final String name;
  final String fatherName;
  final String gender;
  final String city;
  final String state;
  final String email;
  final String mobileNumber;
  final String aadharNumber;
  final String panNumber;

  @override
  State<OtpScreen4> createState() => _OtpScreen4();
}

class _OtpScreen4 extends State<OtpScreen4> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? image;

  late W3MService _w3mService;

  @override
  void initState() {
    super.initState();
    initializeState();

  }

  void setWalletAddress() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("walletAddress", getUserWalletAddress().toString());
  }

  static const projectId = WalletConnect.projectId;
  static const _chainId = "11155111";

  final _sepoliaChain = W3MChainInfo(
      chainName: "Sepolia",
      chainId: _chainId,
      namespace: "eip155:$_chainId",
      tokenName: "ETH",
      rpcUrl: "https://rpc.sepolia.org/",
      blockExplorer: W3MBlockExplorer(
          name: 'Sepolia Explorer', url: 'https://sepolia.etherscan.io'));

  void initializeState() async {
    W3MChainPresets.chains.putIfAbsent(_chainId, () => _sepoliaChain);
    _w3mService = W3MService(
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'O3',
        description: 'Real Estate Tokenization',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'w3m://', // your own custom scheme
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();
  }

  String? getUserWalletAddress() {
    if (_w3mService.isConnected && _w3mService.session != null) {
      var address = _w3mService.session?.address;
      print("My wallet address is : ${address!}");
      return address;
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomTheme.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomTheme.customLinearGradient,
          ),
          child: SafeArea(
            child: SizedBox(
              height: size.height,
              child: Center(
                child: buildCard(size),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    //for selecting image

    void selectImage() async {
      image = await pickImage(context);
      setState(() {});
    }

    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.01,
          ),

          InkWell(
            onTap: () => selectImage(),
            child: image == null
                ? const CircleAvatar(
                    backgroundColor: Colors.pinkAccent,
                    radius: 50,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    ))
                : CircleAvatar(backgroundImage: FileImage(image!), radius: 50),
          ),

          SizedBox(
            height: size.height * 0.05,
          ),

          //email & password textField
          ///userTypeControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          addressControllerTextField(size),
          SizedBox(
            height: size.height * 0.03,
          ),

          passwordControllerTextField(size),
          //this is the gender controller
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 12, 24, 0),
            child: Text("Do you wish to connect metamask? You can register without metamask?."),
          ),
          SizedBox(
            height: 10,
          ),
          W3MConnectWalletButton(service: _w3mService),
          SizedBox(
            height: size.height * 0.1,
          ),

          // SizedBox(
          //   height: size.height * 0.04,
          // ),
          combineButtons(),
        ],
      ),
    );
  }

  Widget combineButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                child: CustomButton(
                  text: "Back",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8.0),
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      var durationOne = Duration(seconds: 3);
                      EasyLoading.show(status: 'Registring...');
                      Timer(durationOne, () {
                        setWalletAddress();
                        sendPostRequest().then((res) => {
                              print("-----------------------------------"),
                              print(res),
                              if (res)
                                {
                                  EasyLoading.showSuccess(
                                      "Registration successfull"),
                                  Timer(const Duration(seconds: 2), () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  })
                                }
                              else
                                {
                                  EasyLoading.showError("Failed to save data"),
                                  Timer(durationOne, () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  })
                                },
                            });
                      });
                    } else {
                      EasyLoading.showError("Profile Picture not selected");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    backgroundColor: Colors.purple.shade900,
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userTypeControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: userTypeController,
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter UserType',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: userTypeController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: userTypeController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.supervised_user_circle,
              color: userTypeController.text.isEmpty
                  ? const Color(0xFF66CD).withOpacity(0.5)
                  : const Color.fromRGBO(255, 102, 190, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(255, 102, 190, 1),
              ),
              child: userTypeController.text.isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: passwordController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Enter password',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: passwordController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: passwordController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: passwordController.text.isEmpty
                  ? const Color(0xFF66CD).withOpacity(0.5)
                  : const Color.fromRGBO(255, 102, 190, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(255, 102, 190, 1),
              ),
              child: passwordController.text.isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addressControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: addressController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            hintText: 'Enter Address',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: addressController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: addressController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.pin_drop,
              color: addressController.text.isEmpty
                  ? const Color(0xFF66BE).withOpacity(0.5)
                  : const Color.fromRGBO(255, 102, 190, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(255, 102, 190, 1),
              ),
              child: addressController.text.isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendPostRequest() async {
    String url = "${ApiUrl.API_URL_USERMANAGEMENT}user/register";
    //String url = "http://10.0.2.2:11000/user/register";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? walletAddress = await prefs.getString("walletAddress");

    print("wallet address before submitting is: $walletAddress");

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['walletAddress'] = walletAddress! ?? "NA";
      request.fields['name'] = widget.name;
      request.fields['fatherName'] = widget.fatherName;
      request.fields['geneder'] = widget.gender;
      request.fields['city'] = widget.city;
      request.fields['state'] = widget.state;
      request.fields['email'] = widget.email;
      request.fields['mobileNo'] = widget.mobileNumber;
      request.fields['aadharNo'] = widget.aadharNumber;

      request.fields['panNo'] = widget.panNumber;
      request.fields['userType'] = "USER";
      request.fields['password'] = passwordController.text;
      request.fields['address'] = addressController.text;

      request.files
          .add(await http.MultipartFile.fromPath('photo', image!.path));

      print("imagess-----------------------");
      print(image!.path);

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print(respStr);
      print(response.statusCode);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return Future<bool>.value(true);
      }
    } catch (e) {
      print("$e");
    }
    return Future<bool>.value(false);
  }

//store user data to firestore database
//   void storeData() async {
//     var duration = Duration(seconds: 2);
//     final ap = Provider.of<AuthProvider>(context, listen: false);
//     UserModel usermodel = UserModel(
//         name: widget.name,
//         fatherName: widget.fatherName,
//         geneder: widget.gender,
//         city: widget.city,
//         state: widget.state,
//         email: widget.email,
//         mobile: widget.mobileNumber,
//         aadhar: widget.aadharNumber,
//         pan: widget.panNumber,
//         userType: userTypeController.text.trim(),
//         password: passwordController.text.trim(),
//         address: addressController.text.trim(),
//         profilePic: "");
//
//     ap.saveUserDataToFirebase(
//         context: context,
//         userModel: usermodel,
//         profilePic: image!,
//         onSuccess: () {
//           //once data is saved we need to store locally also
//           ap.saveUserDataToSP().then(
//                 (value) => ap.setSignIn().then((value) => {
//                       EasyLoading.showSuccess("Registration successfull"),
//                       Timer(duration, () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginScreen()));
//                       })
//                     }),
//               );
//         });
//   }
}
